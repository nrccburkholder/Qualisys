using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CEM.Exporting.DataProviders;
using CEM.Exporting.Enums;
using System.Data;

namespace CEM.Exporting
{
    public class ExportQueueFile
    {

        public int? ExportQueueFileID { get; set; }
        public int? ExportTemplateID { get; set; }
        public int? ExportQueueID { get; set; }
        public Int16? FileState { get; set; }
        public DateTime? SubmissionDate { get; set; }
        public string SubmissionBy { get; set; }
        public string CMSResponseCode { get; set; }
        public DateTime? CMSResponseDate { get; set; }
        public int? FileMakerType { get; set; }
        public string FileMakerName { get; set; }
        public DateTime? FileMakerDate { get; set; }
        public ExportTemplate Template { get; set; }
        public List<ExportValidationError> ValidationErrorList { get; set; }
        public bool IsValid { get { return ValidationErrorList.Count == 0;  } }

        public ExportQueueFile()
        {
            ValidationErrorList = new List<ExportValidationError>();
        }

        #region public methods

        public void Save()
        {
            ExportQueueFileProvider.Update(this);
        }

        public static ExportQueueFile PopulateExportQueueFile(DataRow dr)
        {
            return DataProviders.ExportQueueFileProvider.PopulateExportQueueFile(dr);
        }

        public static List<ExportQueueFile> Select(ExportQueueFile queuefile)
        {
            return DataProviders.ExportQueueFileProvider.Select(queuefile);
        }

        public static DataTable SelectAsDataTable(ExportQueueFile queuefile)
        {
            return DataProviders.ExportQueueFileProvider.SelectAsDataTable(queuefile);
        }

        #endregion

    }
}
