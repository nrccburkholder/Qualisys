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
    /// Summary description for clsClient.
    /// </summary>
    public class clsClient
    {
        public const string TABLE_NAME = "Clients";

        public static void FillTable(DataSet ds, int iClientId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Clients WHERE ClientId = @ClientId";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@ClientId", iClientId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
              //  new SqlParameter[] { new SqlParameter("@ClientId", iClientId) });
        }

        public static dsSurveyPoint.ClientsDataTable getClients()
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Clients ORDER BY Name";
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            return ds.Clients;
        }

        public static dsSurveyPoint.ClientsDataTable getClientsBySurvey(int iSurveyID)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Clients WHERE EXISTS (SELECT 1 FROM SurveyInstances WHERE Clients.ClientID = SurveyInstances.ClientID AND SurveyInstances.SurveyID = @SurveyID) ORDER BY Name";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@SurveyID", iSurveyID));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@SurveyID", iSurveyID) });
            return ds.Clients;
        }
    }
}
