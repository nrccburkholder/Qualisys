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
    /// Summary description for clsRespondentProperty.
    /// </summary>
    public class clsRespondentProperty : clsUpdateData
    {

        public const string TABLE_NAME = "RespondentProperties";

        public static void FillTable(DataSet ds, int iRespondentId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM RespondentProperties WHERE RespondentId = @RespondentId";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@RespondentId", iRespondentId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //    new SqlParameter[] { new SqlParameter("@RespondentId", iRespondentId) });

        }

        public static void CommitTable(SqlConnection conn, DataSet ds)
        {
            clsRespondentProperty el = new clsRespondentProperty();
            SqlDataAdapter da = el.GetDataAdapter(conn);
            da.Update(ds, TABLE_NAME);
            da.Dispose();
        }

        protected override SqlCommand DeleteCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("delete_RespondentProperties", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentPropertyID", SqlDbType.Int, 4, "RespondentPropertyID"))
            return null;
        }

        protected override SqlCommand InsertCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("insert_RespondentProperties", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentPropertyID", SqlDbType.Int, 4, "RespondentPropertyID"))
            //oCmd.Parameters("@RespondentPropertyID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyName", SqlDbType.VarChar, 100, "PropertyName"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyValue", SqlDbType.VarChar, 100, "PropertyValue"))
            return null;
        }

        protected override SqlCommand UpdateCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("update_RespondentProperties", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentPropertyID", SqlDbType.Int, 4, "RespondentPropertyID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyName", SqlDbType.VarChar, 100, "PropertyName"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PropertyValue", SqlDbType.VarChar, 100, "PropertyValue"))
            return null;
        }

    }
}
