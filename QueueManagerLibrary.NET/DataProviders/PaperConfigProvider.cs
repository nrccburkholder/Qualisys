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
    internal class PaperConfigProvider
    {
        private static bool mIsReprint;
        private static string mPCLOutput;

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }

        #region private methods


        private static PaperConfig PopulateBundle(DataRow dr)
        {
            PaperConfig bundle = new PaperConfig();

            bundle.PostalBundle = dr["strPostalBundle"].ToString();
            bundle.Total = (int)dr["Total"];
            bundle.Survey_ID = (int)dr["Survey_Id"];
            bundle.PaperConfig_ID = (int)dr["PaperConfig_id"];
            bundle.Pages = (int)dr["intPages"];
            bundle.NumPieces = (int)dr[5];
            bundle.LetterHead = (int)dr[6];
            bundle.DateBundled = dr[7].ToString();
            bundle.DateMailed = dr[8].ToString();

            bundle.LithocodeRange = LithoRange.SelectLithoRange(bundle.DateBundled, bundle.Survey_ID, bundle.PaperConfig_ID, bundle.PostalBundle);

            return bundle;
        }

        private static List<PaperConfig> PopulateBundleList(DataSet ds)
        {
            List<PaperConfig> bundleList = new List<PaperConfig>();

            if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    bundleList.Add(PopulateBundle(dr));
                }
            }

            return bundleList;
        }

        #endregion

        #region public methods

        internal static List<PaperConfig> SelectPaperConfigList(string pclOutput, bool isReprint, int SurveyID, DateTime datBundled, int PaperConfigID)
        {
            string queueType = isReprint == true ? "M" : "P";

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@PCLOutput",pclOutput),
                                                       new SqlParameter("@Survey_id", SurveyID),
                                                       new SqlParameter("@datBundled", datBundled),
                                                       new SqlParameter("@PaperConfig", PaperConfigID),
                                                       new SqlParameter("@QueueType",queueType)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "SP_Queue_BundleListDetails", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateBundleList(ds);
            }

        }


        #endregion

    }
}
