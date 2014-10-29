using System.Linq;
using System.Collections.Generic;
using System.Web.Mvc;
using Nrc.CatalystExporter.DataContracts;

namespace Nrc.CatalystExporter.ExportClient.Models
{
    public class EditScheduleModel
    {
        public ClientStudySurvey Survey { get; set; }
        public ScheduledExport Schedule { get; set; }

        private List<string> _demographicFields;
        public IEnumerable<string> DemographicFields
        {
            get
            {
                if (_demographicFields == null) _demographicFields = new List<string>();
                return _demographicFields;
            }
            set
            {
                _demographicFields = value.ToList();
            }
        }

        private List<string> _questionFields;
        public IEnumerable<string> QuestionFields
        {
            get
            {
                if (_questionFields == null) _questionFields = new List<string>();
                return _questionFields;
            }
            set
            {
                _questionFields = value.ToList();
            }
        }

        private List<string> _commentFields;
        public IEnumerable<string> CommentFields
        {
            get
            {
                if (_commentFields == null) _commentFields = new List<string>();
                return _commentFields;
            }
            set
            {
                _commentFields = value.ToList();
            }
        }


        //Values for drop downs
        public IEnumerable<SelectListItem> FileTypes { get; set; }
        public IEnumerable<SelectListItem> Intervals { get; set; }
        public IEnumerable<SelectListItem> DateTypes { get; set; }
        public IEnumerable<SelectListItem> FileStructureTypes { get; set; }
    }
}