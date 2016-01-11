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
    internal static class ExportColumnProvider
    {


        private static SqlDataProvider SqlProvider
        {
            get
            {
               return new SqlDataProvider(DB.CEM);
            }
        }


        #region private methods

        private static ExportColumn PopulateExportColumn(DataRow dr, bool b)
        {
            ExportColumn column = new ExportColumn();
            column.ExportTemplateID = (int)dr["ExportTemplateID"];
            column.ExportTemplateSectionID = (int)dr["ExportTemplateSectionID"];
            column.ExportTemplateColumnID = (int)dr["ExportTemplateColumnID"];
            column.ExportTemplateColumnDescription = dr["ExportTemplateColumnDescription"].ToString();
            column.ColumnOrder = (int)dr["ColumnOrder"];
            column.DataSourceID = (int)dr["DatasourceID"];
            column.ExportColumnName = dr["ExportColumnName"].ToString();
            column.SourceColumnType = (int)dr["SourceColumnType"];
            column.DispositionProcessID = dr["DispositionProcessID"] == DBNull.Value ? null : (int?)dr["DispositionProcessID"];
            column.FixedWidthLength = dr["FixedWidthLength"] == DBNull.Value ? null : (int?)dr["FixedWidthLength"];
            column.ColumnSetKey = dr["ColumnSetKey"] == DBNull.Value ? null : (int?)dr["ColumnSetKey"];
            column.FormatID = dr["FormatID"] == DBNull.Value ? null : (int?)dr["FormatID"];
            column.MissingThreshholdPercentage = dr["MissingThresholdPercentage"] == DBNull.Value ? null : (double?)dr["MissingThresholdPercentage"];
            column.CheckFrequencies = (bool)dr["CheckFrequencies"];
            column.MultiResponseOrder = 0;

            if (b)
            {
                column.ColumnResponses = ExportColumnResponseProvider.Select(new ExportColumnResponse { ExportTemplateID = column.ExportTemplateID, ExportTemplateSectionID = column.ExportTemplateSectionID, ExportTemplateColumnID = column.ExportTemplateColumnID });
            }


            return column;
        }


        private static List<ExportColumn> PopulateColumnList(DataSet ds, bool b)
        {
            List<ExportColumn> Columns = new List<ExportColumn>();

            if (ds.Tables.Count > 0)
            {
                ExportColumn template = new ExportColumn();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    Columns.Add(PopulateExportColumn(dr, b));
                }
            }

            return Columns;
        }

        #endregion

        #region public methods

        internal static List<ExportColumn> Select(ExportColumn Column, bool IncludeChildProperties = false)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportTemplateID",Column.ExportTemplateID),
                                                       new SqlParameter("@ExportTemplateSectionID", Column.ExportTemplateSectionID),
                                                       new SqlParameter("@ExportTemplateColumnID",Column.ExportTemplateColumnID),
                                                       new SqlParameter("@ColumnSetKey",Column.ColumnSetKey),
                                                       new SqlParameter("@DataSourceID",Column.DataSourceID),
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectExportTemplateColumn", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateColumnList(ds, IncludeChildProperties);
            }
        }

        #endregion

    }
}
