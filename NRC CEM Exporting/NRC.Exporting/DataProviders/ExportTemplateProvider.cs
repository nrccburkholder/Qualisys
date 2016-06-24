using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;

namespace CEM.Exporting.DataProviders
{
    public static class ExportTemplateProvider
    {
        private static SqlDataProvider mSDP;

        private static SqlDataProvider SqlProvider
        {
            get
            {
                if (mSDP == null)
                {
                    // TODO:  read connection string from a param store.
                    mSDP = new SqlDataProvider(DB.CEM);
                }
                return mSDP;
            }
        }


        #region private methods

        internal static ExportTemplate PopulateExportTemplate(DataRow dr, bool b)
        {
            ExportTemplate template = new ExportTemplate();

            template.ExportTemplateID = (int)dr["ExportTemplateID"];
            template.ExportTemplateName = dr["ExportTemplateName"].ToString();           
            template.SurveyTypeID = dr["SurveyTypeID"] == DBNull.Value ? null : (int?)dr["SurveyTypeID"];
            template.SurveySubTypeID = dr["SurveySubTypeID"] == DBNull.Value ? null : (int?)dr["SurveySubTypeID"];
            template.ValidDateColumnID = dr["ValidDateColumnID"] == DBNull.Value ? null : (int?)dr["ValidDateColumnID"];
            template.ValidStartDate = dr["ValidStartDate"] == DBNull.Value ? null : (DateTime?)dr["ValidStartDate"];
            template.ValidEndDate = dr["ValidEndDate"] == DBNull.Value ? null : (DateTime?)dr["ValidEndDate"];
            template.ExportTemplateVersionMajor = dr["ExportTemplateVersionMajor"].ToString();
            template.ExportTemplateVersionMinor = dr["ExportTemplateVersionMinor"] == DBNull.Value ? null : (int?)dr["ExportTemplateVersionMinor"];
            template.CreatedBy = dr["CreatedBy"].ToString();
            template.CreatedOn = dr["CreatedOn"] == DBNull.Value ? null : (DateTime?)dr["CreatedOn"];
            template.ClientID = dr["ClientID"] == DBNull.Value ? null : (int?)dr["ClientID"];
            template.DefaultNotificationID = dr["DefaultNotificationID"] == DBNull.Value ? null : (int?)dr["DefaultNotificationID"];
            template.DefaultNamingConvention = dr["DefaultNamingConvention"].ToString();
            template.State = dr["State"] == DBNull.Value ? null : (int?)dr["State"];
            template.ReturnsOnly = dr["ReturnsOnly"] == DBNull.Value ? false : (bool)dr["ReturnsOnly"];
            template.SampleUnitCahpsTypeID = dr["SampleUnitCahpsTypeID"] == DBNull.Value ? null : (int?)dr["SampleUnitCahpsTypeID"];
            template.XMLSchemaDefinition = dr["XMLSchemaDefinition"].ToString();
            template.isOfficial = dr["isOfficial"] == DBNull.Value ? false : (bool)dr["isOfficial"];

            if (b)
            {
                template.Sections = ExportSectionProvider.Select(new ExportSection { ExportTemplateID = template.ExportTemplateID }, b);
            }

            return template;
        }

        internal static List<ExportTemplate> PopulateTemplateList(DataSet ds, bool b)
        {
            List<ExportTemplate> templates = new List<ExportTemplate>();

            if (ds.Tables.Count > 0)
            {
                ExportTemplate template = new ExportTemplate();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    templates.Add(PopulateExportTemplate(dr, b));
                }
            }

            return templates;
        }


        #endregion


        #region public methods

        public static List<ExportTemplate>Select(ExportTemplate template, bool IncludeChildProperties = false)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportTemplateID",template.ExportTemplateID),
                                                       new SqlParameter("@SurveyTypeId", template.SurveyTypeID),
                                                       new SqlParameter("@ExportTemplateName", template.ExportTemplateName),
	                                                    new SqlParameter("@ExportTemplateVersionMajor", template.ExportTemplateVersionMajor),
	                                                    new SqlParameter("@ExportTemplateVersionMinor",template.ExportTemplateVersionMinor),
                                                        new SqlParameter("@ClientId", template.ClientID)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectTemplate", CommandType.StoredProcedure,param);

            using (ds)
            {
                return PopulateTemplateList(ds, IncludeChildProperties);
            }
        }

        internal static DataTable SelectAsDataTable(ExportTemplate template, bool IncludeChildProperties = false)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportTemplateID",template.ExportTemplateID),
                                                       new SqlParameter("@SurveyTypeId", template.SurveyTypeID),
                                                       new SqlParameter("@ExportTemplateName", template.ExportTemplateName),
                                                        new SqlParameter("@ExportTemplateVersionMajor", template.ExportTemplateVersionMajor),
                                                        new SqlParameter("@ExportTemplateVersionMinor",template.ExportTemplateVersionMinor),
                                                        new SqlParameter("@ClientId", template.ClientID)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "Templates","CEM.SelectTemplate", CommandType.StoredProcedure, param);

            using (ds)
            {
                return ds.Tables["Templates"];
            }
        }

        #endregion

    }
}
