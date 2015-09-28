using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data;
using CEM.Exporting.Enums;

namespace CEM.Exporting.TextFileExporters
{
    public class TextFileExporter
    {


        private Dictionary<int,List<ExportColumn>> columns;

        private ExportFileTypes fileMakerType;

        private string FileExtension
        {
            get 
            {
                switch (fileMakerType)
                {
                    case ExportFileTypes.CommaDelimitedCSV:
                        return "csv";
                    default:
                        return "txt";
                }
            }
        }


        public Dictionary<int, List<ExportColumn>> Columns
        {
            get { return columns; }
        }

        private ExportTemplate exportTemplate;

        public ExportTemplate Template
        {
            get { return exportTemplate; }
            set { exportTemplate = value; }
        }

        #region public members


        #endregion

        #region constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="template"></param>
        /// <param name="fileType"></param>
        public TextFileExporter(ExportTemplate template, ExportFileTypes fileType)
        {
            exportTemplate = template;
            fileMakerType = fileType;
            CreateColumns();
        }

        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dsList"></param>
        /// <param name="fileLocation"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public bool MakeExportTextFile(List<ExportDataSet> dsList, string fileLocation, string fileName)
        {
            bool result = false;

            try
            {
                string fileDestination = Path.Combine(fileLocation, exportTemplate.ExportTemplateName);

                if (!Directory.Exists(fileDestination))
                {
                    Directory.CreateDirectory(fileDestination);
                }

                string delimiter = GetDelimiter(fileMakerType);

                bool hasMultipleSections = dsList.Count > 1;

                foreach (ExportDataSet exds in dsList)
                {
                    string fname;

                    if (hasMultipleSections)
                    {
                        // For flatfile submissions that have multiple sections, we will create one file per section, using the Section.DefaultNamingConvention for the filename. 
                        // If there is no Section.DefaultNamingConvention, we will append the section name to the fileName (QueueFile.FileMakerName)
                        fname = string.IsNullOrEmpty(exds.Section.DefaultNamingConvention) ? string.Format("{0}_{1}", fileName, exds.Section.ExportTemplateSectionName) : exds.Section.DefaultNamingConvention;
                    }
                    else
                    {
                        fname = fileName;
                    }

                    string filepath = Path.Combine(fileDestination, string.Format("{0}.{1}", fname, FileExtension));

                    List<ExportColumn> columnList = columns.Where(x => x.Key == exds.Section.ExportTemplateSectionID).FirstOrDefault().Value;

                    string sectionName = exds.Section.ExportTemplateSectionName;

                    if (columnList.Count > 0)
                    {
                        using (System.IO.TextWriter txtWriter = new StreamWriter(filepath))
                        {
                            CreateFileHeader(txtWriter, columnList, delimiter);

                            foreach (DataRow dr in exds.DataTable.Rows)
                            {

                                foreach (ExportColumn column in columnList.OrderBy(x => x.ColumnOrder).ThenBy(x => x.MultiResponseOrder))
                                {
                                    string columnName = string.Format("{0}.{1}", sectionName, column.ExportColumnName);
                                    string value = dr[columnName].ToString().Trim();
                                    WriteColumn(txtWriter, column, value, delimiter);
                                }

                                txtWriter.Write(txtWriter.NewLine);
                            }
                        }
                      
                    }
                    else throw new Exception(string.Format("No columns found for section {0}!", exds.Section.ExportTemplateSectionName));
                }        

                result = true;

            }
            catch
            {
                throw;
            }
             
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="txtWriter"></param>
        /// <param name="columnList"></param>
        /// <param name="delimiter"></param>
        public void CreateFileHeader(TextWriter txtWriter, List<ExportColumn> columnList, string delimiter)
        {
            if (fileMakerType != ExportFileTypes.FixedWidthText)  // only make a header if it's NOT fixed width
            { 
                foreach (ExportColumn column in columnList.OrderBy(x => x.ColumnOrder).ThenBy(x => x.MultiResponseOrder))
                {
                    WriteColumn(txtWriter, column, column.ExportColumnName, delimiter);
                }

                txtWriter.Write(txtWriter.NewLine);
            }     
        }

        /// <summary>
        /// 
        /// </summary>
        private void CreateColumns()
        {
            columns = new Dictionary<int,List<ExportColumn>>();
            foreach (ExportSection section in exportTemplate.Sections) 
            {
                List<ExportColumn> columnList = new List<ExportColumn>();

                foreach (ExportColumn column in section.ExportColumns)
                {
                    if (string.IsNullOrEmpty(column.ExportColumnName))
                    {
                        int order = 0;
                        List<ExportColumnResponse> columnResponses = column.ColumnResponses.Where(x => x.ExportColumnName != "unmarked").ToList();
                        int columnWidth = ((int)column.FixedWidthLength / columnResponses.Count());  
                        foreach (ExportColumnResponse columnResponse in columnResponses)
                        {
                            ExportColumn multipResponseColumn = new ExportColumn();
                            multipResponseColumn.ExportColumnName = columnResponse.ExportColumnName;
                            multipResponseColumn.ColumnOrder = column.ColumnOrder;
                            multipResponseColumn.FixedWidthLength = columnWidth;
                            multipResponseColumn.ExportTemplateSectionID = column.ExportTemplateSectionID;
                            multipResponseColumn.MultiResponseOrder = ++order;
                            multipResponseColumn.SourceColumnType = column.SourceColumnType;
                            columnList.Add(multipResponseColumn);
                        }
                    }
                    else
                    {
                        columnList.Add(column);      
                    }
                           
                }
                columns.Add((int)section.ExportTemplateSectionID, columnList);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="filetype"></param>
        /// <returns></returns>
        private string GetDelimiter(ExportFileTypes filetype)
        {
             switch (fileMakerType)
            {                
                 case ExportFileTypes.TabDelimitedText:
                     return "\t";
                 case ExportFileTypes.PipeDelimitedText:
                     return "|";
                 case ExportFileTypes.CommaDelimitedText:
                 case ExportFileTypes.CommaDelimitedCSV:
                     return ",";
                 default:
                     return string.Empty;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="txtWriter"></param>
        /// <param name="column"></param>
        /// <param name="value"></param>
        /// <param name="delimiter"></param>
        private void WriteColumn(TextWriter txtWriter, ExportColumn column, string value, string delimiter)
        {

            switch (fileMakerType)
            {
                case ExportFileTypes.FixedWidthText:
                    txtWriter.Write(value.PadRight((int)column.FixedWidthLength));
                    break;
                default:
                    // delimitted                   
                    if (column.ColumnOrder == 1)
                    {
                        // do not add delimiter to first column
                        txtWriter.Write(value);
                    }
                    else
                    {
                        txtWriter.Write(string.Format("{0}{1}", delimiter,value));
                    }

                    break;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Expression"></param>
        /// <returns></returns>
        private bool IsNumeric(Object Expression)
        {
            if (Expression == null || Expression is DateTime)
                return false;

            if (Expression is Int16 || Expression is Int32 || Expression is Int64 || Expression is Decimal || Expression is Single || Expression is Double || Expression is Boolean)
                return true;

            Double tmp;
            bool isSuccess = Double.TryParse(Expression as string, out tmp);
            return isSuccess;
        }

    }
}
