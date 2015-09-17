using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data;

namespace CEM.Exporting.TextFileExporters
{
    public class TextFileExporter_ACO : TextFileExporter
    {

         #region constructors

        public TextFileExporter_ACO(ExportTemplate template): base(template)
        {

        }

        #endregion

        public override bool MakeExportTextFile(List<ExportDataSet> dsList, string filePath)
        {
            bool result = false;

            //try
            //{
            //    if (!Directory.Exists(filePath))
            //    {
            //        Directory.CreateDirectory(filePath);
            //    }

            //    System.IO.TextWriter tw = new StreamWriter(filePath);

            //    this.CreateFileHeader(tw);

            //    foreach (ExportDataSet ds in dsList)
            //    {
            //        foreach (DataRow dr in ds.DataTable.Rows)
            //        {

            //                foreach (KeyValuePair<int,KeyValuePair<string,ExportColumn>> item in this.Columns.OrderBy(x => x.Key))
            //                {
            //                    ExportColumn column = (ExportColumn)item.Value.Value;
            //                    string columnName = string.Format("{0}.{1}",item.Value.Key, column.ExportColumnName);
            //                    string value = dr[columnName].ToString();

            //                    if (IsNumeric(value))
            //                    {
            //                        // align value to the right if it is numeric
            //                        tw.Write(value.PadLeft((int)column.FixedWidthLength));
            //                    }
            //                    else
            //                    {
            //                        // align value to the left if it is NOT numeric
            //                        tw.Write(value.PadRight((int)column.FixedWidthLength));
            //                    }     
            //                }

            //            tw.Write(tw.NewLine);
            //        }      
            //    }

            //    tw.Flush();
            //    tw.Close();

            //    result = false;

            //}
            //catch (Exception ex)
            //{
            //    throw;
            //}

            return result;
        }


        //private bool IsNumeric(Object Expression)
        //{
        //    if (Expression == null || Expression is DateTime)
        //        return false;

        //    if (Expression is Int16 || Expression is Int32 || Expression is Int64 || Expression is Decimal || Expression is Single || Expression is Double || Expression is Boolean)
        //        return true;

        //    Double tmp;
        //    bool isSuccess = Double.TryParse(Expression as string, out tmp);
        //    return isSuccess;
        //}
    }
}
