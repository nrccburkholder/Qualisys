using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal enum FileType
    {
        Unknown = 0,
        NRC = 1,
        PG_CSV = 2,
        OCS_CSV = 3,
        OCS_FW = 4,
        PTCT_CSV = 5,
        CMS_CSV = 6
    }
}
