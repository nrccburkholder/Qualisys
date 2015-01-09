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
    internal class CommonProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }


        #region public methods

        internal static void GetLastBundleDate(ref bool IsRunning, ref string LastBundleTime)
        {

            SqlParameter param1 = new SqlParameter("@IsRunning",SqlDbType.Bit);
            param1.Direction = ParameterDirection.Output;

            SqlParameter param2 = new SqlParameter("@LastBundleTime",SqlDbType.VarChar,50);
            param2.Direction = ParameterDirection.Output;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = param1;
            param[1] = param2;

            SqlProvider.ExecuteNonQuery("sp_Queue_BundleStatus",CommandType.StoredProcedure,param);

            IsRunning = (bool)param1.Value;
            LastBundleTime = param2.Value.ToString();
        }

        internal static void GetPrintingAddInstance(ref bool IsAdded, ref string LastPrintDate)
        {
            SqlParameter param1 = new SqlParameter("@IsAdded", SqlDbType.Bit);
            param1.Direction = ParameterDirection.Output;

            SqlParameter param2 = new SqlParameter("@LastDate", SqlDbType.VarChar, 22);
            param2.Direction = ParameterDirection.Output;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = param1;
            param[1] = param2;

            SqlProvider.ExecuteNonQuery("sp_Queue_Printing_AddInstance", CommandType.StoredProcedure, param);

            IsAdded = (bool)param1.Value;
            LastPrintDate = param2.Value.ToString();

        }

        internal static void RemovePrintingInstance()
        {
            SqlProvider.ExecuteNonQuery("sp_Queue_Printing_RemoveInstan", CommandType.StoredProcedure);
        }

        internal static DataSet GetDataSetBySqlString(string sql)
        {
            DataSet ds = new DataSet();

            SqlProvider.Fill(ref ds, sql, CommandType.Text);

            using (ds)
            {
                return ds;
            }

        }

        internal static void SetLithoCodes(bool isReprint, int survey_id, string postalBundle, int paperConfigId, int pageNum, string strBundled)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@survey_id",survey_id),
                                                       new SqlParameter("@strPostalBundle_id", postalBundle),
                                                       new SqlParameter("@PaperConfig_id",paperConfigId),
                                                       new SqlParameter("@reprint",isReprint == true ? 1 : 0),
                                                       new SqlParameter("@datBundled",strBundled)

                                                       };

            SqlProvider.ExecuteNonQuery("sp_queue_setlitho", CommandType.StoredProcedure, param);
        }

        #endregion

    }
}
