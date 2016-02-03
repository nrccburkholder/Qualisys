//© 2004 Sonic Solutions. All rights reserved.
// written by John Wu
// modified by Carl Kelley on 16 Sept

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Collections.Specialized;

namespace DataAccess
{
    /// <summary>
    /// Summary description for DBConnections.
    /// </summary>
    public class DBConnections
    {
        private DBConnections()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        // Database name constants used to specify database
        public static string CONNECTION_STRING_Main = "ConnectionString.Main";

        private static NameValueCollection oConnectionStrings = new NameValueCollection();

        /// <summary>
        /// Returns connection for a specified database
        /// </summary>
        /// <param name="sConnStringName">Database name</param>
        /// <returns>Sql connection object</returns>
        public static SqlConnection GetSQLConnection(string sConnStringName)
        {
            // create all the objects and initialize other members.
            SqlConnection sqlDBConnection = new SqlConnection();

            // Set connection string of the sqlconnection object
            sqlDBConnection.ConnectionString = GetConnectionString(sConnStringName);

            return sqlDBConnection;

        }

        /// <summary>
        /// Returns connection string for a specified database
        /// </summary>
        /// <param name="sConnStringName">Database name</param>
        /// <returns>connection string</returns>
        public static string GetConnectionString(string sConnStringName)
        {
            //do we have a reasonable key?
            if ((sConnStringName == null) || (sConnStringName.Trim().Length == 0))
            {
                throw new Exception("Empty connection string key.");
            }
            // is string already cached?
            else if (oConnectionStrings[sConnStringName] != null)
            {
                return (string)oConnectionStrings[sConnStringName];
            }
            else
            {
                string sConnStringValue;

                try
                {
                    // try to find the key in the AppSettingsReader
                    System.Configuration.AppSettingsReader asrConfigReader = new System.Configuration.AppSettingsReader();
                    sConnStringValue = asrConfigReader.GetValue(sConnStringName, typeof(string)).ToString();
                }
                catch (Exception e)
                {
                    System.Diagnostics.Debug.WriteLine(e.Message);
                    sConnStringValue = null;
                }

                if ((sConnStringValue != null) && (sConnStringValue.Length > 0))
                {
                    //if so, store it in the hash table for later
                    oConnectionStrings.Add(sConnStringName, sConnStringValue);
                    return sConnStringValue;
                }
                else
                {
                    //if not, give up
                    throw new Exception(string.Format("Failed to find connection string key '{0}' in either the registry or the AppSettings."
                        , sConnStringName));
                }
            }
        }

    }
}
