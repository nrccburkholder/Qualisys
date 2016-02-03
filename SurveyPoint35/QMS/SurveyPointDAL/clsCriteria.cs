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
    /// Summary description for clsCriteria.
    /// </summary>
    public class clsCriteria
    {
        private SqlConnection _conn = null;
        public const string TABLE_NAME = "Criteria";

        public clsCriteria(SqlConnection connection)
        {
            _conn = connection;
        }

        public dsSurveyPoint.CriteriaDataTable ExpandCriteria(int iCriteriaID)
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CriteriaID", iCriteriaID);
            //TP Change
            DbCommand cmd = SqlHelper.Db(_conn.ConnectionString).GetStoredProcCommand("get_Criteria", param);
            SqlHelper.Db(_conn.ConnectionString).LoadDataSet(cmd, ds, new string[] { TABLE_NAME });
            //SqlHelper.FillDataset(_conn, "get_Criteria", ds, new string[] { TABLE_NAME }, param);
            return ds.Criteria;
        }

        public static dsSurveyPoint.CriteriaTypesDataTable GetCriteriaTypes()
        {
            dsSurveyPoint ds = new dsSurveyPoint();
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
            string sql = "SELECT * FROM CriteriaTypes ORDER BY Name";
            //TP Change
            SqlHelper.Db(conn).LoadDataSet(CommandType.Text, sql, ds, new string[] { "CriteriaTypes" });
            //SqlHelper.FillDataset(conn, CommandType.Text, sql, ds, new string[] { "CriteriaTypes" });
            return ds.CriteriaTypes;
        }
    }
}
