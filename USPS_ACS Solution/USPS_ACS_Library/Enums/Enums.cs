using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace USPS_ACS_Library.Enums
{
    public enum ErrorType
    {
        Download,
        Extract,
        Update,
        Other
    }

    public enum DownloadStatus
    {
        New,
        Started,
        Completed,
        Canceled,
        Archived
    }

    public enum ExtractFileStatus
    {
        New,
        No_Header_Record,
        Empty_File,
        Processing_Error,
        Completed,
        Archived
    }

    public enum ExtractFileRecordStatus
    {
        New,
        Not_Found,
        MultipleMatches,
        Updated,
        Error
    }
}
