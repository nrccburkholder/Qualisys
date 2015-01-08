using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using QueueManagerLibrary.Objects;

namespace QueueManagerLibrary.DataProviders
{
    internal class LithoRangeProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }

        #region private methods

        private static LithoRange PopulateLithoRange(DataSet ds)
        {
            LithoRange lithoRange = new LithoRange();
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    lithoRange.MaxLitho = (int)ds.Tables[0].Rows[0][0];
                    lithoRange.MinLitho = (int)ds.Tables[0].Rows[0][1];
                }
            }

            return lithoRange;
        }

        #endregion

        #region public methods

        internal static LithoRange SelectLithoRange(string datBundled, int surveyID, int paperConfigID, string postalBundle)
        {

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@datBundled",datBundled),
                                                       new SqlParameter("@Survey_id", surveyID),
                                                       new SqlParameter("@PaperConfig", paperConfigID),
                                                       new SqlParameter("@strPostalBundle",postalBundle)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "SP_Queue_LithoRange", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateLithoRange(ds);
            }

        }

        #endregion
    }
}
