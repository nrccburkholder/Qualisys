using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Catalyst.DataMart.Library
{
    public class ExportQueueFile
    {

        public int ExportQueuefileID { get; set; }
        public DateTime? SubmissionDate { get; set; }
        public string SubmissionBy { get; set; }
        public string CMSResponseCode { get; set; }
        public DateTime? CMSResponseDate { get; set; }
        public int? FileMakerType { get; set; }
        public string FileMakerName { get; set; }
        public DateTime? FileMakerDate { get; set; }


        public ExportQueueFile()
        {

        }

    }
}
