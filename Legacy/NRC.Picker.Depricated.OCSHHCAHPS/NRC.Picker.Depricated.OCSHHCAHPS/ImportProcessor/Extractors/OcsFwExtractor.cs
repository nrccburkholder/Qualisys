using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class OcsFwExtractor : IExtract
    {
        public XDocument Extract(ClientDetail client, string file)
        {
            if (client == null) throw new ArgumentNullException(nameof(client));
            if (file == null) throw new ArgumentNullException(nameof(file));

            return new XDocument(new XElement("root"));
        }
    }
}
