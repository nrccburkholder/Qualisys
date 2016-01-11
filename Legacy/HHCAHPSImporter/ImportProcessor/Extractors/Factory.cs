using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public static class Factory
    {
        //private static IExtract extract = null;

        public static IExtract GetExtractor(DAL.Generated.ClientDetail client, string fileName)
        {
            var lowerFileName = fileName.ToLower();

            if (lowerFileName.Contains("cmscsv"))
                return new CmsCsvExtractor();
            else if (lowerFileName.Contains("ocv"))
                return new OcsCsvExtractor();
            else if (lowerFileName.Contains("ofw"))
                return new OcsFwExtractor();
            else if (lowerFileName.Contains("pgcsv"))
                return new PgCsvExtractor();
            else if (lowerFileName.Contains("ptctcsv"))
                return new PtctCsvExtractor();
            else
                return new OCS.HHCAHPS();

            //// TODO: need to be smarter about different types of extractors.  for now all extractor are of the same type.
            //if (extract == null)
            //{
            //    extract = (IExtract)(new OCS.HHCAHPS());
            //}
            //return extract;
        }
    }
}
