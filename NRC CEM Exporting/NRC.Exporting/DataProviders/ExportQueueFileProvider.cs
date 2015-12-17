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
    internal class ExportQueueFileProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider(DB.CEM);
            }
        }

        #region private methods

        private static ExportQueueFile PopulateExportQueueFile(DataRow dr) 
        {
            ExportQueueFile queuefile = new ExportQueueFile();

            queuefile.ExportQueueFileID = (int)dr["ExportQueueFileID"];
            queuefile.ExportQueueID = (int)dr["ExportQueueID"];
            queuefile.FileState = (Int16)dr["FileState"];
            queuefile.SubmissionDate = dr["SubmissionDate"] == DBNull.Value ? null : (DateTime?)dr["SubmissionDate"];
            queuefile.SubmissionBy = dr["SubmissionBy"] == DBNull.Value ? null : dr["SubmissionBy"].ToString();
            queuefile.CMSResponseCode = dr["CMSResponseCode"] == DBNull.Value ? null : dr["CMSResponseCode"].ToString();
            queuefile.CMSResponseDate = dr["CMSResponseDate"] == DBNull.Value ? null : (DateTime?)dr["CMSResponseDate"];       
            queuefile.FileMakerType = dr["FileMakerType"] == DBNull.Value ? null : (int?)dr["FileMakerType"];
            queuefile.FileMakerName = dr["FileMakerName"] == DBNull.Value ? null : dr["FileMakerName"].ToString();
            queuefile.FileMakerDate = dr["FileMakerDate"] == DBNull.Value ? null : (DateTime?)dr["FileMakerDate"];
            return queuefile;
        }


        private static List<ExportQueueFile> PopulateQueueFileList(DataSet ds)
        {
            List<ExportQueueFile> queuefiles = new List<ExportQueueFile>();

            if (ds.Tables.Count > 0)
            {
                ExportQueue queue = new ExportQueue();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    queuefiles.Add(PopulateExportQueueFile(dr));
                }
            }

            return queuefiles;
        }


        #endregion


        #region public methods

        internal static List<ExportQueueFile> Select(ExportQueueFile queuefile)
        {

            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ExportQueueID", queuefile.ExportQueueID),
                                                        new SqlParameter("@FileState", queuefile.FileState)};

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectExportQueueFile", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateQueueFileList(ds);
            }

        }


        internal static void Update(ExportQueueFile queuefile)
        {
            SqlParameter[] param = new SqlParameter[] {new SqlParameter("@ExportQueueFileID",queuefile.ExportQueueFileID),
                                                       new SqlParameter("@FileState", queuefile.FileState),
                                                       new SqlParameter("@SubmissionDate", queuefile.SubmissionDate),
                                                       new SqlParameter("@SubmissionBy", queuefile.SubmissionBy),
                                                       new SqlParameter("@CMSResponseCode", queuefile.CMSResponseCode),
                                                       new SqlParameter("@CMSResponseDate", queuefile.CMSResponseDate),
                                                       new SqlParameter("@FileMakerType", queuefile.FileMakerType),
                                                       new SqlParameter("@FileMakerName", queuefile.FileMakerName),
                                                       new SqlParameter("@FileMakerDate",queuefile.FileMakerDate)
                                                       };

            SqlProvider.ExecuteNonQuery("CEM.UpdateExportQueueFile", CommandType.StoredProcedure, param);

        }

        #endregion

    }
}
