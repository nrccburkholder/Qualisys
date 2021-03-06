﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CEM.Exporting.DataProviders;
using System.Data;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;
using System.Configuration;
using CEM.Exporting.Configuration;
using NRC.Logging;
using CEM.Exporting.XmlExporters;
using CEM.Exporting.Enums;
using CEM.Exporting.TextFileExporters;



namespace CEM.Exporting
{
    public static class Exporter
    {

        private static string EventSource = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
        private static string EventClass = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.Name;

        public static List<string> Messages = new List<string>();

        /// <summary>
        /// Creates and saves Export files
        /// </summary>
        public static List<string> MakeFiles()
        {
            List<ExportQueueFile> queuefiles = ExportQueueFile.Select(new ExportQueueFile { FileState = 0});
            GenerateFiles(queuefiles);

            return Messages;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="queuefiles"></param>
        public static List<string> MakeFiles(List<ExportQueueFile> queuefiles)
        {
            GenerateFiles(queuefiles);

            return Messages;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="queuefiles"></param>
        private static void GenerateFiles(List<ExportQueueFile> queuefiles)
        {
            Messages.Clear(); 

            string targetFileLocation = SystemParams.Params.GetParam("FileLocation").StringValue;
            int iCnt = 0; // file counter

            if (queuefiles.Count > 0)
            {
                
                foreach (ExportQueueFile queuefile in queuefiles)
                {
                    List<ExportQueue> queues = ExportQueue.Select(new ExportQueue { ExportQueueID = queuefile.ExportQueueID });

                    foreach (ExportQueue queue in queues)
                    {
                        ExportTemplate template = ExportTemplate.Select(new ExportTemplate { ExportTemplateName = queue.ExportTemplateName, ExportTemplateVersionMajor = queue.ExportTemplateVersionMajor, ExportTemplateVersionMinor = queue.ExportTemplateVersionMinor }, true).First();

                        List<ExportDataSet> exds = ExportDataSet.Select(new ExportDataSet { ExportQueueID = queue.ExportQueueID, FileMakerName = queuefile.FileMakerName }, template.Sections);

                        if (exds.Count > 0)
                        {
                            // Depending on the file type, we call the appropriate File Maker Methods
                            switch (queuefile.FileMakerType)
                            {
                                case (int)Enums.ExportFileTypes.Xml:

                                    if (MakeFile_XML(exds, targetFileLocation, template, queuefile))
                                    {
                                        iCnt++;
                                    }
                                    break;
                                default:

                                    int textFileCount = 0;

                                    if (MakeFile_Text(exds, targetFileLocation, template, queuefile, out textFileCount))
                                    {
                                        iCnt = iCnt + textFileCount;
                                    }
                                    break;
                            }
                        }
                    }
                }
            }
            else
            {
                Messages.Add("No files to process.");
            }

            Logs.Info("", "FILEMAKERSTATUS", string.Format("{0}|{1}", "FILECOUNT", iCnt.ToString()), EventSource, EventClass, System.Reflection.MethodBase.GetCurrentMethod().Name);
            Messages.Add(string.Format("{0}: {1}", "FILECOUNT", iCnt.ToString()));
        }

        /// <summary>
        /// Creates an XML file from the ExportDataSet.  Returns boolean indicating if the file was created successfully or not.
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="filename"></param>
        /// <param name="fileLocation"></param>
        /// <param name="template"></param>
        /// <param name="queuefile"></param>
        /// <returns>Boolean indicating if the file was created successfully or not.</returns>
        private static bool MakeFile_XML(List<ExportDataSet> ds, string fileLocation, ExportTemplate template, ExportQueueFile queuefile)
        {
            bool b = false;
            string filepath = string.Empty;
            try
            {
                string fileDestination = Path.Combine(fileLocation, template.ExportTemplateName);
           
                if (Enum.IsDefined(typeof(SurveyTypes), template.SurveyTypeID))
                {
                    XmlDocumentEx xmlDoc = new XmlDocumentEx();

                    BaseXmlExporter exporter = GetXmlExporter((SurveyTypes)template.SurveyTypeID);

                    xmlDoc = exporter.MakeExportXMLDocument(ds, template);

                    filepath = xmlDoc.IsValid == true ? fileDestination : Path.Combine(fileDestination, "error");

                    if (!Directory.Exists(filepath))
                    {
                        Directory.CreateDirectory(filepath);
                    }

                    filepath = Path.Combine(filepath, queuefile.FileMakerName+ ".xml");

                    xmlDoc.Save(filepath);

                    Int16 fileState = 0;

                    if (!xmlDoc.IsValid)
                    {
                        foreach (ExportValidationError eve in xmlDoc.ValidationErrorList)
                        {
                            //Logging to the database.  The elements of the message are pipe delimited, with the template name, queueid, queuefileid, the file name, and the validation error description
                            string message = string.Format("{0}|{1}|{2}|{3}|{4}", template.ExportTemplateName, queuefile.ExportQueueID.ToString(), queuefile.ExportQueueFileID.ToString(), Path.GetFileName(filepath), eve.ErrorDescription);
                            // TODO:  come up with standard EventTypes for the logging
                            Logs.Warn("", "XMLVALIDATIONERR", message, EventSource, EventClass, System.Reflection.MethodBase.GetCurrentMethod().Name);
                            Messages.Add("Validation Error: " + message);
                        }
                        fileState = 2;
                    }
                    else
                    {
                        fileState = 1;
                    }

                    Logs.Info("", "FILEMAKERSTATUS", string.Format("{0}|{1}", fileState == 1 ? "SUCCESS" : "INVALID", filepath), EventSource, EventClass, System.Reflection.MethodBase.GetCurrentMethod().Name);
                    Messages.Add(string.Format("{0} File: \"{1}\"", fileState == 1 ? "SUCCESS! " : "INVALID!", filepath));
                    // Update the ExportQueueFile record to mark is a complete.
                    queuefile.FileState = fileState;
                    queuefile.FileMakerDate = DateTime.Now;
                    queuefile.Template = template;
                    queuefile.Save();

                    b = true;
                }
                else
                {
                    string msg = string.Format("SurveyType_id {0} has no matching SurveyType enumeration!", template.SurveyTypeID.ToString());
                    throw new Exception("msg");
                }
            }
            catch (Exception ex)
            {
                Logs.Error("", "XMLFILECREATIONERR", "Error Creating XML file: " + filepath, EventSource, EventClass, System.Reflection.MethodBase.GetCurrentMethod().Name, ex);
                Messages.Add(string.Format("Error Message: {0}", ex.Message));
                Messages.Add(string.Format("Stack Trace: {0}", ex.StackTrace));
            }
            return b;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="defaultname"></param>
        /// <param name="ds"></param>
        private static void SetFileName(ref string defaultname, ExportDataSet ds)
        {
            int iBracketStart = 0;
            int iBracketEnd = 0;

            if (ds.DataTable.Rows.Count > 0)
            {
                DataRow dr = ds.DataTable.Rows[0];
                if (defaultname.Contains("{"))
                {
                    iBracketStart = defaultname.IndexOf("{");

                    while (iBracketStart != -1)
                    {
                        iBracketEnd = defaultname.IndexOf("}", iBracketStart);

                        int iPlaceHolderLength = (iBracketEnd - iBracketStart) + 1;

                        string fieldname = defaultname.Substring(iBracketStart + 1, (iBracketEnd - iBracketStart) - 1);

                        string replacementValue = dr[fieldname].ToString();

                        defaultname = defaultname.Replace(defaultname.Substring(iBracketStart, iPlaceHolderLength), replacementValue);

                        iBracketStart = defaultname.IndexOf("{");

                    }
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="surveyType"></param>
        /// <returns></returns>
        private static BaseXmlExporter GetXmlExporter(SurveyTypes surveyType )
        {
            switch (surveyType)
            {
                case SurveyTypes.ICHCAHPS:
                    return new XMLExporter_ICH();
                case SurveyTypes.HospiceCAHPS:
                    return new XMLExporter_Hospice();
                case SurveyTypes.OAS:
                    return new XMLExporter_OAS();
                default:
                    return null;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="fileLocation"></param>
        /// <param name="template"></param>
        /// <param name="queuefile"></param>
        /// <returns></returns>
        private static bool MakeFile_Text(List<ExportDataSet> ds, string fileLocation, ExportTemplate template, ExportQueueFile queuefile, out int fileCount)
        {
            bool b = false;
            int iCnt = 0;
            try
            {
                List<string> files = new List<string>();

                if (Enum.IsDefined(typeof(SurveyTypes), template.SurveyTypeID))
                {
                    if (Enum.IsDefined(typeof(ExportFileTypes), queuefile.FileMakerType))
                    {

                        TextFileExporter exporter = new TextFileExporter(template, (ExportFileTypes)queuefile.FileMakerType); 
            
                        bool isSuccess = exporter.MakeExportTextFile(ds, fileLocation, queuefile.FileMakerName, out files);

                        Int16 fileState;

                        if (isSuccess == false)
                        {
                            fileState = 2;  
                        }
                        else
                        {
                            fileState = 1;  // successfully created
                        }

                        foreach (string file in files)
                        {
                            Logs.Info("", "FILEMAKERSTATUS", string.Format("{0}|{1}", fileState == 1 ? "SUCCESS" : "ERROR", file), EventSource, EventClass, System.Reflection.MethodBase.GetCurrentMethod().Name);
                            Messages.Add(string.Format("{0} \"{1}\"", fileState == 1 ? "SUCCESS!  File Created: " : "ERROR", file));
                            iCnt++;
                        }
                 
                        // Update the ExportQueueFile record to mark it as complete.
                        queuefile.FileState = fileState;
                        queuefile.FileMakerDate = DateTime.Now;
                        queuefile.Template = template;
                        queuefile.Save();

                        b = true;

                    }
                    else
                    {
                        string msg = string.Format("FileMakerType {0} has no matching ExportFileType enumeration!", template.SurveyTypeID.ToString());
                        throw new Exception("msg");
                    }
                }
                else
                {
                    string msg = string.Format("SurveyType_id {0} has no matching SurveyType enumeration!", template.SurveyTypeID.ToString());
                    throw new Exception("msg");

                }
            }
            catch (Exception ex)
            {
                Logs.Error("", "TEXTFILECREATIONERR", "Error Creating XML file.", EventSource, EventClass, System.Reflection.MethodBase.GetCurrentMethod().Name, ex);
                Messages.Add(string.Format("{0}{1}{2}",ex.Message, Environment.NewLine, ex.StackTrace));
            }

            fileCount = iCnt;
            return b;
        }

    }

}
