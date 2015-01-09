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
    internal class ExportQueueProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }

        #region private methods

        private static ExportQueue PopulateExportQueue(DataRow dr)
        {
            ExportQueue queue = new ExportQueue();

            queue.ExportQueueID = (int)dr["ExportQueueID"];
            queue.ExportTemplateName = dr["ExportTemplateName"].ToString();
            queue.ExportTemplateVersionMajor = dr["ExportTemplateVersionMajor"].ToString();
            queue.ExportTemplateVersionMinor = dr["ExportTemplateVersionMinor"] == DBNull.Value ? null : (int?)dr["ExportTemplateVersionMinor"];
            queue.ExportDateStart = dr["ExportDateStart"] == DBNull.Value ? null : (DateTime?)dr["ExportDateStart"];
            queue.ExportDateEnd = dr["ExportDateEnd"] == DBNull.Value ? null : (DateTime?)dr["ExportDateEnd"];
            queue.ReturnsOnly = dr["ReturnsOnly"] == DBNull.Value ? false : (bool)dr["ReturnsOnly"];
            queue.ExportNotificationID = dr["ExportNotificationID"] == DBNull.Value ? null : (int?)dr["ExportNotificationID"];
            queue.RequestDate = dr["RequestDate"] == DBNull.Value ? null : (DateTime?)dr["RequestDate"];
            queue.PullDate = dr["PullDate"] == DBNull.Value ? null : (DateTime?)dr["PullDate"];
            queue.ValidatedDate = dr["ValidatedDate"] == DBNull.Value ? null : (DateTime?)dr["ValidatedDate"];
            queue.ValidatedBy = dr["ValidatedBy"].ToString();
            queue.ValidationCode = dr["ValidationCode"].ToString();

            return queue;
        }


        private static List<ExportQueue> PopulateQueueList(DataSet ds)
        {
            List<ExportQueue> queues = new List<ExportQueue>();

            if (ds.Tables.Count > 0)
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    queues.Add(PopulateExportQueue(dr));
                }
            }

            return queues;
        }

        #endregion

        #region public methods

        internal static List<ExportQueue> Select(ExportQueue queue)
        {

            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportQueueID",queue.ExportQueueID),
                                                       new SqlParameter("@ExportTemplateName", queue.ExportTemplateName),
                                                       new SqlParameter("@ExportTemplateVersionMajor", queue.ExportTemplateVersionMajor),
                                                       new SqlParameter("@ExportTemplateVersionMinor",queue.ExportTemplateVersionMinor)
                                                       };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectExportQueue", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateQueueList(ds);
            }

        }

        #endregion

    }
}
