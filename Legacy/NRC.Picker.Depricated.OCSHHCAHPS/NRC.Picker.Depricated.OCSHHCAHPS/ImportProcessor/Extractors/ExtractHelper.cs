using FileHelpers;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal static class ExtractHelper
    {
        public static XDocument CreateEmptyDocument()
        {
            return new XDocument(
                new XElement("root",
                    new XElement("metadata"),
                    new XElement("rows")));
        }

        public static IEnumerable<XAttribute> CreateRootAttributes(ClientDetail client, string fileName)
        {
            if (client == null) throw new ArgumentNullException(nameof(client));
            if (fileName == null) throw new ArgumentNullException(nameof(fileName));

            return new List<XAttribute>
            {
                new XAttribute("sourcefile", fileName),
                new XAttribute("client_id", client.Client_id),
                new XAttribute("study_id", client.Study_id),
                new XAttribute("survey_id", client.Survey_id),
                new XAttribute("ContractedLanguages", client.Languages ?? "")
            };
        }

        public static XElement CreateTransformRow(int rowNumber, params XElement[] fields)
        {
            return
                new XElement("r",
                    new XAttribute("id", rowNumber),
                    fields
                );
        }

        public static XElement CreateFieldElement(string field, object value)
        {
            return new XElement("nv", new XAttribute("n", field), value);
        }

        public static XElement GetMetadataElement(XDocument xml)
        {
            return xml.Element("root").Element("metadata");
        }

        public static XElement GetRowsElement(XDocument xml)
        {
            return xml.Element("root").Element("rows");
        }

        public static T Parse<T>(string line)
        {
            var engine = new FileHelperAsyncEngine<T>();
            engine.BeginReadString(line);
            return engine.ReadNext();
        }

        public static IEnumerable<string> GetLinesForFixedWidthFile(string fileContents)
        {
            return fileContents.Split('\n').Select(line => line.Replace("\r", ""));
        }
    }
}
