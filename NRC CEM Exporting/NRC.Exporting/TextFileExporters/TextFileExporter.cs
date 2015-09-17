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

        private SortedList<int, KeyValuePair<string, ExportColumn>> columns;
        private ExportFileTypes fileMakerType;

        public SortedList<int, KeyValuePair<string, ExportColumn>> Columns
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

        public TextFileExporter(ExportTemplate template, ExportFileTypes fileType)
        {
            exportTemplate = template;
            fileMakerType = fileType;
            CreateColumns();
        }

        #endregion

        public bool MakeExportTextFile(List<ExportDataSet> dsList, string filePath)
        {
            bool result = false;

            try
            {
                if (!Directory.Exists(filePath))
                {
                    Directory.CreateDirectory(filePath);
                }

                System.IO.TextWriter tw = new StreamWriter(filePath);

                this.CreateFileHeader(tw);

                foreach (ExportDataSet ds in dsList)
                {
                    foreach (DataRow dr in ds.DataTable.Rows)
                    {

                        foreach (KeyValuePair<int, KeyValuePair<string, ExportColumn>> item in this.Columns.OrderBy(x => x.Key))
                        {
                            ExportColumn column = (ExportColumn)item.Value.Value;
                            string columnName = string.Format("{0}.{1}", item.Value.Key, column.ExportColumnName);
                            string value = dr[columnName].ToString();

                            switch (fileMakerType)
                            {
                                case ExportFileTypes.FixedWidthText:

                                    if (IsNumeric(value))
                                    {
                                        // align value to the right if it is numeric
                                        tw.Write(value.PadLeft((int)column.FixedWidthLength));
                                    }
                                    else
                                    {
                                        // align value to the left if it is NOT numeric
                                        tw.Write(value.PadRight((int)column.FixedWidthLength));
                                    }

                                    break;
                                default:
                                    // comma delimitted

                                    if (column.ColumnOrder == 1)
                                    {
                                        // do not add comma to first column
                                        tw.Write(value);
                                    }
                                    else
                                    {
                                        tw.Write(string.Format(",{0}", value));
                                    }

                                    break;
                            }
                          
                        }

                        tw.Write(tw.NewLine);
                    }
                }

                tw.Flush();
                tw.Close();

                result = false;

            }
            catch (Exception ex)
            {
                throw;
            }

            return result;
        }


        public void CreateFileHeader(TextWriter tw)
        {
            foreach (KeyValuePair<int,KeyValuePair<string,ExportColumn>> item in this.Columns.OrderBy(x => x.Key))
            {
                ExportColumn column = (ExportColumn)item.Value.Value;

                switch (fileMakerType)
                {
                    case ExportFileTypes.FixedWidthText:
                        tw.Write(column.ExportColumnName.PadRight((int)column.FixedWidthLength));
                        break;
                    default:
                        // comma delimitted
                        if (column.ColumnOrder == 1)
                        {
                            // do not add comma to first column
                            tw.Write(column.ExportColumnName);
                        }
                        else
                        {
                            tw.Write(string.Format(",{0}",column.ExportColumnName));
                        }
                        
                        break;
                }
                
            }
        }

        private void CreateColumns()
        {
            SortedList<int, KeyValuePair<string, ExportColumn>> columns = new SortedList<int, KeyValuePair<string, ExportColumn>>();

            foreach (ExportSection section in exportTemplate.Sections) 
            {
                foreach (ExportColumn column in section.ExportColumns)
                {
                    columns.Add((int)column.ColumnOrder, new KeyValuePair<string, ExportColumn>(section.ExportTemplateSectionName, column));
                }
            }
        }


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
