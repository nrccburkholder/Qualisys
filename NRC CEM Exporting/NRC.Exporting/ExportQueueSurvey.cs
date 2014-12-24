using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NRC.Exporting
{

    public class ExportQueueSurvey
    {

        public int ExportQueueSurveyID { get; set; }
        public int? ExportQueueID { get; set; }
        public int? SurveyID { get; set; }

        public ExportQueueSurvey()
        {

        }
    }
}
