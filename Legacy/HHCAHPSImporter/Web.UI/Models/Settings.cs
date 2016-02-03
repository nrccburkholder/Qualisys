using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

using NRC.Common.Configuration;

namespace HHCAHPSImporter.Web.UI.Models
{
    public class Settings : ConfigSection
    {
        [ConfigUse("QP_DataLoadConnectionString")]
        public string QP_DataLoadConnectionString { get; set; }

        [ConfigUse("AbandonedUploadsDirectory")]
        public string AbandonedUploadsDirectory { get; set; }

        [ConfigUse("UploadFailureDirectory")]
        public string UploadFailureDirectory { get; set; }
    }
}