using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Nrc.Framework.Data;
using Nrc.Framework.BusinessLogic.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Common;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using USPS_ACS_Library.Objects;


namespace USPS_ACS_Library
{
    class USPS_ACS_DataProvider
    {

        #region private members
        private static Database mDatabase;
        #endregion

        private static Database Db
        {
            get
            { 
                  if (mDatabase == null)
                  {
                      mDatabase = new Microsoft.Practices.EnterpriseLibrary.Data.Sql.SqlDatabase(AppConfig.QualisysConnection);
                  };
                  return mDatabase;
            }
        }

        public static int InsertDownloadLog(params string[] args)
        {
            string proc = "USPS_ACS_InsertDownloadLog";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Convert.ToInt32(Db.ExecuteScalar(cmd));
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }

        public static int UpdateDownloadLogStatus(params string[] args)
        {
            string proc = "USPS_ACS_UpdateDownloadLogStatus";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
               return Db.ExecuteNonQuery(cmd);
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }

        public static DataSet SelectSchema(params string[] args)
        {
            string proc = "USPS_ACS_SelectSchema";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Db.ExecuteDataSet(cmd);
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }

        public static int InsertExtractFileLog(params string[] args)
        {
            string proc = "USPS_ACS_InsertExtractFileLog";
            DbCommand cmd = Db.GetStoredProcCommand(proc,  args);

            try
            {
                return Convert.ToInt32(Db.ExecuteScalar(cmd));
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }

        public static DataTable SelectExtractFilesByStatus(params string[] args)
        {

            string sArgs = string.Join(",", args);
            string proc = "USPS_ACS_SelectExtractFilesByStatus2";
            DbCommand cmd = Db.GetStoredProcCommand(proc, sArgs);

            try
            {
                return Db.ExecuteDataSet(cmd).Tables[0];
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }

        }

        public static int InsertExtractFileRecord(params object[] args)
        {
            string proc = "USPS_ACS_InsertExtractFileRecord";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Convert.ToInt32(Db.ExecuteScalar(cmd));
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }

        public static int UpdateExtractFileLogStatus(params object[] args)
        {
            string proc = "USPS_ACS_UpdateExtractFileLogStatus";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Db.ExecuteNonQuery(cmd);
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }
/*
        public static DataTable SelectExtractFileRecordsByStatus(params string[] args)
        {
            string proc = "USPS_ACS_SelectExtractFilesByStatus";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Db.ExecuteDataSet(cmd).Tables[0];
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }

        }
*/
        public static int UpdateAddress(params object[] args)
        {
            string proc = "USPS_ACS_ProcessFile";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Convert.ToInt32(Db.ExecuteScalar(cmd));
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }

        }

        /// <summary>
        /// Query for reporting details of entries in USPS_ACS_ExtractFile_PartialMatch which include Partial Match and Multiple Match records
        /// </summary>
        /// <param name="args">This must include one bit parameter (@MarkNotified) which is set to 1 if selected records are to be marked as processed, or 0 otherwise</param>
        /// <returns>A DataTable of Rows not yet processed from the USPS_ACS_ExtractFile_PartialMatch table</returns>
        public static DataTable SelectPartialMatches(params object[] args)
        {
            string proc = "USPS_ACS_SelectPartialMatches";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Db.ExecuteDataSet(cmd).Tables[0];
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }

        }


        public static DataTable SelectPendingPartialMatches(params object[] args)
        {
            string proc = "USPS_ACS_SelectPendingPartialMatches";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                return Db.ExecuteDataSet(cmd).Tables[0];
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }

        }

    }
}
