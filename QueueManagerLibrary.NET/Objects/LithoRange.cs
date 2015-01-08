using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QueueManagerLibrary.Objects
{
    public class LithoRange
    {

        #region public members

        public int MinLitho {get; set;}
        public int MaxLitho { get; set; }

        #endregion

        #region constructors

        public LithoRange()
        {

        }

        #endregion


        #region public methods

        internal static LithoRange SelectLithoRange(string datBundled, int surveyID, int paperConfigID, string postalBundle)
        {
            return DataProviders.LithoRangeProvider.SelectLithoRange(datBundled, surveyID, paperConfigID, postalBundle);
        }

        #endregion
    }
}
