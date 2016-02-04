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
    /// Summary description for clsSurvey.
    /// </summary>
    public class clsSurvey
    {
        public const string TABLE_NAME = "Surveys";

        public static void FillTable(DataSet ds, int iSurveyId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Surveys WHERE SurveyId = @SurveyId ORDER BY Name";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@SurveyId", iSurveyId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@SurveyId", iSurveyId) });

        }

        public static dsSurveyPoint.SurveysRow getSurvey(int iSurveyID)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            FillTable(ds, iSurveyID);
            if (ds.Surveys.Rows.Count > 0)
                return (dsSurveyPoint.SurveysRow)ds.Surveys.Rows[0];
            else
                return null;
        }

        public static dsSurveyPoint.SurveysDataTable getActiveSurveys()
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Surveys WHERE Active = 1 ORDER BY Name";
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            return ds.Surveys;
        }

        public static dsSurveyPoint.SurveysDataTable getClientSurveys(int iClientId)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Surveys WHERE Active = 1 AND EXISTS (SELECT 1 FROM SurveyInstances si WHERE si.SurveyID = Surveys.SurveyID AND si.ClientID = @ClientID) ORDER BY Name";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@ClientId", iClientId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@ClientId", iClientId) });
            return ds.Surveys;
        }

    }
}
