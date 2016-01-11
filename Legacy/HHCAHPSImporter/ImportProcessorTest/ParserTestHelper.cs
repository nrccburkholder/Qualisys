using HHCAHPSImporter.ImportProcessor.Extractors;
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
            return xml.Element(ExtractHelper.RootElementName).Element(ExtractHelper.MetadataElementName).Elements(ExtractHelper.RowElementName);
        }

        public static XElement GetMetadataRow(XDocument xml)
        {
            return GetMetadataRows(xml).First();
        }

        public static IEnumerable<XElement> GetRows(XDocument xml)
        {
            return xml.Element(ExtractHelper.RootElementName).Element(ExtractHelper.RowsElementName).Elements(ExtractHelper.RowElementName);
        }

        public static XElement GetElement(XElement parent, string field)
        {
            return parent.Elements(ExtractHelper.FieldElementName).FirstOrDefault(nv => nv.Attribute(ExtractHelper.FieldAttributeName).Value == field);
        }
    }
}
