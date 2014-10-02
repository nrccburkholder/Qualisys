using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.ImportProcessors.OCSHHCAHPS.DAL
{
    public class ClientDetails
    {
        public string ClientName { get; set; }
        public string ClientId { get; set; }
        public string StudyId { get; set; }
        public string SurveyId { get; set; }
        public List<string> Languages { get; set; }

        public string BaseTransformFile { get; set; }
    }
}
