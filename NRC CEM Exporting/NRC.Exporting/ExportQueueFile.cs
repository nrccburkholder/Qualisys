using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting.DataProviders;

namespace NRC.Exporting
{
    public class ExportQueueFile
    {

        public int? ExportQueueFileID { get; set; }
        public int? ExportQueueID { get; set; }
        public DateTime? SubmissionDate { get; set; }
        public string SubmissionBy { get; set; }
        public string CMSResponseCode { get; set; }
        public DateTime? CMSResponseDate { get; set; }
        public int? FileMakerType { get; set; }
        public string FileMakerName { get; set; }
        public DateTime? FileMakerDate { get; set; }
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

        #endregion

    }
}
