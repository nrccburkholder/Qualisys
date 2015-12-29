using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace OCSHHCAHPS.ImportProcessorTest
{
    internal static class ParserTestHelper
    {
        public static IEnumerable<XElement> GetMetadataRows(XDocument xml)
        {
            return xml.Element("root").Element("metadata").Elements("r");
        }

        public static XElement GetMetadataRow(XDocument xml)
        {
            return GetMetadataRows(xml).First();
        }

        public static IEnumerable<XElement> GetRows(XDocument xml)
        {
            return xml.Element("root").Element("rows").Elements("r");
        }

        public static XElement GetElement(XElement parent, string field)
        {
            return parent.Elements("nv").FirstOrDefault(nv => nv.Attribute("n").Value == field);
        }
    }
}
