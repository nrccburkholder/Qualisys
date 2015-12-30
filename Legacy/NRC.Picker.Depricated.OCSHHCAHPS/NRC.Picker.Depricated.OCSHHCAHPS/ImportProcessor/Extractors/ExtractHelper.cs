using FileHelpers;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Globalization;
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

        public static T Parse<T>(string line) where T : class
        {
            var engine = new FileHelperAsyncEngine<T>();
            engine.BeginReadString(line);
            return engine.ReadNext();
        }

        public static IEnumerable<string> GetLinesForFixedWidthFile(string fileContents)
        {
            return fileContents.Split('\n').Select(line => line.Replace("\r", ""));
        }

        public static string AddTrailingCommas(string fileContents)
        {
            return string.Join("\n", fileContents.Split('\n').Select(line => line.TrimEnd(' ', '\r') + ","));
        }

        public static DateTime? GetDateTimeFromString(string value, bool expectingyyyMMdd)
        {
            value = string.IsNullOrEmpty(value) ? "" : value.Trim();
            if (string.IsNullOrEmpty(value))
            {
                return null;
            }

            if (value.IndexOf('/') != -1)
            {
                try
                {
                    return DateTime.Parse(value);
                }
                catch (Exception)
                {
                    return null;
                }
            }
            
            IEnumerable<string> formats = new string[] { "MMddyyyy", "yyyyMMdd" };
            if (expectingyyyMMdd)
            {
                formats = formats.Reverse();
            }

            foreach (string fmt in formats)
            {
                string v = value;
                if (v.Length == fmt.Length - 1 && fmt.StartsWith("MM"))
                {
                    v = "0" + v;
                }
                else if (v.Length != fmt.Length) // unfixable, no good
                {
                    continue;
                }

                DateTime d;
                if (DateTime.TryParseExact(v, fmt, CultureInfo.CurrentCulture, DateTimeStyles.None, out d))
                {
                    return d;
                }
            }

            return null;
        }

        public static string ToString(this DateTime? date, string format)
        {
            if (date == null) return "";
            return date.Value.ToString(format);
        }

        public static string ConvertDateFormat(string value, bool expectingyyyMMdd)
        {
            return GetDateTimeFromString(value, expectingyyyMMdd).ToString("MMddyyyy");
        }
    }
}
