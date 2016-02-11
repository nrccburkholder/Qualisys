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
    /// Summary description for clsFileDefinations.
    /// </summary>
    public class clsFileDefs
    {
        public enum FileTypes : int
        {
            COMMA_DELIMITED = 1,
            TAB_DELIMITED = 2,
            OTHER_DELIMITED = 3,
            FIXED_WIDTH = 4
        }

        public enum FileDefTypes : int
        {
            EXPORT = 1,
            IMPORT = 2,
            IMPORTUPDATE = 3
        }

        public const string TABLE_NAME = "FileDefs";

        public static dsSurveyPoint.FileDefsDataTable getImportUpdatesBySurvey(int iSurveyId)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM FileDefs WHERE SurveyId = @SurveyId AND FileDefTypeId = 3";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@SurveyId", iSurveyId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@SurveyId", iSurveyId) });
            return ds.FileDefs;
        }

        public static dsSurveyPoint.FileDefsRow getFileDef(int iFileDefID)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM FileDefs WHERE FileDefID = @FileDefID";
            dsSurveyPoint ds = new dsSurveyPoint();
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@FileDefID", iFileDefID));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME }, new SqlParameter[] { new SqlParameter("@FileDefID", iFileDefID) });
            if (ds.FileDefs.Rows.Count > 0)
                return (dsSurveyPoint.FileDefsRow)ds.FileDefs.Rows[0];
            else
                return null;
        }

        public static void generateFileDefForTemplate(int iTemplateID)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@templateID", iTemplateID);
            param[1] = new SqlParameter("@defaultOpenAnswerWidth", 25);
            param[2] = new SqlParameter("@filetypeID", (int)FileTypes.FIXED_WIDTH);
            //TP Change
            SqlHelper.Db(conn).ExecuteNonQuery("GenerateDefaultFileDefinitionForTemplate", iTemplateID, 25, 4);
            //SqlHelper.Db(conn).ExecuteNonQuery("GenerateDefaultFileDefinitionForTemplate", param);
            //SqlHelper.ExecuteNonQuery(conn, CommandType.StoredProcedure, "GenerateDefaultFileDefinitionForTemplate", param);
        }
    }
}
