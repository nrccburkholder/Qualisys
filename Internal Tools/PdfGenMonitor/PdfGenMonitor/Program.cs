using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Configuration;

namespace PdfGenMonitor
{
    class Program
    {
        static string _MonitorsLogFilePath = "";

        static void Main(string[] args)
        {
            var logInfo = new StringBuilder();
            logInfo.AppendLine("PdfGenMonitor started " + DateTime.Now.ToString());

            try
            {
                RestarterSection configuration = (RestarterSection)ConfigurationManager.GetSection("Restarter");
                _MonitorsLogFilePath = configuration.LogFileDestinationPath;

                Restarter restarter = new Restarter();
                restarter.MonitoredLogFilePath = configuration.MonitoredLogFilePath;
                restarter.MaxLogFileAgeAllowed = configuration.MaxLogFileAgeAllowed;
                restarter.TerminatedProcessName = configuration.TerminatedProcessName;
                restarter.RestartedApplicationPath = configuration.RestartedApplicationPath;
                restarter.LogFileDestinationPath = configuration.LogFileDestinationPath;

                string commentsConnectionStringLabel = "PdfGenMonitor.Properties.Settings.QP_CommentsConnectionString";
                string dbConnectionString = ConfigurationManager.ConnectionStrings[commentsConnectionStringLabel].ConnectionString;
                restarter.SqlConnectionString = dbConnectionString;

                logInfo.AppendLine();
                logInfo.AppendLine("Configuration:");
                logInfo.AppendLine("MonitoredLogFilePath = " + restarter.MonitoredLogFilePath);
                logInfo.AppendLine("MaxLogFileAgeAllowed = " + restarter.MaxLogFileAgeAllowed.ToString());
                logInfo.AppendLine("TerminatedProcessName = " + restarter.TerminatedProcessName);
                logInfo.AppendLine("RestartedApplicationPath = " + restarter.RestartedApplicationPath);
                logInfo.AppendLine("LogFileDestinationPath = " + restarter.LogFileDestinationPath);

                const string passwordLabel = ";password=";
                string loggedConnectionString = dbConnectionString.ToLower().Contains(passwordLabel) ?
                    dbConnectionString.Substring(0, dbConnectionString.ToLower().IndexOf(passwordLabel) + passwordLabel.Length)
                        + "********" :
                    dbConnectionString;

                logInfo.AppendLine("DB Connection String = " + loggedConnectionString);

                restarter.CheckAndRestart();
            }
            catch(Exception e)
            {
                logInfo.AppendLine();
                logInfo.AppendLine("Exception:");
                logInfo.AppendLine(e.ToString());
                CreateOwnLogFile(logInfo.ToString());
            }
        }

        private static void CreateOwnLogFile(string logInfo)
        {
            // create a time-stamp based name
            try
            {
                Directory.CreateDirectory(_MonitorsLogFilePath);
                string logFileName = Path.Combine(_MonitorsLogFilePath, Restarter.TimestampedFileName("PdfGenMonitor.log"));

                using(StreamWriter logFile = File.CreateText(logFileName))
                {
                    logFile.Write(logInfo);
                    logFile.Close();
                }
            }
            catch (Exception)
            {
                // if we can't log, just exit
            }
        }
    }
}
