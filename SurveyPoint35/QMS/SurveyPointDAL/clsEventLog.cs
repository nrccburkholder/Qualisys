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
    /// Summary description for clsEventLog.
    /// </summary>
    public class clsEventLog : clsUpdateData
    {
        public const string TABLE_NAME = "EventLog";

        public static void FillTable(DataSet ds, int iRespondentId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM EventLog WHERE RespondentId = @RespondentId";
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@RespondentId", iRespondentId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
              //  new SqlParameter[] { new SqlParameter("@RespondentId", iRespondentId) });

        }

        public static void CommitTable(SqlConnection conn, DataSet ds)
        {
            clsEventLog el = new clsEventLog();
            SqlDataAdapter da = el.GetDataAdapter(conn);
            da.Update(ds, TABLE_NAME);
            da.Dispose();
        }

        protected override SqlCommand DeleteCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("delete_EventLog", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", SqlDbType.Int, 4, "EventLogID"))
            return null;
        }

        protected override SqlCommand InsertCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("insert_EventLog", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", SqlDbType.Int, 4, "EventLogID"))
            //oCmd.Parameters("@EventLogID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", SqlDbType.VarChar, 100, "EventParameters"))
            return null;
        }

        protected override SqlCommand UpdateCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("update_EventLog", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventLogID", SqlDbType.Int, 4, "EventLogID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventDate", SqlDbType.DateTime, 8, "EventDate"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", SqlDbType.VarChar, 100, "EventParameters"))
            return null;
        }

    }
}
