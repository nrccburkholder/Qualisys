using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using Nrc.CatalystExporter.DataAccess;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;
using OfficeOpenXml;
using System.Threading.Tasks;
using System.Threading;
using System.Text.RegularExpressions;

namespace Nrc.CatalystExporter.FileCreationEngine
{
    public class FileCreationHelper
    {
        private static Semaphore sem = new Semaphore(3, 3);
        private ExportLogAccess _logAccess = new ExportLogAccess();
        private CatalystDatamartAccess _catalystAccess = new CatalystDatamartAccess();

        public void CreateFileForExportLog(long exportLogId, UserContext user)
        {
            sem.WaitOne();
            try
            {
                Task.Factory.StartNew(() =>
                {
                    var log = _logAccess.Find_IncludeColumns(exportLogId, user);
                    try
                    {
                        bool success = WriteExportToFile(exportLogId, user);

                        log.FileCreationCompleteTime = DateTime.Now;
                        _logAccess.Save(log, user);

                        SendNotification(log.Location, log.CreatedBy, success);

                        Logger.Log(string.Format("New Export Log Created \r\n{0}", log.ExportLogToString()), System.Diagnostics.TraceEventType.Information, user);

                    }
                    catch (Exception e)
                    {
                        Logger.Log(e, user);
                        SendNotification(log.Location, log.CreatedBy, false);
                    }
                },
                CancellationToken.None, TaskCreationOptions.LongRunning, TaskScheduler.Current);
            }
            finally
            {
                sem.Release(1);
            }
        }

        private void SendNotification(string fileLocation, string user, bool success)
        {
            string SMTPServer = System.Configuration.ConfigurationManager.AppSettings["SMTPServer"];

            if (!string.IsNullOrWhiteSpace(SMTPServer))
            {
                try
                {
                    string emailAddress = user.Substring(user.LastIndexOf(@"\") + 1) + "@nationalresearch.com";

                    System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage();
                    message.To.Add(emailAddress);
                    message.Subject = success ? "Catalyst Export File Creation Complete" : "Catalyst Export File Creation Failed";
                    message.From = new System.Net.Mail.MailAddress("catalystexport@nationalresearch.com");
                    message.Body = success ? string.Format("Your file is located at {0}", fileLocation.Substring(0, fileLocation.LastIndexOf(@"\"))) : fileLocation;
                    System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient(SMTPServer);
                    smtp.Send(message);
                }
                catch (Exception ex)
                {
                    Logger.Log(ex, new UserContext("FileCreationService"));
                }
            }
        }

        private bool WriteExportToFile(long logId, UserContext user)
        {
            var log = _logAccess.Find_IncludeColumns(logId, user);

            if (log != null)
            {
                //On combined files the type, delimiter,cols, struct, and date type should be identical so just grab them from the first.
                FileType type = (FileType)log.FileDefinitions.FirstOrDefault().FileType;
                string delimiter = log.FileDefinitions.FirstOrDefault().Delimiter;
                List<ColumnDefinition> cols = log.FileDefinitions.FirstOrDefault().Columns;
                FileStructureType structType = (FileStructureType)log.FileDefinitions.FirstOrDefault().FileStructureType;
                ExportDateType dateType = (ExportDateType)log.FileDefinitions.FirstOrDefault().ExportDateType;

                List<ExportResult> data = new List<ExportResult>();
                List<SamplePopulationBackgroundField> bgFields = new List<SamplePopulationBackgroundField>();

                foreach (FileDefinition fdef in log.FileDefinitions)
                {
                    data.AddRange(_catalystAccess.FindMany_ExportResult(fdef.SurveyId, fdef.StudyId, log.StartDate, log.EndDate, dateType, user));
                }

                bgFields.AddRange(_catalystAccess.FindManyBySampPopIds_SampPopBgField(data.Select(d => d.CatalystSamplePopulationId).Distinct().ToArray(),
                    cols.OrderBy(f => f.ColumnOrder).Select(f => f.FieldName).ToArray(), user));

                return WriteExportToFile(type, delimiter, cols, user, log.Location, structType, data.ToArray(), bgFields.ToArray());

            }
            else
            {
                Logger.Log(new Exception(string.Format("Log {0} does not exist", logId)), user);
                return false;
            }
        }

        //Does actual work of running the export
        private bool WriteExportToFile(FileType type, string delimiter,
            IEnumerable<ColumnDefinition> fields, UserContext user, string location, FileStructureType structure, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            bool success = false;
            Directory.CreateDirectory(Path.GetDirectoryName(location));

            switch (type)
            {
                case FileType.CSV:
                    if (structure == FileStructureType.Stacked)
                        success = WriteToStackedDelimitedFile(user, fields, location, ',', data, bgFields);
                    else
                        success = WriteToRawDelimitedFile(user, fields, location, ',', data, bgFields);
                    break;
                case FileType.XLSX:
                    if (structure == FileStructureType.Stacked)
                        success = WriteToStackedXlsxFile(user, fields, location, data, bgFields);
                    else
                        success = WriteToRawXlsxFile(user, fields, location, data, bgFields);
                    break;
                case FileType.XLS:
                    if (structure == FileStructureType.Stacked)
                        success = WriteToStackedXlsFile(user, fields, location, data, bgFields);
                    else
                        success = WriteToRawXlsFile(user, fields, location, data, bgFields);
                    break;
                default:
                    var delim = delimiter.FirstOrDefault();
                    if (string.IsNullOrEmpty(delimiter))
                        delim = ',';
                    else if (delimiter.Contains('\\'))
                    {
                        try
                        {
                            delim = System.Text.RegularExpressions.Regex.Unescape(delimiter).FirstOrDefault();
                        }
                        catch (ArgumentException)
                        {
                            //Invalid escape sequence, keep string as is and the delimiter will be the first char
                        }
                    }

                    if (structure == FileStructureType.Stacked)
                        success = WriteToStackedDelimitedFile(user, fields, location, delim, data, bgFields);
                    else
                        success = WriteToRawDelimitedFile(user, fields, location, delim, data, bgFields);
                    break;
            }
            return success;
        }

        //Writes a csv or delimited file
        #region Delimited
        private static bool WriteToStackedDelimitedFile(UserContext user, IEnumerable<ColumnDefinition> fields, string location, char delimiter, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            try
            {
                //Ensure correct column order
                fields = fields.OrderBy(f => f.ColumnOrder);
                using (StreamWriter sw = new StreamWriter(new FileStream(location, FileMode.Create), Encoding.Unicode))
                {
                    sw.WriteLine(WriteDelimitedRow(fields.Select(f => f.DisplayName).ToList(), delimiter));

                    //Loop to write rows
                    foreach (var response in data)
                    {
                        var respBgFields = bgFields.Where(f => f.SamplePopulationID == response.CatalystSamplePopulationId);
                        List<string> row = new List<string>();
                        foreach (var fieldName in fields)
                        {
                            Type type;
                            row.Add(ParseField(response, respBgFields, fieldName, out type));
                        }
                        sw.WriteLine(WriteDelimitedRow(row, delimiter));
                    }
                    sw.Flush();
                }

                return true;
            }
            catch (Exception e)
            {
                Logger.Log(e, user);
                try
                {
                    using (StreamWriter sw = new StreamWriter(new FileStream(location, FileMode.Create), Encoding.Unicode))
                    {
                        sw.WriteLine("An error occurred when creating this file.");
                        sw.WriteLine(e.Message);
                        sw.WriteLine(e.StackTrace);
                        sw.Flush();
                    }
                }
                catch { }
                return false;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        private static bool WriteToRawDelimitedFile(UserContext user, IEnumerable<ColumnDefinition> fields, string location, char delimiter, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            try
            {
                IEnumerable<int?> questionNumbers;
                IEnumerable<string> commentLabels;
                IOrderedEnumerable<ColumnDefinition> questionFields;
                IOrderedEnumerable<ColumnDefinition> commentFields;
                IOrderedEnumerable<ColumnDefinition> demographicFields;
                IEnumerable<string> headers;
                RawFileSetup(fields, data, out questionNumbers, out commentLabels, out questionFields, out commentFields, out demographicFields, out headers);

                using (StreamWriter sw = new StreamWriter(new FileStream(location, FileMode.Create), Encoding.Unicode))
                {
                    sw.WriteLine(WriteDelimitedRow(headers.ToList(), delimiter));

                    foreach (var respondent in data.GroupBy(d => new { d.CatalystSamplePopulationId, d.CatalystSampleUnitId }))
                    {
                        var demoData = respondent.First();
                        var respBgFields = bgFields.Where(f => f.SamplePopulationID == demoData.CatalystSamplePopulationId);
                        var row = new List<string>();

                        //Used for single questions with multiple answers
                        var multiAnswerQuestionRows = new List<List<string>>();

                        Type type;

                        //Write demographic data
                        foreach (var fieldName in demographicFields)
                        {
                            row.Add(ParseField(demoData, respBgFields, fieldName, out type));
                        }

                        //Write Question data
                        foreach (var questionNum in questionNumbers)
                        {
                            var question = respondent.Where(q => q.QuestionNumber == questionNum).FirstOrDefault();

                            if (respondent.Where(q => q.QuestionNumber == questionNum).Count() > 1)
                            {
                                //Found a question with multiple answers. Create a new row for each answer and keep them in a collection ro bwe added later.
                                foreach (var multiAnswerQuestion in respondent.Where(q => q.QuestionNumber == questionNum))
                                {
                                    if (multiAnswerQuestion != question)
                                    {
                                        string[] newRow = new string[row.Count()];
                                        row.CopyTo(newRow);
                                        multiAnswerQuestionRows.Add(newRow.ToList());

                                        foreach (var MultiAnswerRow in multiAnswerQuestionRows)
                                        {
                                            foreach (var fieldName in questionFields)
                                            {
                                                MultiAnswerRow.Add(ParseField(multiAnswerQuestion, respBgFields, fieldName, out type));
                                            }
                                        }
                                    }
                                }
                            }

                            if (question != null)
                            {
                                foreach (var fieldName in questionFields)
                                {
                                    row.Add(ParseField(question, respBgFields, fieldName, out type));
                                    foreach (var MultiAnswerRow in multiAnswerQuestionRows)
                                    {
                                        MultiAnswerRow.Add(ParseField(question, respBgFields, fieldName, out type));
                                    }
                                }
                            }
                            else
                            {
                                //Add blank entries since this question was not answered
                                row.AddRange(questionFields.Select(d => ""));

                                foreach (var MultiAnswerRow in multiAnswerQuestionRows)
                                {
                                    MultiAnswerRow.AddRange(questionFields.Select(d => ""));
                                }
                            }
                        }

                        //Write Comment data
                        foreach (var label in commentLabels)
                        {
                            var comment = respondent.Where(q => q.QuestionLabel == label).FirstOrDefault();
                            if (comment != null)
                            {
                                foreach (var fieldName in commentFields)
                                {
                                    row.Add(ParseField(comment, respBgFields, fieldName, out type));

                                    foreach (var MultiAnswerRow in multiAnswerQuestionRows)
                                    {
                                        MultiAnswerRow.Add(ParseField(comment, respBgFields, fieldName, out type));
                                    }
                                }
                            }
                            else
                            {
                                //Add blank entries since this question was not answered
                                row.AddRange(commentFields.Select(d => ""));

                                foreach (var MultiAnswerRow in multiAnswerQuestionRows)
                                {
                                    MultiAnswerRow.AddRange(commentFields.Select(d => ""));
                                }
                            }
                        }

                        sw.WriteLine(WriteDelimitedRow(row, delimiter));
                        foreach (var MultiAnswerRow in multiAnswerQuestionRows)
                        {
                            sw.WriteLine(WriteDelimitedRow(MultiAnswerRow, delimiter));
                        }
                    }

                    sw.Flush();
                }

                return true;
            }
            catch (Exception e)
            {
                Logger.Log(e, user);
                try
                {
                    using (StreamWriter sw = new StreamWriter(new FileStream(location, FileMode.Create), Encoding.Unicode))
                    {
                        sw.WriteLine("An error occurred when creating this file.");
                        sw.WriteLine(e.Message);
                        sw.WriteLine(e.StackTrace);
                        sw.Flush();
                    }
                }
                catch { }
                return false;
            }
        }

        //Used to format the row correctly
        private static string WriteDelimitedRow(List<string> row, char delimiter)
        {
            var hasDelim = row.Where(v => v.IndexOfAny(new char[] { '"', delimiter }) != -1).ToArray();
            foreach (string value in hasDelim)
            {
                // Special handling for values that contain comma or quote
                // Enclose in quotes and double up any double quotes
                row[row.IndexOf(value)] = string.Format("\"{0}\"", value.Replace("\"", "\"\""));
            }
            return string.Join(delimiter.ToString(), row);
        }
        #endregion

        //Writes an .xlsx file
        #region XLSX
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        private static bool WriteToStackedXlsxFile(UserContext user, IEnumerable<ColumnDefinition> fields, string location, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            try
            {
                int sheetCount = (int)Math.Truncate(fields.Count() / 16384.0) + 1;

                //Ensure correct column order
                fields = fields.OrderBy(f => f.ColumnOrder);
                using (ExcelPackage excel = new ExcelPackage())
                {
                    //Create initial sheet
                    var currentSheets = new ExcelWorksheet[sheetCount];
                    for (int i = 0; i < sheetCount; i++)
                    {
                        currentSheets[i] = excel.Workbook.Worksheets.Add("Sheet" + excel.Workbook.Worksheets.Count);
                    }

                    int row = 1;
                    int col = 1;
                    int sheetIndex = 0;
                    //Loop to write headers
                    foreach (var displayName in fields.Select(f => f.DisplayName))
                    {
                        if (col >= 16384)
                        {
                            sheetIndex++;
                            col = 1;
                        }
                        currentSheets[sheetIndex].Cells[1, col].Value = displayName;
                        col++;
                    }
                    row = 2;
                    foreach (var response in data)
                    {
                        if (row >= 1048576)//Passed row limit. Add new sheets
                        {
                            for (int i = 0; i < sheetCount; i++)
                            {
                                currentSheets[i] = excel.Workbook.Worksheets.Add("Sheet" + excel.Workbook.Worksheets.Count);
                            }
                            row = 1;
                            sheetIndex = 0;
                        }

                        if (row == 1)//Loop to write headers
                        {
                            col = 1;
                            foreach (var displayName in fields.Select(f => f.DisplayName))
                            {
                                if (col >= 16384)
                                {
                                    sheetIndex++;
                                    col = 1;
                                }
                                currentSheets[sheetIndex].Cells[1, col].Value = displayName;
                                col++;
                            }
                            row = 2;
                        }

                        var respBgFields = bgFields.Where(f => f.SamplePopulationID == response.CatalystSamplePopulationId);
                        col = 1;
                        foreach (var fieldName in fields)
                        {
                            if (col >= 16384)
                            {
                                sheetIndex++;
                                col = 1;
                            }

                            Type type;

                            string val = ParseField(response, respBgFields, fieldName, out type);

                            try
                            {
                                if (type == typeof(DateTime))
                                {
                                    currentSheets[sheetIndex].Cells[row, col].Value = val;
                                }
                                else if (type == typeof(double) || type == typeof(int) || type == typeof(long))
                                {
                                    double numericVal;
                                    if (double.TryParse(val, out numericVal))
                                    {
                                        currentSheets[sheetIndex].Cells[row, col].Value = numericVal;
                                    }
                                    else
                                    {
                                        currentSheets[sheetIndex].Cells[row, col].Value = val;
                                    };
                                }
                                else
                                {
                                    currentSheets[sheetIndex].Cells[row, col].Value = val;
                                }
                            }
                            catch (Exception)
                            {
                                currentSheets[sheetIndex].Cells[row, col].Value = val;
                            }

                            col++;
                        }
                        row++;
                    }

                    var stream = new FileStream(location, FileMode.Create);
                    try
                    {
                        excel.SaveAs(stream);
                        stream.Flush();

                    }
                    finally
                    {
                        stream.Dispose();
                    }
                }
                return true;
            }
            catch (Exception e)
            {
                Logger.Log(e, user);
                var stream = new FileStream(location, FileMode.Create);
                try
                {
                    using (ExcelPackage excel = new ExcelPackage())
                    {
                        var sheet = excel.Workbook.Worksheets.Add("Sheet1");
                        sheet.Cells[1, 1].Value = "An error occurred when creating this file.";
                        sheet.Cells[2, 1].Value = e.Message;
                        sheet.Cells[3, 1].Value = e.StackTrace;

                        excel.SaveAs(stream);
                        stream.Flush();
                    }
                }
                finally
                {
                    stream.Dispose();
                }
                return false;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        private static bool WriteToRawXlsxFile(UserContext user, IEnumerable<ColumnDefinition> fields, string location, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            try
            {
                IEnumerable<int?> questionNumbers;
                IEnumerable<string> commentLabels;
                IOrderedEnumerable<ColumnDefinition> questionFields;
                IOrderedEnumerable<ColumnDefinition> commentFields;
                IOrderedEnumerable<ColumnDefinition> demographicFields;
                IEnumerable<string> headers;
                RawFileSetup(fields, data, out questionNumbers, out commentLabels, out questionFields, out commentFields, out demographicFields, out headers);

                int sheetCount = (int)Math.Truncate(headers.Count() / 16384.0) + 1;

                using (ExcelPackage excel = new ExcelPackage())
                {
                    //Create initial sheet
                    int sheetNum = 1;
                    var currentSheets = new ExcelWorksheet[sheetCount];
                    for (int i = 0; i < sheetCount; i++)
                    {
                        currentSheets[i] = excel.Workbook.Worksheets.Add("Sheet" + sheetNum);
                        sheetNum++;
                    }

                    int row = 1;
                    int col = 1;
                    int sheetIndex = 0;
                    //Loop to write headers
                    foreach (var displayName in headers)
                    {
                        if (col >= 16384)
                        {
                            sheetIndex++;
                            col = 1;
                        }
                        currentSheets[sheetIndex].Cells[1, col].Value = displayName;
                        col++;
                    }
                    row = 2;
                    foreach (var respondent in data.GroupBy(d => new { d.CatalystSamplePopulationId, d.CatalystSampleUnitId }))
                    {
                        if (row >= 1048576)//Passed row limit. Add new sheet
                        {
                            for (int i = 0; i < sheetCount; i++)
                            {
                                currentSheets[i] = excel.Workbook.Worksheets.Add("Sheet" + sheetNum);
                            }
                            row = 1;
                            sheetIndex = 0;
                            sheetNum++;
                        }

                        if (row == 1)//Loop to write headers
                        {
                            col = 1;
                            foreach (var displayName in headers)
                            {
                                if (col >= 16384)
                                {
                                    sheetIndex++;
                                    col = 1;
                                }
                                currentSheets[sheetIndex].Cells[1, col].Value = displayName;
                                col++;
                            }
                            row = 2;
                        }

                        var demoData = respondent.First();
                        var respBgFields = bgFields.Where(f => f.SamplePopulationID == demoData.CatalystSamplePopulationId);
                        col = 1;
                        //Write demographic data
                        foreach (var fieldName in demographicFields)
                        {
                            if (col >= 16384)
                            {
                                sheetIndex++;
                                col = 1;
                            }

                            Type type;

                            string val = ParseField(demoData, respBgFields, fieldName, out type);

                            try
                            {
                                if (type == typeof(DateTime))
                                {
                                    currentSheets[sheetIndex].Cells[row, col].Value = val;
                                }
                                else if (type == typeof(double) || type == typeof(int) || type == typeof(long))
                                {
                                    double numericVal;
                                    if (double.TryParse(val, out numericVal))
                                    {
                                        currentSheets[sheetIndex].Cells[row, col].Value = numericVal;
                                    }
                                    else
                                    {
                                        currentSheets[sheetIndex].Cells[row, col].Value = val;
                                    };
                                }
                                else
                                {
                                    currentSheets[sheetIndex].Cells[row, col].Value = val;
                                }
                            }
                            catch (Exception)
                            {
                                currentSheets[sheetIndex].Cells[row, col].Value = val;
                            }

                            //currentSheets[sheetIndex].Cells[row, col].Value = ParseField(demoData, respBgFields, fieldName);
                            col++;
                        }
                        //Write Question data
                        foreach (var questionNum in questionNumbers)
                        {
                            var question = respondent.Where(q => q.QuestionNumber == questionNum).FirstOrDefault();
                            if (question != null)
                            {
                                foreach (var fieldName in questionFields)
                                {
                                    if (col >= 16384)
                                    {
                                        sheetIndex++;
                                        col = 1;
                                    }

                                    Type type;

                                    string val = ParseField(question, respBgFields, fieldName, out type);

                                    try
                                    {
                                        if (type == typeof(DateTime))
                                        {
                                            currentSheets[sheetIndex].Cells[row, col].Value = val;
                                        }
                                        else
                                        {
                                            double numericVal;
                                            if (double.TryParse(val, out numericVal))
                                            {
                                                currentSheets[sheetIndex].Cells[row, col].Value = numericVal;
                                            }
                                            else
                                            {
                                                currentSheets[sheetIndex].Cells[row, col].Value = val;
                                            };
                                        }
                                    }
                                    catch (Exception)
                                    {
                                        currentSheets[sheetIndex].Cells[row, col].Value = val;
                                    }

                                    //currentSheets[sheetIndex].Cells[row, col].Value = ParseField(question, respBgFields, fieldName);
                                    col++;
                                }
                            }
                            else
                            {
                                //Add blank entries since this question was not answered
                                for (int i = 0; i < questionFields.Count(); i++)
                                {
                                    if (col >= 16384)
                                    {
                                        sheetIndex++;
                                        col = 1;
                                    }
                                    currentSheets[sheetIndex].Cells[row, col].Value = "";
                                    col++;
                                }
                            }
                        }
                        //Write Comment data
                        foreach (var label in commentLabels)
                        {
                            var comment = respondent.Where(q => q.QuestionLabel == label).FirstOrDefault();
                            if (comment != null)
                            {
                                foreach (var fieldName in commentFields)
                                {
                                    if (col >= 16384)
                                    {
                                        sheetIndex++;
                                        col = 1;
                                    }
                                    Type type;

                                    string val = ParseField(comment, respBgFields, fieldName, out type);

                                    try
                                    {
                                        if (type == typeof(DateTime))
                                        {
                                            currentSheets[sheetIndex].Cells[row, col].Value = val;
                                        }
                                        else
                                        {
                                            double numericVal;
                                            if (double.TryParse(val, out numericVal))
                                            {
                                                currentSheets[sheetIndex].Cells[row, col].Value = numericVal;
                                            }
                                            else
                                            {
                                                currentSheets[sheetIndex].Cells[row, col].Value = val;
                                            };
                                        }
                                    }
                                    catch (Exception)
                                    {
                                        currentSheets[sheetIndex].Cells[row, col].Value = val;
                                    }

                                    //currentSheets[sheetIndex].Cells[row, col].Value = ParseField(comment, respBgFields, fieldName);
                                    col++;
                                }
                            }
                            else
                            {
                                //Add blank entries since this question was not answered
                                for (int i = 0; i < commentFields.Count(); i++)
                                {
                                    if (col >= 16384)
                                    {
                                        sheetIndex++;
                                        col = 1;
                                    }
                                    currentSheets[sheetIndex].Cells[row, col].Value = "";
                                    col++;
                                }
                            }
                        }
                        row++;
                    }

                    var stream = new FileStream(location, FileMode.Create);
                    try
                    {
                        excel.SaveAs(stream);
                        stream.Flush();

                    }
                    finally
                    {
                        stream.Dispose();
                    }
                }
                return true;
            }
            catch (Exception e)
            {
                Logger.Log(e, user);
                var stream = new FileStream(location, FileMode.Create);
                try
                {
                    using (ExcelPackage excel = new ExcelPackage())
                    {
                        var sheet = excel.Workbook.Worksheets.Add("Sheet1");
                        sheet.Cells[1, 1].Value = "An error occurred when creating this file.";
                        sheet.Cells[2, 1].Value = e.Message;
                        sheet.Cells[3, 1].Value = e.StackTrace;

                        excel.SaveAs(stream);
                        stream.Flush();
                    }
                }
                finally
                {
                    stream.Dispose();
                }
                return false;
            }
        }
        #endregion

        //Writes an .xls file
        #region XLS
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        private static bool WriteToStackedXlsFile(UserContext user, IEnumerable<ColumnDefinition> fields, string location, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            try
            {
                //Ensure correct column order
                fields = fields.OrderBy(f => f.ColumnOrder);

                double maxRowCount = 65535;
                if (fields.Count() > 50)
                    maxRowCount = 32768;
                int columnSheetCount = (int)Math.Ceiling(fields.Count() / 256.0);
                int totalFileCount = (int)Math.Ceiling(data.Count() / maxRowCount);
                int fileCount = 1; //Running count of files we have created

                var hssfworkbook = new HSSFWorkbook();
                var currentSheets = new ISheet[columnSheetCount];
                for (int i = 0; i < columnSheetCount; i++)
                {
                    currentSheets[i] = hssfworkbook.CreateSheet();
                }

                int row = 0;
                int col = 0;
                int sheetIndex = 0;
                //Loop to write headers
                var headerRow = currentSheets[sheetIndex].CreateRow(0);
                foreach (var displayName in fields.Select(f => f.DisplayName))
                {
                    if (col >= 256)
                    {
                        sheetIndex++;
                        headerRow = currentSheets[sheetIndex].CreateRow(0);
                        col = 0;
                    }
                    headerRow.CreateCell(col).SetCellValue(displayName);
                    col++;
                }
                //Loop to write rows
                IEnumerable<SamplePopulationBackgroundField> respBgFields;
                IRow rowData;
                row = 1;
                foreach (var response in data)
                {
                    if (row >= maxRowCount)//Passed row limit.
                    {
                        //Save this mini file
                        var loc = location.Substring(0, location.Length - 4);
                        loc = loc + "_" + fileCount + "of" + totalFileCount + ".xls";
                        var ministream = new FileStream(loc, FileMode.Create);
                        try
                        {
                            hssfworkbook.Write(ministream);
                            ministream.Flush();

                        }
                        finally
                        {
                            ministream.Dispose();
                            fileCount++;
                        }
                        //Set hssfworkbook to new Workbook
                        hssfworkbook = new HSSFWorkbook();
                        //Create new sheets
                        for (int i = 0; i < columnSheetCount; i++)
                        {
                            currentSheets[i] = hssfworkbook.CreateSheet();
                        }
                        row = 0;
                        sheetIndex = 0;
                    }
                    if (row == 0)//Loop to write headers
                    {
                        headerRow = currentSheets[sheetIndex].CreateRow(0);
                        col = 0;
                        foreach (var displayName in fields.Select(f => f.DisplayName))
                        {
                            if (col >= 256)
                            {
                                sheetIndex++;
                                headerRow = currentSheets[sheetIndex].CreateRow(0);
                                col = 0;
                            }
                            headerRow.CreateCell(col).SetCellValue(displayName);
                            col++;
                        }
                        row = 1;
                    }

                    sheetIndex = 0;
                    col = 0;
                    respBgFields = bgFields.Where(f => f.SamplePopulationID == response.CatalystSamplePopulationId);
                    rowData = currentSheets[sheetIndex].CreateRow(row);
                    foreach (var fieldName in fields)
                    {
                        if (col >= 256)
                        {
                            sheetIndex++;
                            rowData = currentSheets[sheetIndex].CreateRow(row);
                            col = 0;
                        }
                        Type type;

                        string val = ParseField(response, respBgFields, fieldName, out type);

                        try
                        {
                            if (type == typeof(DateTime))
                            {
                                rowData.CreateCell(col).SetCellValue(DateTime.Parse(val).ToShortDateString());
                            }
                            else if (type == typeof(double) || type == typeof(int) || type == typeof(long))
                            {

                                double numericVal;
                                if (double.TryParse(val, out numericVal))
                                {
                                    ICell dateCell = rowData.CreateCell(col);
                                    dateCell.SetCellValue(double.Parse(val));
                                }
                                else
                                {
                                    rowData.CreateCell(col).SetCellValue(val);
                                };
                            }
                            else
                            {
                                rowData.CreateCell(col).SetCellValue(val);
                            }
                        }
                        catch (Exception)
                        {
                            rowData.CreateCell(col).SetCellValue(val);
                        }


                        col++;
                    }
                    row++;
                }

                var locat = location;
                if (totalFileCount > 1)
                {
                    locat = location.Substring(0, location.Length - 4);
                    locat = locat + "_" + fileCount + "of" + totalFileCount + ".xls";
                }
                var stream = new FileStream(locat, FileMode.Create);
                try
                {
                    hssfworkbook.Write(stream);
                    stream.Flush();

                }
                finally
                {
                    stream.Dispose();
                }
                return true;
            }
            catch (Exception e)
            {
                Logger.Log(e, user);
                var stream = new FileStream(location, FileMode.Create);
                try
                {
                    var hssfworkbook = new HSSFWorkbook();
                    var sheet = hssfworkbook.CreateSheet();
                    var row = sheet.CreateRow(0);
                    row.CreateCell(0).SetCellValue("An error occurred when creating this file.");
                    row = sheet.CreateRow(1);
                    row.CreateCell(0).SetCellValue(e.Message);
                    row = sheet.CreateRow(2);
                    row.CreateCell(0).SetCellValue(e.StackTrace);

                    hssfworkbook.Write(stream);
                    stream.Flush();
                }
                finally
                {
                    stream.Dispose();
                }
                return false;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        private static bool WriteToRawXlsFile(UserContext user, IEnumerable<ColumnDefinition> fields, string location, ExportResult[] data, SamplePopulationBackgroundField[] bgFields)
        {
            try
            {
                IEnumerable<int?> questionNumbers;
                IEnumerable<string> commentLabels;
                IOrderedEnumerable<ColumnDefinition> questionFields;
                IOrderedEnumerable<ColumnDefinition> commentFields;
                IOrderedEnumerable<ColumnDefinition> demographicFields;
                IEnumerable<string> headers;
                RawFileSetup(fields, data, out questionNumbers, out commentLabels, out questionFields, out commentFields, out demographicFields, out headers);

                double maxRowCount = 65535;
                if (headers.Count() > 50)
                    maxRowCount = 32768;
                int columnSheetCount = (int)Math.Ceiling(headers.Count() / 256.0);
                int totalFileCount = (int)Math.Ceiling(data.GroupBy(d => d.CatalystSamplePopulationId).Count() / maxRowCount);
                int fileCount = 1; //Running count of files we have created

                var hssfworkbook = new HSSFWorkbook();
                var currentSheets = new ISheet[columnSheetCount];
                for (int i = 0; i < columnSheetCount; i++)
                {
                    currentSheets[i] = hssfworkbook.CreateSheet();
                }

                //Loop to write rows
                IEnumerable<SamplePopulationBackgroundField> respBgFields;
                IRow rowData;
                int row = 0;
                int col = 0;
                int sheetIndex = 0;
                //Loop to write headers
                var headerRow = currentSheets[sheetIndex].CreateRow(0);
                foreach (var displayName in headers)
                {
                    if (col >= 256)
                    {
                        sheetIndex++;
                        headerRow = currentSheets[sheetIndex].CreateRow(0);
                        col = 0;
                    }
                    headerRow.CreateCell(col).SetCellValue(displayName);
                    col++;
                }
                row = 1;
                foreach (var respondent in data.GroupBy(d => new { d.CatalystSamplePopulationId, d.CatalystSampleUnitId }))
                {
                    if (row >= maxRowCount)//Passed row limit. Add new sheet
                    {
                        //if (hssfworkbook.Workbook.NumSheets >= 2)
                        //{
                        //Save this mini file
                        var loc = location.Substring(0, location.Length - 4);
                        loc = loc + "_" + fileCount + "of" + totalFileCount + ".xls";
                        var ministream = new FileStream(loc, FileMode.Create);
                        try
                        {
                            hssfworkbook.Write(ministream);
                            ministream.Flush();

                        }
                        finally
                        {
                            ministream.Dispose();
                            fileCount++;
                        }
                        //Set hssfworkbook to new Workbook
                        hssfworkbook = new HSSFWorkbook();
                        //}
                        //Create new sheets
                        for (int i = 0; i < columnSheetCount; i++)
                        {
                            currentSheets[i] = hssfworkbook.CreateSheet();
                        }
                        row = 0;
                        sheetIndex = 0;
                    }
                    if (row == 0)//Loop to write headers
                    {
                        headerRow = currentSheets[sheetIndex].CreateRow(0);
                        col = 0;
                        foreach (var displayName in headers)
                        {
                            if (col >= 256)
                            {
                                sheetIndex++;
                                headerRow = currentSheets[sheetIndex].CreateRow(0);
                                col = 0;
                            }
                            headerRow.CreateCell(col).SetCellValue(displayName);
                            col++;
                        }
                        row = 1;
                    }

                    sheetIndex = 0;
                    col = 0;
                    var demoData = respondent.First();
                    respBgFields = bgFields.Where(f => f.SamplePopulationID == demoData.CatalystSamplePopulationId);
                    rowData = currentSheets[sheetIndex].CreateRow(row);
                    //Write demographic data
                    foreach (var fieldName in demographicFields)
                    {
                        if (col >= 256)
                        {
                            sheetIndex++;
                            rowData = currentSheets[sheetIndex].CreateRow(row);
                            col = 0;
                        }

                        Type type;

                        string val = ParseField(demoData, respBgFields, fieldName, out type);

                        try
                        {
                            if (type == typeof(DateTime))
                            {
                                rowData.CreateCell(col).SetCellValue(DateTime.Parse(val).ToShortDateString());
                            }

                            else if (type == typeof(double) || type == typeof(int) || type == typeof(long))
                            {
                                double numericVal;
                                if (double.TryParse(val, out numericVal))
                                {
                                    rowData.CreateCell(col).SetCellValue(numericVal);
                                }
                                else
                                {
                                    rowData.CreateCell(col).SetCellValue(val);
                                };
                            }
                            else
                            {
                                rowData.CreateCell(col).SetCellValue(val);
                            }
                        }
                        catch (Exception)
                        {
                            rowData.CreateCell(col).SetCellValue(val);
                        }

                        //rowData.CreateCell(col).SetCellValue(ParseField(demoData, respBgFields, fieldName));
                        col++;
                    }
                    //Write Question data
                    foreach (var questionNum in questionNumbers)
                    {
                        var question = respondent.Where(q => q.QuestionNumber == questionNum).FirstOrDefault();
                        if (question != null)
                        {
                            foreach (var fieldName in questionFields)
                            {
                                if (col >= 256)
                                {
                                    sheetIndex++;
                                    rowData = currentSheets[sheetIndex].CreateRow(row);
                                    col = 0;
                                }

                                Type type;

                                string val = ParseField(question, respBgFields, fieldName, out type);

                                try
                                {
                                    if (type == typeof(DateTime))
                                    {
                                        rowData.CreateCell(col).SetCellValue(DateTime.Parse(val).ToShortDateString());
                                    }
                                    else
                                    {
                                        double numericVal;
                                        if (double.TryParse(val, out numericVal))
                                        {
                                            rowData.CreateCell(col).SetCellValue(numericVal);
                                        }
                                        else
                                        {
                                            rowData.CreateCell(col).SetCellValue(val);
                                        };
                                    }
                                }
                                catch (Exception)
                                {
                                    rowData.CreateCell(col).SetCellValue(val);
                                }

                                //rowData.CreateCell(col).SetCellValue(ParseField(question, respBgFields, fieldName));
                                col++;
                            }
                        }
                        else
                        {
                            //Add blank entries since this question was not answered
                            for (int i = 0; i < questionFields.Count(); i++)
                            {
                                if (col >= 256)
                                {
                                    sheetIndex++;
                                    rowData = currentSheets[sheetIndex].CreateRow(row);
                                    col = 0;
                                }
                                rowData.CreateCell(col).SetCellValue("");
                                col++;
                            }
                        }
                    }
                    //Write Comment data
                    foreach (var label in commentLabels)
                    {
                        var comment = respondent.Where(q => q.QuestionLabel == label).FirstOrDefault();
                        if (comment != null)
                        {
                            foreach (var fieldName in commentFields)
                            {
                                if (col >= 256)
                                {
                                    sheetIndex++;
                                    rowData = currentSheets[sheetIndex].CreateRow(row);
                                    col = 0;
                                }

                                Type type;

                                string val = ParseField(comment, respBgFields, fieldName, out type);

                                try
                                {
                                    if (type == typeof(DateTime))
                                    {
                                        rowData.CreateCell(col).SetCellValue(DateTime.Parse(val).ToShortDateString());
                                    }
                                    else
                                    {
                                        double numericVal;
                                        if (double.TryParse(val, out numericVal))
                                        {
                                            rowData.CreateCell(col).SetCellValue(numericVal);
                                        }
                                        else
                                        {
                                            rowData.CreateCell(col).SetCellValue(val);
                                        };
                                    }
                                }
                                catch (Exception)
                                {
                                    rowData.CreateCell(col).SetCellValue(val);
                                }

                                //rowData.CreateCell(col).SetCellValue(ParseField(comment, respBgFields, fieldName));
                                col++;
                            }
                        }
                        else
                        {//Add blank entries since this question was not answered
                            for (int i = 0; i < commentFields.Count(); i++)
                            {
                                if (col >= 256)
                                {
                                    sheetIndex++;
                                    rowData = currentSheets[sheetIndex].CreateRow(row);
                                    col = 0;
                                }
                                rowData.CreateCell(col).SetCellValue("");
                                col++;
                            }
                        }
                    }
                    row++;
                }

                var locat = location;
                if (totalFileCount > 1)
                {
                    locat = location.Substring(0, location.Length - 4);
                    locat = locat + "_" + fileCount + "of" + totalFileCount + ".xls";
                }
                var stream = new FileStream(locat, FileMode.Create);
                try
                {
                    hssfworkbook.Write(stream);
                    stream.Flush();

                }
                finally
                {
                    stream.Dispose();
                }
                return true;
            }
            catch (Exception e)
            {
                Logger.Log(e, user);
                var stream = new FileStream(location, FileMode.Create);
                try
                {
                    var hssfworkbook = new HSSFWorkbook();
                    var sheet = hssfworkbook.CreateSheet();
                    var row = sheet.CreateRow(0);
                    row.CreateCell(0).SetCellValue("An error occurred when creating this file.");
                    row = sheet.CreateRow(1);
                    row.CreateCell(0).SetCellValue(e.Message);
                    row = sheet.CreateRow(2);
                    row.CreateCell(0).SetCellValue(e.StackTrace);

                    hssfworkbook.Write(stream);
                    stream.Flush();
                }
                finally
                {
                    stream.Dispose();
                }
                return false;
            }
        }
        #endregion

        private static string ParseField(ExportResult data, IEnumerable<SamplePopulationBackgroundField> respBgFields, ColumnDefinition field, out Type valueType)
        {
            var fieldName = field.FieldName;
            string result = "";
            Type type = data.GetType();
            if (type.GetProperty(fieldName) != null)
            {
                var val = type.GetProperty(fieldName).GetValue(data, null);

                valueType = val != null ? val.GetType() : typeof(string);

                if (val is DateTime)
                    result = val != null ? (val as DateTime?).Value.ToString("MM/dd/yyyy") : "";
                else
                    result = val != null ? val.ToString() : "";
            }
            else
            {
                valueType = typeof(string);

                var val = respBgFields.Where(f => f.ColumnName.Equals(fieldName, StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();
                result = val != null ? val.ColumnValue : "";
            }

            foreach (var replace in field.Replacements)
            {
                //result = result.Replace(replace.OldText, replace.NewText);                
                result = ReplaceWholeWord(result, replace.OldText, replace.NewText, RegexOptions.IgnoreCase);
            }

            return result;
        }

        static public string ReplaceWholeWord(string original, string wordToFind, string replacement, RegexOptions regexOptions = RegexOptions.None)
        {
            string pattern = String.Format(@"\b{0}\b", wordToFind);
            string ret = Regex.Replace(original, pattern, replacement, regexOptions);
            return ret;
        }

        private static void RawFileSetup(IEnumerable<ColumnDefinition> fields, ExportResult[] data, out IEnumerable<int?> questionNumbers, out IEnumerable<string> commentLabels, out IOrderedEnumerable<ColumnDefinition> questionFields, out IOrderedEnumerable<ColumnDefinition> commentFields, out IOrderedEnumerable<ColumnDefinition> demographicFields, out IEnumerable<string> headers)
        {
            //Ensure correct column order
            questionFields = fields.Where(f => f.IsQuestionData()).OrderBy(f => f.ColumnOrder);
            commentFields = fields.Where(f => f.IsCommentData()).OrderBy(f => f.ColumnOrder);
            demographicFields = fields.Except(questionFields).Except(commentFields).OrderBy(f => f.ColumnOrder);

            if (questionFields.Count() > 0)
                questionNumbers = data.Select(d => d.QuestionNumber).Distinct();
            else
                questionNumbers = new int?[0];

            if (commentFields.Count() > 0)
                commentLabels = data.Where(d => d.MaskedResponse != null).Select(d => d.QuestionLabel).Distinct();
            else
                commentLabels = new string[0];

            var qFields = questionFields.ToList();
            var cFields = commentFields.ToList();
            headers = demographicFields.Select(f => f.DisplayName)
                .Concat(questionNumbers.SelectMany(d => qFields.Select(q => q.DisplayName + " " + d.ToString())))
                .Concat(commentLabels.SelectMany(d => cFields.Select(q => q.DisplayName)));

        }

    }
}