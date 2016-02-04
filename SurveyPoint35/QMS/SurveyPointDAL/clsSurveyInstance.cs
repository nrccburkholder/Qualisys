using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System.Data.Common;
using DataAccess;

namespace SurveyPointDAL
{
    /// <summary>
    /// Summary description for clsSurveyInstance.
    /// </summary>
    public class clsSurveyInstance
    {
        public const string TABLE_NAME = "SurveyInstances";

        public static void FillTable(DataSet ds, int iSurveyInstanceId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM v_SurveyInstances WHERE SurveyInstanceId = @SurveyInstanceId";
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@SurveyInstanceId", iSurveyInstanceId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@SurveyInstanceId", iSurveyInstanceId) });

        }

        public static dsSurveyPoint.SurveyInstancesRow getSurveyInstance(int iSurveyInstanceId)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            FillTable(ds, iSurveyInstanceId);
            if (ds.SurveyInstances.Rows.Count > 0)
                return (dsSurveyPoint.SurveyInstancesRow)ds.SurveyInstances.Rows[0];
            else
                return null;
        }

        public static dsSurveyPoint.SurveyInstancesDataTable getSurveyInstancesByClientAndSurvey(int iClientId, int iSurveyId)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM v_SurveyInstances WHERE ClientId = @ClientId AND SurveyId = @SurveyId AND Active = 1";
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@ClientId", iClientId);
            param[1] = new SqlParameter("@SurveyId", iSurveyId);
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.AddRange(param);
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME }, param);
            return ds.SurveyInstances;
        }

        public static dsSurveyPoint.SurveyInstancesDataTable getSurveyInstances(DBFilter filter)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = String.Format("SELECT * FROM v_SurveyInstances {0}", filter.GenerateWhereClause());
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            return ds.SurveyInstances;

        }
    }
}
