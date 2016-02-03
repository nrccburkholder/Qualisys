using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HHCAHPSImporter.Web.UI.Models
{
    public class TransformLibraryImportItem
    {
        public int TransformLibraryId { get; set; }
        public string TransformLibraryName { get; set; }
        public int TransformId { get; set; }
        public bool IsImported { get; set; }
    }
}