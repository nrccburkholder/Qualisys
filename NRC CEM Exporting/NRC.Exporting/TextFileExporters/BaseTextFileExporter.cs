using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace CEM.Exporting.TextFileExporters
{
    abstract public class BaseTextFileExporter
    {

        private SortedList<int, KeyValuePair<string, ExportColumn>> columns;

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

        public BaseTextFileExporter(ExportTemplate template)
        {
            exportTemplate = template;        
            CreateColumns();
        }

        #endregion

        abstract public bool MakeExportTextFile(List<ExportDataSet> ds, string filePath);


        public void CreateFileHeader(TextWriter tw)
        {
            foreach (KeyValuePair<int,KeyValuePair<string,ExportColumn>> item in this.Columns.OrderBy(x => x.Key))
            {
                ExportColumn column = (ExportColumn)item.Value.Value;
                tw.Write(column.ExportColumnName.PadRight((int)column.FixedWidthLength));
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
    }
}
