using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerLibrary.Objects
{
    public class Client
    {

        #region public members

        public string ClientName { get; set; }
        public string SurveyName { get; set; }
        public int SurveyID { get; set; }
        public string SurveyDescription { get; set; }
        public int SurveyType_ID {get; set;}
        public int NumberOfPieces { get; set; }
        public int NumberPrinted { get; set; }
        public int NumberMailed { get; set; }
        public int NumberInGroupPrint { get; set; }
        public List<Configuration> Configurations { set; get; }


        #endregion

        #region constructors
        public Client()
        {
            Configurations = new List<Configuration>();
        }

        #endregion

        #region public methods

        public static List<Client> SelectClientList(string PCLOutput, bool isReprint)
        {
            return DataProviders.ClientProvider.SelectClientList(PCLOutput,isReprint);
        }

        #endregion
    }
}
