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

namespace WebSurveyLibrary
{
    class QualisysDataProvider
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

        private static DataSet SelectVendorWebFile_DataByWAC(params string[] args)
        {
            string proc = "QSL_SelectVendorWebFile_DataByWAC";
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

        private static DataSet SelectVendorWebFile_DataByLitho(params string[] args)
        {
            string proc = "QSL_SelectVendorWebFile_DatasByLitho";
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

        public static DataSet SelectDataByWAC(string wac)
        {
            return SelectVendorWebFile_DataByWAC(wac);
        }

        public static DataSet SelectDataByLitho(string litho)
        {
            return SelectVendorWebFile_DataByLitho(litho);
        }
    }
}
