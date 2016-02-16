using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HHCAHPSImporter.Web.UI.Models
{
    public class ClientInfo
    {
        public ImportProcessor.DAL.Generated.ClientDetail ClientDetail { get; set; }

        public string FileFormat { get; set; }
    }
}