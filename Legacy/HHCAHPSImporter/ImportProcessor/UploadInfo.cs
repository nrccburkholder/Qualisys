using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor
{
    public class UploadInfo
    {
        public DAL.Generated.ClientDetail Client { get; set; }
        public string CCN { get; set; }
        public int? UploadFileId { get; set; }
    }
}
