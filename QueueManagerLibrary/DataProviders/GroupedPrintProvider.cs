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
    internal class GroupedPrintProvider
    {

        private static char mQueueType;

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }


        #region private methods


        private static GroupedPrint PopulateGroupedPrint (DataRow dr)
        {
            GroupedPrint gp = new GroupedPrint();

            gp.Survey_ID = (int)dr["Survey_id"];
            gp.PaperConfig_ID = (int)dr["PaperConfig_id"];
            switch (mQueueType)
            {
                case 'P':
                    gp.DateBundled = dr["datBundled"].ToString();
                    gp.DatePrinted = string.Empty;
                    break;
                default:
                    gp.DatePrinted = dr["datPrinted"].ToString();
                    gp.DateBundled = string.Empty;
                    break;
            }
            gp.ClientName = dr["strclient_nm"].ToString();
            gp.SurveyName = dr["strSurvey_nm"].ToString();
            gp.PaperConfig_Name = dr["strPaperConfig_nm"].ToString();
            gp.SurveyDescription = dr["SurveyType_dsc"].ToString();
            gp.NumPieces = (int)dr["numPieces"];
            gp.DateMailed = (DateTime)dr["datMailed"];
            gp.SurveyType_ID = (int)dr["SurveyType_id"];

            return gp;
        }

        private static List<GroupedPrint> PopulateGroupedPrintList(DataSet ds)
        {
            List<GroupedPrint> gplist = new List<GroupedPrint>();

            return gplist;
        }

        #endregion

        #region public methods

        internal static List<GroupedPrint> SelectGroupedPrintList(char QueueType)
        {

            mQueueType = QueueType;

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@QueueType",QueueType)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "sp_Queue_GroupedPrintList", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateGroupedPrintList(ds);
            }

        }

        internal static void GroupedPrintRebundleAndSetLithos(int paperConfigID, DateTime printDate)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@paperconfig_id",paperConfigID),
                                                       new SqlParameter("@printdate",printDate.ToString("yyyy-mm-dd hh:nn:ss AMPM"))
                                                       };

            SqlProvider.ExecuteNonQuery("sp_Queue_GroupedPrintRebundleAndSetLithos", CommandType.StoredProcedure, param);

        }

        internal static void SetPrintDate(int survey_id, string strPostalBundle, int PaperConfigID, DateTime datBundled, DateTime datPrinted)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@Survey_id",survey_id),
                                                       new SqlParameter("@strPostalBundle", strPostalBundle),
                                                       new SqlParameter("@PaperConfig",PaperConfigID),
                                                       new SqlParameter("@datBundled",datBundled),
                                                       new SqlParameter("@datPrinted",datPrinted)

                                                       };

            SqlProvider.ExecuteNonQuery("sp_Queue_SetPrintDate", CommandType.StoredProcedure, param);
      
        }

        #endregion

    }
}
