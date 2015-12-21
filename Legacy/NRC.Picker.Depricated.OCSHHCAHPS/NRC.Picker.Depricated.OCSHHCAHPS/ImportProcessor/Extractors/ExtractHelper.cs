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
        public static XDocument SetRootAttributes(XDocument xml, ClientDetail client, string fileName)
        {
            if (xml == null) throw new ArgumentNullException(nameof(xml));
            if (client == null) throw new ArgumentNullException(nameof(client));
            if (fileName == null) throw new ArgumentNullException(nameof(fileName));

            if (xml.Root == null || xml.Root.Name != "root")
                throw new InvalidOperationException("No root element.");

            var root = xml.Root;

            root.Add(new XAttribute("sourcefile", fileName),
                new XAttribute("client_id", client.Client_id),
                new XAttribute("study_id", client.Study_id),
                new XAttribute("survey_id", client.Survey_id),
                new XAttribute("ContractedLanguages", client.Languages ?? ""));

            return xml;
        }
    }
}
