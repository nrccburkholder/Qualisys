using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Practices.EnterpriseLibrary.Data;
using DataAccess;
using System.Data.Common;

namespace SurveyPointDAL
{
    /// <summary>
    /// Summary description for clsTemplate.
    /// </summary>
    public class clsTemplate
    {
        public const string TABLE_NAME = "Templates";
        public const string COL_SURVEYID = "SurveyID";
        public const string COL_SCRIPTID = "ScriptID";
        public const string COL_CLIENTID = "ClientID";
        public const string COL_FILEDEFID = "FileDefID";
        
        public static dsSurveyPoint.TemplatesDataTable getTemplates()
        {            
            DBFilter filter = new DBFilter();
            filter.AddNotNullFilter("FileDefID");
            return getTemplates(filter);
        }

        public static dsSurveyPoint.TemplatesDataTable getTemplates(DBFilter filter)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = String.Format("SELECT * FROM vw_Templates {0} ORDER BY ClientName, SurveyName", filter.GenerateWhereClause());
            dsSurveyPoint ds = new dsSurveyPoint();
            //TP Change.
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            return ds.Templates;
        }


        public static dsSurveyPoint.TemplatesRow getTemplate(int iTemplateId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM vw_Templates WHERE TemplateId = " + iTemplateId.ToString();
            dsSurveyPoint ds = new dsSurveyPoint();
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME }, new SqlParameter[] { new SqlParameter("@TemplateId", iTemplateId) });
            if (ds.Templates.Rows.Count > 0)
                return (dsSurveyPoint.TemplatesRow)ds.Templates.Rows[0];
            else
                return null;
        }

        public static void deleteTemplate(int iTemplateId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "DELETE FROM Templates WHERE TemplateId = @TemplateId";
            //TP Change 
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@TemplateID", iTemplateId));
            SqlHelper.Db(conn).ExecuteNonQuery(cmd);
            //SqlHelper.ExecuteNonQuery(conn, CommandType.Text, sql, new SqlParameter[] { new SqlParameter("@TemplateId", iTemplateId) });
        }

        public static void updateTemplate(dsSurveyPoint.TemplatesRow template)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "UPDATE Templates SET ClientID = @ClientID, ScriptID = @ScriptID, FileDefID = @FileDefID, Description = @Description, Notes = @Notes WHERE (TemplateID = @TemplateID)";
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@TemplateID", template.TemplateID);
            param[1] = new SqlParameter("@ClientID", template.ClientID);
            param[2] = new SqlParameter("@ScriptID", template.ScriptID);
            param[3] = new SqlParameter("@FileDefID", SqlDbType.Int);
            if (template.IsFileDefIDNull())
                param[3].Value = DBNull.Value;
            else
                param[3].Value = template.FileDefID;
            param[4] = new SqlParameter("@Description", SqlDbType.VarChar, 1000);
            if (template.IsDescriptionNull())
                param[4].Value = DBNull.Value;
            else
                param[4].Value = template.Description;
            param[5] = new SqlParameter("@Notes", SqlDbType.VarChar, 1000);
            if (template.IsNotesNull())
                param[5].Value = DBNull.Value;
            else
                param[5].Value = template.Notes;
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.AddRange(param);
            SqlHelper.Db(conn).ExecuteNonQuery(cmd);            
            //SqlHelper.ExecuteNonQuery(conn, CommandType.Text, sql, param);

        }

        public static void insertTemplate(dsSurveyPoint.TemplatesRow template)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "INSERT INTO Templates(ClientID, ScriptID, FileDefID, Description, Notes) VALUES(@ClientID, @ScriptID, @FileDefID, @Description, @Notes); SET @TemplateID = @@IDENTITY";
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@TemplateID", SqlDbType.Int);
            param[0].Direction = ParameterDirection.Output;
            param[1] = new SqlParameter("@ClientID", template.ClientID);
            param[2] = new SqlParameter("@ScriptID", template.ScriptID);
            param[3] = new SqlParameter("@FileDefID", SqlDbType.Int);
            if (template.IsFileDefIDNull())
                param[3].Value = DBNull.Value;
            else
                param[3].Value = template.FileDefID;
            param[4] = new SqlParameter("@Description", SqlDbType.VarChar, 1000);
            if (template.IsDescriptionNull())
                param[4].Value = DBNull.Value;
            else
                param[4].Value = template.Description;
            param[5] = new SqlParameter("@Notes", SqlDbType.VarChar, 1000);
            if (template.IsNotesNull())
                param[5].Value = DBNull.Value;
            else
                param[5].Value = template.Notes;
            //TP Change 
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.AddRange(param);
            SqlHelper.Db(conn).ExecuteNonQuery(cmd);                 
            //SqlHelper.ExecuteNonQuery(conn, CommandType.Text, sql, param);

            template.TemplateID = Convert.ToInt32(param[0].Value);
        }

        public static bool existClientScriptTemplate(int ClientID, int ScriptID, int TemplateID)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            DBFilter filter = new DBFilter();
            if (ClientID > 0) filter.AddSelectNumericFilter("ClientID", ClientID.ToString());
            if (ScriptID > 0) filter.AddSelectNumericFilter("ScriptID", ScriptID.ToString());
            if (TemplateID > 0) filter.AddCustomFilter(String.Format("TemplateID <> {0}", TemplateID));
            string sql = String.Format("SELECT COUNT(*) FROM Templates {0}", filter.GenerateWhereClause());
            //TP Change
            Object result = SqlHelper.Db(conn).ExecuteScalar(CommandType.Text, sql);
            //Object result = SqlHelper.ExecuteScalar(conn, CommandType.Text, sql);
            if (result != null && result != DBNull.Value)
                return (Convert.ToInt32(result) > 0);
            else
                return false;

        }

        public static IDataReader importResponses(int FileDefID, string sFileRow, int SurveyInstanceID, bool AllowRedoOfResponses)
        {
            string connStr = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            SqlConnection conn = new SqlConnection(connStr);
            return importResponses(conn, FileDefID, sFileRow, SurveyInstanceID, AllowRedoOfResponses);
        }

        public static IDataReader importResponses(SqlConnection conn, int FileDefID, string sFileRow, int SurveyInstanceID, bool AllowRedoOfResponses)
        {
            string sql = "processFixWidthLine";
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@filedefid", FileDefID);
            param[1] = new SqlParameter("@line", SqlDbType.VarChar, 8000);
            param[1].Value = sFileRow;
            param[2] = new SqlParameter("@surveyinstanceid", SqlDbType.Int);
            if (SurveyInstanceID > 0)
                param[2].Value = SurveyInstanceID;
            else
                param[2].Value = DBNull.Value;
            param[3] = new SqlParameter("@allowRedoOfResponses", SqlDbType.Int);
            if (AllowRedoOfResponses)
                param[3].Value = 1;
            else
                param[3].Value = 0;


            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandText = sql;
            cmd.CommandTimeout = 0;
            cmd.CommandType = CommandType.StoredProcedure;
            for (int i = 0; i <= 3; i++)
                cmd.Parameters.Add(param[i]);

            return cmd.ExecuteReader();

            //			return SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, sql, param);
            /*
            string sql = "SELECT RespondentID, 1 AS TemplateID, 143 AS FileDefID, 3 AS SurveyID, 3 AS ClientID, SurveyInstanceID, 1 AS ScriptID, 3 AS numerrors, 3 AS numwarnings FROM Respondents WHERE (RespondentID = 2851);";
            sql += "SELECT TOP 6 EventLogID AS id, UserID AS severity, EventParameters AS etext FROM EventLog WHERE (EventParameters IS NOT NULL) AND (EventParameters <> '')";
            return SqlHelper.ExecuteReader(conn,CommandType.Text, sql);
            */

        }

        public static IDataReader importResponses(SqlTransaction trans, int FileDefID, string sFileRow, int SurveyInstanceID, bool AllowRedoOfResponses)
        {
            string sql = "processFixWidthLine";
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@filedefid", FileDefID);
            param[1] = new SqlParameter("@line", SqlDbType.VarChar, 8000);
            param[1].Value = sFileRow;
            param[2] = new SqlParameter("@surveyinstanceid", SqlDbType.Int);
            if (SurveyInstanceID > 0)
                param[2].Value = SurveyInstanceID;
            else
                param[2].Value = DBNull.Value;
            param[3] = new SqlParameter("@allowRedoOfResponses", SqlDbType.Int);
            if (AllowRedoOfResponses)
                param[3].Value = 1;
            else
                param[3].Value = 0;

            //			return SqlHelper.ExecuteReader(trans, CommandType.StoredProcedure, sql, param);

            SqlCommand cmd = trans.Connection.CreateCommand();
            cmd.CommandText = sql;
            cmd.CommandTimeout = 0;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Transaction = trans;
            for (int i = 0; i <= 3; i++)
                cmd.Parameters.Add(param[i]);

            return cmd.ExecuteReader();

            /*
            string sql = "SELECT RespondentID, 1 AS TemplateID, 143 AS FileDefID, 3 AS SurveyID, 3 AS ClientID, SurveyInstanceID, 1 AS ScriptID, 3 AS numerrors, 3 AS numwarnings FROM Respondents WHERE (RespondentID = 2851);";
            sql += "SELECT TOP 6 EventLogID AS id, UserID AS severity, EventParameters AS etext FROM EventLog WHERE (EventParameters IS NOT NULL) AND (EventParameters <> '')";
            return SqlHelper.ExecuteReader(conn,CommandType.Text, sql);
            */

        }

    }
}
