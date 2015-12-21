using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class OcsFwParser
    {
        public XDocument Parse(string fileContents)
        {
            if (fileContents == null) throw new ArgumentNullException(nameof(fileContents));

            return new XDocument(new XElement("root"));
        }
    }
}
