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
    public class ExportDataProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }



        #region public methods

        public static IDataReader Select(int? ExportQueueID, int? ExportTemplateID)
        {

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportqueueID",ExportQueueID),
                                                        new SqlParameter("@ExportTemplateID", ExportTemplateID)
                                                        };
           
            return SqlProvider.ExecuteReader("CEM.SelectExportData", CommandType.StoredProcedure, param);

        }

        public static DataSet SelectDataSet(int? ExportQueueID, int? ExportTemplateID)
        {

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportqueueID",ExportQueueID),
                                                        new SqlParameter("@ExportTemplateID", ExportTemplateID)
                                                        };
            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds,"CEM.SelectExportData", CommandType.StoredProcedure, param);

            return ds;

        }

        #endregion

    }
}
