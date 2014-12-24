using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NRC.Exporting
{
    public class ExportQueue
    {

        public int? ExportQueueID { get; set; }
        public string ExportTemplateName { get; set; }
        public string ExportTemplateVersionMajor { get; set; }
        public int? ExportTemplateVersionMinor { get; set; }
        public DateTime? ExportDateStart { get; set; }
        public DateTime? ExportDateEnd { get; set; }
        public bool? ReturnsOnly { get; set; }
        public int? ExportNotificationID { get; set; }
        public DateTime? RequestDate { get; set; }
        public DateTime? PullDate { get; set; }
        public DateTime? ValidatedDate { get; set; }
        public string ValidatedBy { get; set; }
        public string ValidationCode { get; set; }


        public ExportQueue()
        {

        }

        public static List<ExportQueue> Select(ExportQueue queue)
        {
            return DataProviders.ExportQueueProvider.Select(queue);
        }


    }
}
