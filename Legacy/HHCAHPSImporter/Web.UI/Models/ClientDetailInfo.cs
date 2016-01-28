using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Generated = HHCAHPSImporter.ImportProcessor.DAL.Generated;

namespace HHCAHPSImporter.Web.UI.Models
{
    public class ClientDetailInfo
    {

        public int Client_id { get { return this.ClientDetail.Client_id; } }
        public int Study_id { get { return this.ClientDetail.Study_id; } }
        public int Survey_id { get { return this.ClientDetail.Survey_id; } }
        public string ClientName { get { return this.ClientDetail.ClientName; } }
        public string CCN { get { return this.ClientDetail.CCN; } }

        public Generated.ClientDetail ClientDetail { get; set; }
        public List<string> Languages { get; set; }
        public Generated.Transform Transform { get; set; }

        public List<Generated.GetClientTransformsResult> TransformMappings { get; set; }

    }
}