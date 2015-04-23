using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Nrc.Framework.Data;
using Nrc.Framework.BusinessLogic;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;
using System.Collections.ObjectModel;
using Nrc.Framework.BusinessLogic.Configuration;
using System.Data;
using Catalyst.DataMart.Library;


namespace Catalyst.DataMart.Library.DataProvider
{
    public class SqlDataProvider: CEMDataProvider
    {
        private Database mDBInstance;

        internal Database Db
        {
            get
            {
                if (mDBInstance == null)
                {
                    // TODO:  read connection string from a param store.
                    mDBInstance = new SqlDatabase("Data Source=LNK0TCATSQL01\\CATDB2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True;");
                }
                return mDBInstance;
            }
        }

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
       
            foreach (DataRow cr in dr.GetChildRows("ExportResponses")){
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

        public override ExportTemplate SelectTemplateByTemplateId(int templateId)
        {

            ExportTemplate template = new ExportTemplate();

            DbCommand cmd = Db.GetStoredProcCommand("CEM.SelectTemplateByTemplateId", templateId);

            using (DataSet ds = Db.ExecuteDataSet(cmd)){

                ds.Relations.Add("ExportSections", ds.Tables[0].Columns["ExportTemplateID"], ds.Tables[1].Columns["ExportTemplateID"]);
                ds.Relations.Add("ExportColumns", ds.Tables[1].Columns["ExportTemplateSectionID"], ds.Tables[2].Columns["ExportTemplateSectionID"]);
                ds.Relations.Add("ExportResponses", ds.Tables[2].Columns["ExportTemplateColumnID"], ds.Tables[3].Columns["ExportTemplateColumnID"]);

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    template = PopulateExportTemplate(dr);
                }     
            }

            return template;
        }

    }
}
