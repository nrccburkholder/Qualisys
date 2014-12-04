﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;

namespace NRC.Exporting.DataProviders
{
    public class ExportQueueFileProvider
    {

        private static SqlDataProvider SqlProvider
        {
            get
            {
                return new SqlDataProvider();
            }
        }

        #region private methods

        private static ExportQueueFile PopulateExportQueueFile(DataRow dr)
        {
            ExportQueueFile queuefile = new ExportQueueFile();

            queuefile.ExportQueueFileID = (int)dr["ExportQueueFileID"];
            queuefile.ExportQueueID = (int)dr["ExportQueueID"];
            queuefile.CMSResponseCode = dr["CMSResponseCode"].ToString();
            queuefile.FileMakerName = dr["FileMakerName"].ToString();
            queuefile.FileMakerType = dr["FileMakerType"] == DBNull.Value ? null : (int?)dr["FileMakerType"];
            queuefile.SubmissionDate = dr["SubmissionDate"] == DBNull.Value ? null : (DateTime?)dr["SubmissionDate"];
            queuefile.FileMakerDate = dr["FileMakerDate"] == DBNull.Value ? null : (DateTime?)dr["FileMakerDate"];
            queuefile.CMSResponseDate = dr["CMSResponseDate"] == DBNull.Value ? null : (DateTime?)dr["CMSResponseDate"];
            queuefile.SubmissionBy = dr["SubmissionBy"].ToString();

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

        public static List<ExportQueueFile> Select(ExportQueueFile queuefile)
        {

            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@ExportQueueID", queuefile.ExportQueueID) };

            DataSet ds = new DataSet();
            SqlProvider.Fill(ref ds, "CEM.SelectExportQueueFile", CommandType.StoredProcedure, param);

            using (ds)
            {
                return PopulateQueueFileList(ds);
            }

        }

        #endregion

    }
}
