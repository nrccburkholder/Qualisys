using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
namespace NRC.Miscellaneous
{

	public class ADO_AccessLayer
	{

		public static object DBCommandExecuteScalar(DbCommand DBCommandObject)
		{
			return DBCommandExecuteScalar(DBCommandObject, 3, 30);
		}

		public static object DBCommandExecuteScalar(DbCommand DBCommandObject, int DBRetryCount, int DBRetryInterval)
		{
			int iCounter = 0;

			while (iCounter < DBRetryCount) 
            {
				try 
                {
                    return DBCommandObject.ExecuteScalar();
				} 
                catch (Exception ex) 
                {
                    iCounter += 1;
                    if (iCounter >= DBRetryCount)
                    {
                        ex.Data["ADO_AccessLayer::DBExecuteScalar::SQL"] = DBCommandObject.CommandText;
                        throw;
                    }
				}
				
                if (DBRetryInterval > 0) 
                {
					System.Threading.Thread.Sleep(new TimeSpan(0, 0, DBRetryInterval));
				}
			}
			return null;
		}

		public static DbDataReader DBCommandExecuteReader(DbCommand DBCommandObject)
		{
			return DBCommandExecuteReader(DBCommandObject, 3, 30);
		}

		public static DbDataReader DBCommandExecuteReader(DbCommand DBCommandObject, int DBRetryCount, int DBRetryInterval)
		{

			int iCounter = 0;

			while (iCounter < DBRetryCount) {
				try {
					return DBCommandObject.ExecuteReader();
				} catch (Exception ex) {
                    iCounter += 1;
                    if (iCounter >= DBRetryCount)
                    {
                        ex.Data["ADO_AccessLayer::DBCommandExecuteReader::SQL"] = DBCommandObject.CommandText;
                        throw;
                    }
				}
				if (DBRetryInterval > 0) {
					System.Threading.Thread.Sleep(new TimeSpan(0, 0, DBRetryInterval));
				}
			}

			return null;
		}

		public static int DBCommandExecuteNonQuery(DbCommand DBCommandObject)
		{
			return DBCommandExecuteNonQuery(DBCommandObject, 3, 30);
		}

		public static int DBCommandExecuteNonQuery(DbCommand DBCommandObject, int DBRetryCount, int DBRetryInterval)
		{
			int iCounter = 0;

			while (iCounter < DBRetryCount || DBRetryCount < 0) {
				try {
					return DBCommandObject.ExecuteNonQuery();
				} catch (Exception ex) {
                    iCounter += 1;
                    if (iCounter >= DBRetryCount)
                    {
                        ex.Data["ADO_AccessLayer::DBCommandExecuteNonQuery::SQL"] = DBCommandObject.CommandText;
                        throw;
                    }
				}
				if (DBRetryInterval > 0) {
					System.Threading.Thread.Sleep(new TimeSpan(0, 0, DBRetryInterval));
				}
			}

			return 0;

		}

	}

}
