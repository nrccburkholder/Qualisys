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
    public static class ExportSectionProvider
    {

        private static SqlDataProvider mSDP;

        internal static SqlDataProvider SqlProvider
        {
            get
            {
                if (mSDP == null)
                {
                    // TODO:  read connection string from a param store.
                    mSDP = new SqlDataProvider();
                }
                return mSDP;
            }
        }


        #region private methods


        private static ExportSection PopulateExportSection(DataRow dr, bool b)
        {
            ExportSection section = new ExportSection();

            section.ExportTemplateSectionID = (int)dr["ExportTemplateSectionID"];
            section.ExportTemplateSectionName = dr["ExportTemplateSectionName"].ToString();
            section.ExportTemplateID = (int)dr["ExportTemplateID"];
            section.DefaultNamingConvention = dr["DefaultNamingConvention"].ToString();

            if (b)
            {
                section.ExportColumns = ExportColumnProvider.Select(new ExportColumn {ExportTemplateID = section.ExportTemplateID, ExportTemplateSectionID = section.ExportTemplateSectionID }, b);
            }

            return section;
        }

        private static List<ExportSection> PopulateSectionList(DataSet ds, bool b)
        {
            List<ExportSection> sections = new List<ExportSection>();

            if (ds.Tables.Count > 0)
            {
                ExportSection template = new ExportSection();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    sections.Add(PopulateExportSection(dr,b));
                }
            }

            return sections;
        }

        #endregion


        #region public methods

        public static List<ExportSection> Select(ExportSection section,bool IncludeChildProperties = false)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportTemplateID",section.ExportTemplateID),
                                                       new SqlParameter("@ExportTemplateSectionID", section.ExportTemplateSectionID),
                                                       new SqlParameter("@ExportTemplateSectionName",section.ExportTemplateSectionName)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectTemplateSection", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateSectionList(ds, IncludeChildProperties);
            }
        }

        #endregion

    }
}
