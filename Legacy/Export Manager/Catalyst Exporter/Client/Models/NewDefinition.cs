using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using Nrc.CatalystExporter.DataContracts;

namespace Nrc.CatalystExporter.ExportClient.Models
{
    public class NewDefinition
    {
        private Collection<int> _surveyIds;
        public ICollection<int> SurveyIds
        {
            get
            {
                if (_surveyIds == null) _surveyIds = new Collection<int>();
                return _surveyIds;
            }
        }

        private Collection<ClientStudySurvey> _surveys;
        public ICollection<ClientStudySurvey> Surveys
        {
            get
            {
                if (_surveys == null) _surveys = new Collection<ClientStudySurvey>();
                return _surveys;
            }
        }

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

        public List<ColumnDefinition> Columns { get; set; }

        public void SetSurveys(ClientStudySurvey[] surveys)
        {
            _surveys = new Collection<ClientStudySurvey>(surveys);
        }

    }
}