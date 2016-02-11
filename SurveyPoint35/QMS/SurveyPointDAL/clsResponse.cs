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
    /// Summary description for clsResponse.
    /// </summary>
    public class clsResponse : clsUpdateData
    {

        public const string TABLE_NAME = "Responses";

        public static void FillTable(DataSet ds, int iRespondentId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Responses WHERE RespondentId = @RespondentId";
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@RespondentId", iRespondentId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
             //   new SqlParameter[] { new SqlParameter("@RespondentId", iRespondentId) });

        }

        public static void CommitTable(SqlConnection conn, DataSet ds)
        {
            clsResponse el = new clsResponse();
            SqlDataAdapter da = el.GetDataAdapter(conn);
            da.Update(ds, TABLE_NAME);
            da.Dispose();
        }

        protected override SqlCommand DeleteCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("delete_Responses", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseID", SqlDbType.Int, 4, "ResponseID"))

            return null;
        }

        protected override SqlCommand InsertCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("insert_Responses", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseID", SqlDbType.Int, 4, "ResponseID"))
            //oCmd.Parameters("@ResponseID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
            //oCmd.Parameters("@SurveyQuestionID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseText", SqlDbType.VarChar, 1000, "ResponseText"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))

            return null;
        }

        protected override SqlCommand UpdateCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("update_Responses", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseID", SqlDbType.Int, 4, "ResponseID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
            //oCmd.Parameters("@SurveyQuestionID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ResponseText", SqlDbType.VarChar, 1000, "ResponseText"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))

            return null;
        }

    }
}
