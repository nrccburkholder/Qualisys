using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data;
using DataAccess;

namespace SurveyPointDAL
{
    /// <summary>
    /// Summary description for clsScript.
    /// </summary>
    public class clsScript
    {
        public const string TABLE_NAME = "Scripts";

        public static void FillTable(DataSet ds, int iScriptId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Scripts WHERE ScriptId = @ScriptId";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);           
            cmd.Parameters.Add(new SqlParameter("@ScriptId", iScriptId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@ScriptId", iScriptId) });

        }

        public static dsSurveyPoint.ScriptsRow getScript(int iScriptId)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            FillTable(ds, iScriptId);
            if (ds.Scripts.Rows.Count > 0)
                return (dsSurveyPoint.ScriptsRow)ds.Scripts.Rows[0];
            else
                return null;
        }

        public static dsSurveyPoint.ScriptsDataTable getScriptsBySurvey(int iSurveyId)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Scripts WHERE SurveyId = @SurveyId ORDER BY Name";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@SurveyId", iSurveyId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds,  new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@SurveyId", iSurveyId) });
            return ds.Scripts;
        }

    }
}
