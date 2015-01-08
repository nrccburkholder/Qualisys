using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerLibrary.Objects
{
    public class Configuration
    {
        #region public members

        public string PaperConfig_Name { get; set; } //0
        public int PaperConfig_ID { get; set; } //1
        public int Pages { get; set; } //2
        public int Study_ID { get; set; } //3
        public int Survey_ID { get; set; } //4
        public int NumPieces { get; set; } //5
        public int NumberMailed { get; set; } //6
        public DateTime DateMailed { get; set; } //7
        public List<PaperConfig> PaperConfigList { get; set; }

        #endregion

        #region constructors

        public Configuration()
        {
            PaperConfigList = new List<PaperConfig>();
        }

        #endregion

        #region private methods

        #endregion

        #region public methods

        internal static List<Configuration> SelectConfigurationList(string pclOutput, bool isReprint, int surveyID)
        {
            return DataProviders.ConfigurationProvider.SelectConfigurationList(pclOutput, isReprint,surveyID);
        }


        #endregion

    }
}
