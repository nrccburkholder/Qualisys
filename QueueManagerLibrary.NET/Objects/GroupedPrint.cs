using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using Nrc.Framework.BusinessLogic.Configuration;

namespace QueueManagerLibrary.Objects
{
    public class GroupedPrint
    {

        public int Survey_ID { get; set; }
        public int PaperConfig_ID { get; set; }
        public string DatePrinted { get; set; }
        public string DateBundled { get; set; }
        public string ClientName { get; set; }
        public string SurveyName { get; set; }
        public string PaperConfig_Name { get; set; }
        public string SurveyDescription { get; set; }
        public int SurveyType_ID { get; set; }
        public int NumPieces { get; set; }
        public DateTime DateMailed { get; set; }

        public GroupedPrint()
        {

        }

        public static List<GroupedPrint> SelectGroupedPrintList(bool isReprint)
        {
            return DataProviders.GroupedPrintProvider.SelectGroupedPrintList(isReprint ? 'M' : 'P');
        }


    }
}
