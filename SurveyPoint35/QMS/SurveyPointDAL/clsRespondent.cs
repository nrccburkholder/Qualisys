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
    /// Summary description for clsRespondent.
    /// </summary>
    public class clsRespondent : clsUpdateData
    {
        public const string TABLE_NAME = "Respondents";

        public static void FillTable(DataSet ds, int iRespondentId)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM Respondents WHERE RespondentId = @RespondentId";
            //TP Change
            DbCommand cmd = SqlHelper.Db(conn).GetSqlStringCommand(sql);
            cmd.Parameters.Add(new SqlParameter("@RespondentId", iRespondentId));
            SqlHelper.Db(conn).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { TABLE_NAME },
            //   new SqlParameter[] { new SqlParameter("@RespondentId", iRespondentId) });

        }

        public static void CommitTable(SqlConnection conn, DataSet ds)
        {
            clsRespondent el = new clsRespondent();
            SqlDataAdapter da = el.GetDataAdapter(conn);
            da.Update(ds, TABLE_NAME);
            da.Dispose();
        }


        protected override SqlCommand DeleteCommand(SqlConnection conn)
        {

            //oCmd = New SqlClient.SqlCommand("delete_Respondents", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Input

            return null;
        }

        protected override SqlCommand InsertCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("insert_Respondents", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@MiddleInitial", SqlDbType.VarChar, 10, "MiddleInitial"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.Char, 2, "State"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCodeExt", SqlDbType.VarChar, 10, "PostalCodeExt"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneDay", SqlDbType.VarChar, 50, "TelephoneDay"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneEvening", SqlDbType.VarChar, 50, "TelephoneEvening"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 50, "Email"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@DOB", SqlDbType.DateTime, 8, "DOB"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Gender", SqlDbType.Char, 1, "Gender"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientRespondentID", SqlDbType.VarChar, 50, "ClientRespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SSN", SqlDbType.VarChar, 50, "SSN"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@BatchID", SqlDbType.Int, 8, "BatchID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 8, "SurveyID"))
            //oCmd.Parameters("@SurveyID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 8, "ClientID"))
            //oCmd.Parameters("@ClientID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceName", SqlDbType.VarChar, 100, "SurveyInstanceName"))
            //oCmd.Parameters("@SurveyInstanceName").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyName", SqlDbType.VarChar, 100, "SurveyName"))
            //oCmd.Parameters("@SurveyName").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientName", SqlDbType.VarChar, 100, "ClientName"))
            //oCmd.Parameters("@ClientName").Direction = ParameterDirection.Output

            return null;
        }

        protected override SqlCommand UpdateCommand(SqlConnection conn)
        {
            //oCmd = New SqlClient.SqlCommand("update_Respondents", Me._oConn)
            //oCmd.CommandType = CommandType.StoredProcedure
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", SqlDbType.Int, 4, "RespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@MiddleInitial", SqlDbType.VarChar, 10, "MiddleInitial"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.Char, 2, "State"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCodeExt", SqlDbType.VarChar, 10, "PostalCodeExt"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneDay", SqlDbType.VarChar, 50, "TelephoneDay"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@TelephoneEvening", SqlDbType.VarChar, 50, "TelephoneEvening"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 50, "Email"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@DOB", SqlDbType.DateTime, 8, "DOB"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@Gender", SqlDbType.Char, 1, "Gender"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientRespondentID", SqlDbType.VarChar, 50, "ClientRespondentID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SSN", SqlDbType.VarChar, 50, "SSN"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@BatchID", SqlDbType.Int, 8, "BatchID"))
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 8, "SurveyID"))
            //oCmd.Parameters("@SurveyID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 8, "ClientID"))
            //oCmd.Parameters("@ClientID").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceName", SqlDbType.VarChar, 100, "SurveyInstanceName"))
            //oCmd.Parameters("@SurveyInstanceName").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyName", SqlDbType.VarChar, 100, "SurveyName"))
            //oCmd.Parameters("@SurveyName").Direction = ParameterDirection.Output
            //oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientName", SqlDbType.VarChar, 100, "ClientName"))
            //oCmd.Parameters("@ClientName").Direction = ParameterDirection.Output
            return null;
        }

    }
}
