using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;

namespace NRC.Exporting.DataProviders
{
    public static class ExportColumnResponseProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }

        #region private methods

        private static ExportColumnResponse PopulateExportColumnResponse(DataRow dr)
        {
            ExportColumnResponse response = new ExportColumnResponse();

            response.ExportTemplateColumnResponseID = dr["ExportTemplateColumnResponseID"] == DBNull.Value ? null : (int?)dr["ExportTemplateColumnResponseID"];
            response.ExportColumnName = dr["ExportColumnname"] == DBNull.Value ? string.Empty : dr["ExportColumnname"].ToString();
            response.RawValue = dr["RawValue"] == DBNull.Value ? null : (int?)dr["RawValue"];
            response.RecodeValue = dr["RecodeValue"].ToString();
            response.ResponseLabel = dr["ResponseLabel"].ToString();

            return response;
        }


        private static List<ExportColumnResponse> PopulateColumnResponseList(DataSet ds)
        {
            List<ExportColumnResponse> columnResponses = new List<ExportColumnResponse>();

            if (ds.Tables.Count > 0)
            {
                ExportColumnResponse response = new ExportColumnResponse();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    columnResponses.Add(PopulateExportColumnResponse(dr));
                }
            }

            return columnResponses;
        }

        #endregion

        #region public methods

        public static List<ExportColumnResponse> Select(ExportColumnResponse response)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportTemplateID",response.ExportTemplateID),
                                                       new SqlParameter("@ExportTemplateSectionID", response.ExportTemplateSectionID),
                                                       new SqlParameter("@ExportTemplateColumnID",response.ExportTemplateColumnID),
                                                       new SqlParameter("@ExportColumnName", response.ExportColumnName)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectExportTemplateColumnResponse", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateColumnResponseList(ds);
            }
        }

        #endregion
    }
}
