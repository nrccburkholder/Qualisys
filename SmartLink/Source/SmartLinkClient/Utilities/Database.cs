using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Utilities
{
    /// <summary>
    /// Database Utilities
    /// </summary>
    public static class Database
    {
        #region Constructor

        static Database()
        {
            int seconds;
            if (ConfigurationManager.AppSettings.AllKeys.Contains("CommandTimeoutInSeconds")
                && int.TryParse(ConfigurationManager.AppSettings["CommandTimeoutInSeconds"].ToString(), out seconds))
            {
                CommandTimeoutInSeconds = seconds;
            }
            if (CommandTimeoutInSeconds <= 0)
            {
                // Default to 10 minutes
                CommandTimeoutInSeconds = 600;
            }
        }

        #endregion Constructor

        #region Properties

        /// <summary>
        /// Default SQL Command Timeout read from app.config
        /// </summary>
        public static int CommandTimeoutInSeconds { get; private set; }

        #endregion Properties

        /// <summary>
        /// Create Command object with the CommandTimeOut set in the app.config
        /// Expects a SQL Connection.
        /// </summary>
        public static SqlCommand CreateCommand(DbConnection conn, string commandText = "")
        {
            var cmd = conn.CreateCommand();
            cmd.CommandTimeout = CommandTimeoutInSeconds;
            cmd.CommandText = commandText;
            return (SqlCommand)cmd;
        }

        /// <summary>
        /// Ensure that the size of the data that we are importing does not exceed the field size
        /// </summary>
        /// <returns>For blank or null strings an empty string will be returned</returns>
        public static string FitToFieldSize(DataRow dataRow, string fieldName, string value)
        {
            if (value == null)
                return null;

            if (value.Length > dataRow.Table.Columns[fieldName].MaxLength)
                return value.Substring(0, dataRow.Table.Columns[fieldName].MaxLength);

            return value;
        }

    }
}
