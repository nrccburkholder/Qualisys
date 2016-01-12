using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using HHCAHPSImporter.ImportProcessor.DAL;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public static class Factory
    {
        public static IExtract GetExtractor(DAL.Generated.ClientDetail client, string fileName, QP_DataLoadManager dataLoadManager)
        {
            var format = FileFormatClassifier.Classify(fileName, dataLoadManager);

            switch (format)
            {
                case FileFormat.NRC:
                    return new OCS.HHCAHPS();
                case FileFormat.PG_CSV:
                    return new PgCsvExtractor();
                case FileFormat.OCS_CSV:
                    return new OcsCsvExtractor();
                case FileFormat.OCS_FW:
                    return new OcsFwExtractor();
                case FileFormat.PTCT_CSV:
                    return new PtctCsvExtractor();
                case FileFormat.CMS_CSV:
                    return new CmsCsvExtractor();
                default:
                    throw new InvalidOperationException(string.Format("Couldn't get the extractor for file format {0}.", format));
            }
        }
    }
}
