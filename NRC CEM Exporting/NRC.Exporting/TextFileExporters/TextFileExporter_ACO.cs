using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data;

namespace CEM.Exporting.TextFileExporters
{
    public class TextFileExporter_ACO : BaseTextFileExporter
    {

         #region constructors

        public TextFileExporter_ACO(): base()
        {

        }

        #endregion

        public override bool MakeExportTextFile(List<ExportDataSet> dsList, ExportTemplate template, string filePath)
        {
            bool result = false;

            try
            {
                if (!Directory.Exists(filePath))
                {
                    Directory.CreateDirectory(filePath);
                }

                System.IO.TextWriter tw = new StreamWriter(filePath);

                foreach (ExportDataSet ds in dsList)
                {
                    foreach (DataRow dr in ds.DataTable.Rows)
                    {
                        foreach (ExportSection section in template.Sections) //TODO:  Do we need ORDER on Section?
                        {
                            foreach (ExportColumn column in section.ExportColumns.OrderBy(x => x.ColumnOrder))
                            {
                                string columnName = string.Format("{0}.{1}",section.ExportTemplateSectionName, column.ExportColumnName);
                                string value = dr[columnName].ToString();
                                tw.Write(value.PadRight((int)column.FixedWidthLength));
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
    }
}
