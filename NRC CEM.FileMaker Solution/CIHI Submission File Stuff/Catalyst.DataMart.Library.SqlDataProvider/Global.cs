using System;
using Nrc.Framework.Data;
using Nrc.Framework.BusinessLogic;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using Nrc.Framework.BusinessLogic.Configuration;
using System.Data;
using System.Data.Common;

namespace Catalyst.DataMart.Library.DataProvider
{

    public static class Global
    {
        private static Database mDbInstance;

        internal static Database Db
        {
            get
            {
                if (mDbInstance == null)
                {
                    mDbInstance = new SqlDatabase("Data Source=LNK0TCATSQL01\\CATDB2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True;");
                }
                return mDbInstance;
            }
        }

        public static IDataReader ExecuteReader(DbCommand cmd)
        {
            try
            {
                cmd.CommandTimeout = AppConfig.SqlTimeout;
                return Db.ExecuteReader(cmd);
            }
            catch (Exception ex)
            {
                throw new SqlCommandException(cmd, ex);
            }
        }
    }
}
