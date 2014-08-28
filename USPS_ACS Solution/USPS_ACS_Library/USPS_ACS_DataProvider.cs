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
            string proc = "USPS_ASC_SelectSchema";
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

        public static DataTable SelectExtractFileRecordsByStatus(params string[] args)
        {
            string proc = "USPS_ASC_SelectExtractFileRecordsByStatus";
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

        public static List<UpdateResult> UpdateAddress(params object[] args)
        {
            string proc = "USPS_ASC_UpdateAddress";
            DbCommand cmd = Db.GetStoredProcCommand(proc, args);

            try
            {
                List<UpdateResult> results = new List<UpdateResult>();
                using (SafeDataReader rdr = new SafeDataReader(Db.ExecuteReader(cmd)))
                {
                    while (rdr.Read())
                    {
                        results.Add(new UpdateResult(rdr.GetInteger("Status"), rdr.GetString("Message")));
                    }
                }

                
                return results;

            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }

        }
    }
}
