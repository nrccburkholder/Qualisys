using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using System.IO;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal class CmsCsvExtractor : IExtract
    {
        public XDocument Extract(ClientDetail client, string file)
        {
            if (client == null) throw new ArgumentNullException(nameof(client));
            if (file == null) throw new ArgumentNullException(nameof(file));

            return CmsCsvParser.Parse(client, file, File.ReadAllText(file));
        }
    }
}
