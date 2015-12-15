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
    internal class ExportDataSetProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider(DB.CEM);
            }
        }

        #region public methods

        internal static ExportDataSet Select(int? ExportQueueID, int? ExportTemplateID, string sectionName, string filemakername, bool oneRecordPerPatient)
        {
            ExportDataSet exportDataSet = new ExportDataSet();

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportqueueID",ExportQueueID),
                                                        new SqlParameter("@ExportTemplateID", ExportTemplateID),
                                                        new SqlParameter("@SectionName", sectionName),
                                                        new SqlParameter("@FileMakerName", filemakername),
                                                        new SqlParameter("@OneRecordPerPatient", oneRecordPerPatient)
                                                        };
            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectExportData", CommandType.StoredProcedure, param);
            if (ds.Tables.Count > 0)
                exportDataSet.DataTable = ds.Tables[0];

            return exportDataSet;
        }

        #endregion

    }
}
