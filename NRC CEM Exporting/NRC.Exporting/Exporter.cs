using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting.DataProviders;
using System.Data.SqlClient;
using System.Data;

namespace NRC.Exporting
{
    public class Exporter
    {

        #region private members

        private SqlDataProvider ExporterDataProvider;

        #endregion

        #region constructors

        public Exporter()
        {
            ExporterDataProvider = new SqlDataProvider();
        }

        #endregion

        #region public methods

        public ExportTemplate GetExportTemplate(int TemplateID)
        {
            return LoadTemplate(TemplateID);
        }

        public List<ExportTemplate> GetExportTemplates()
        {
            return LoadTemplates();
        }

        #endregion

        #region private methods

            #region templates
            internal ExportTemplate PopulateExportTemplate(DataRow dr)
            {
                ExportTemplate template = new ExportTemplate();

                template.ExportTemplateID = (int)dr["ExportTemplateID"];
                template.ExportTemplateName = dr["ExportTemplateName"].ToString();
                template.XMLSchemaDefinition = dr["XMLSchemaDefinition"].ToString();
                //TODO -- add the rest of the property assignments

                foreach (DataRow cr in dr.GetChildRows("ExportSections"))
                {
                    template.Sections.Add(PopulateExportSection(cr));
                }

                return template;
            }

            internal ExportSection PopulateExportSection(DataRow dr)
            {
                ExportSection section = new ExportSection();

                section.ExportTemplateSectionID = (int)dr["ExportTemplateSectionID"];
                section.ExportTemplateSectionName = dr["ExportTemplateSectionName"].ToString();
                section.ExportTemplateID = (int)dr["ExportTemplateID"];
                section.DefaultNamingConvention = dr["DefaultNamingConvention"].ToString();

                foreach (DataRow cr in dr.GetChildRows("ExportColumns"))
                {
                    section.ExportColumns.Add(PopulateExportColumn(cr));
                }

                return section;
            }

            internal ExportColumn PopulateExportColumn(DataRow dr)
            {
                ExportColumn column = new ExportColumn();
                column.ExportTemplateSectionID = (int)dr["ExportTemplateSectionID"];
                column.ExportTemplateColumnID = (int)dr["ExportTemplateColumnID"];
                column.ExportTemplateColumnDescription = dr["ExportTemplateColumnDescription"].ToString();
                column.ColumnOrder = (int)dr["ColumnOrder"];
                column.DataSourceID = (int)dr["DatasourceID"];
                column.ExportColumnName = dr["ExportColumnName"].ToString();
                column.DispositionProcessID = dr["DispositionProcessID"] == DBNull.Value ? null : (int?)dr["DispositionProcessID"];
                column.FixedWidthLength = dr["FixedWidthLength"] == DBNull.Value ? null : (int?)dr["FixedWidthLength"];
                column.ColumnSetKey = dr["ColumnSetKey"] == DBNull.Value ? null : (int?)dr["ColumnSetKey"];
                column.FormatID = dr["FormatID"] == DBNull.Value ? null : (int?)dr["FormatID"];
                column.MissingThreshholdPercentage = dr["MissingThresholdPercentage"] == DBNull.Value ? null : (double?)dr["MissingThresholdPercentage"];
                column.CheckFrequencies = (bool)dr["CheckFrequencies"];

                foreach (DataRow cr in dr.GetChildRows("ExportResponses"))
                {
                    column.ColumnResponses.Add(PopulateExportColumnResponse(cr));
                }

                return column;
            }

            internal ExportColumnResponse PopulateExportColumnResponse(DataRow dr)
            {
                ExportColumnResponse response = new ExportColumnResponse();

                response.ExportTemplateColumnResponseID = (int)dr["ExportTemplateColumnResponseID"];
                response.ExportColumnName = dr["ExportColumnname"] == DBNull.Value ? string.Empty : dr["ExportColumnname"].ToString();
                response.RawValue = (int)dr["RawValue"];
                response.RecodeValue = dr["RecodeValue"].ToString();
                response.ResponseLabel = dr["ResponseLabel"].ToString();

                return response;
            }

            internal ExportTemplate LoadTemplate(int templateId)
            {

                ExportTemplate template = new ExportTemplate();

                //using (DataSet ds = ExportTemplateDataProvider.LoadExportTemplateByID(templateId))
                //{

                //    ds.Relations.Add("ExportSections", ds.Tables[0].Columns["ExportTemplateID"], ds.Tables[1].Columns["ExportTemplateID"]);
                //    ds.Relations.Add("ExportColumns", ds.Tables[1].Columns["ExportTemplateSectionID"], ds.Tables[2].Columns["ExportTemplateSectionID"]);
                //    ds.Relations.Add("ExportResponses", ds.Tables[2].Columns["ExportTemplateColumnID"], ds.Tables[3].Columns["ExportTemplateColumnID"]);

                //    foreach (DataRow dr in ds.Tables[0].Rows)
                //    {
                //        template = PopulateExportTemplate(dr);
                //    }
                //}

                return template;
            }

            internal List<ExportTemplate> LoadTemplates()
            {
                //List<ExportTemplate> templates = new List<ExportTemplate>();

                //using (DataSet ds = ExportTemplateDataProvider.LoadExportTemplates())
                //{
                //    if (ds.Tables.Count > 0)
                //    {
                //        ExportTemplate template = new ExportTemplate();

                //        ds.Relations.Add("ExportSections", ds.Tables[0].Columns["ExportTemplateID"], ds.Tables[1].Columns["ExportTemplateID"]);
                //        ds.Relations.Add("ExportColumns", ds.Tables[1].Columns["ExportTemplateSectionID"], ds.Tables[2].Columns["ExportTemplateSectionID"]);
                //        ds.Relations.Add("ExportResponses", ds.Tables[2].Columns["ExportTemplateColumnID"], ds.Tables[3].Columns["ExportTemplateColumnID"]);

                //        foreach (DataRow dr in ds.Tables[0].Rows)
                //        {
                //            templates.Add(PopulateExportTemplate(dr));
                //        }
                //    }

                //}

                return ExportTemplateProvider.Select(null);
            }

            #endregion

        #endregion
    }
}
