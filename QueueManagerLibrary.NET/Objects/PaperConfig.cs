using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerLibrary.Objects
{
    public class PaperConfig
    {

        #region public properties

        public string PostalBundle { get; set; } // 0
        public int Total { get; set; } // 1
        public int Survey_ID { get; set;  } // 2
        public int PaperConfig_ID { get; set; } // 3
        public int Pages { get; set; } // 4
        public int NumPieces { get; set; }// 5
        public int LetterHead { get; set; }// 6
        public string DateBundled { get; set; } //7
        public string DateMailed { get; set; } //8

        public LithoRange LithocodeRange { get; set; }

        #endregion

        #region constructors

        public PaperConfig()
        {
            LithocodeRange = new LithoRange();
        }

        #endregion

        #region private methods
        #endregion

        #region public methods

        internal static List<PaperConfig> SelectPaperConfigList(string pclOutput, bool isReprint, int SurveyID, DateTime datBundled, int PaperConfigID)
        {
            return DataProviders.PaperConfigProvider.SelectPaperConfigList(pclOutput, isReprint, SurveyID, datBundled,PaperConfigID);
        }


        #endregion

    }
}
