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
    /// Summary description for clsScriptScreenCategory.
    /// </summary>
    public class clsScriptScreenCategory
    {
        public const string TABLE_NAME = "ScriptScreenCategories";

        public static void FillTable(DataSet ds, int iScriptId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM ScriptScreenCategories WHERE ScriptScreenId IN (SELECT ScriptScreenId FROM ScriptScreens WHERE ScriptId = @ScriptId)";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@ScriptId", iScriptId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@ScriptId", iScriptId) });

        }
    }
}
