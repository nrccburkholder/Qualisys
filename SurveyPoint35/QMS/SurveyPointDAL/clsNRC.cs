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
    /// Summary description for clsNRC.
    /// </summary>
    public class clsNRC
    {
        public static void setTemplateInfoForSurveyInstance(int iSurveyInstanceID, string sProjectID, string sFAQSSTemplateID, string sTemplateID)
        {
            string conn = DBConnections.GetConnectionString(clsConnection.MAIN_DB);

            string sql = "hrc_setTemplateInfoForSurveyInstance";
            DbCommand cmd = SqlHelper.Db(conn).GetStoredProcCommand(sql);
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@SurveyInstanceID", iSurveyInstanceID);
            param[1] = new SqlParameter("@projectID", SqlDbType.VarChar, 5);
            param[1].Value = sProjectID;
            param[2] = new SqlParameter("@FAQSSTemplateID", SqlDbType.VarChar, 8);
            param[2].Value = sFAQSSTemplateID;
            param[3] = new SqlParameter("@templateID", SqlDbType.VarChar, 5);
            param[3].Value = sTemplateID;
            cmd.Parameters.AddRange(param);
            //DbCommand cmd = SqlHelper.Db(conn).GetStoredProcCommand("hrc_setTemplateInfoForSurveyInstance");
            //TP Change
            SqlHelper.Db(conn).ExecuteNonQuery(cmd);
            //SqlHelper.ExecuteNonQuery(conn, CommandType.StoredProcedure, sql, param);
        }
    }
}
