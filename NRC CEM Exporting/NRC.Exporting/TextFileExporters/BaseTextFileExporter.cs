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

        #region public members

        public File TextFile;

        #endregion

        #region constructors

        public BaseTextFileExporter()
        {

        }

        #endregion

        abstract public bool MakeExportTextFile(List<ExportDataSet> ds, ExportTemplate template, string filePath);

    }
}
