using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System.IO;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class CmsCsvExtractor : IExtract
    {
        public XDocument Extract(ClientDetail client, string file)
        {
            if (client == null) throw new ArgumentNullException(nameof(client));
            if (file == null) throw new ArgumentNullException(nameof(file));

            try
            {
                return CmsCsvParser.Parse(client, file, File.ReadAllText(file));
            }
            catch (Exception ex)
            {
                throw new ParseException(string.Format("Couldn't parse file {0}.", file), ex);
            }
        }
    }
}
