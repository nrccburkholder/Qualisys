using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Diagnostics;
using System.Data.SqlClient;
using PdfGenMonitor.PdfGenStuckJobsTableAdapters;

namespace PdfGenMonitor
{
    class Restarter
    {
        public string MonitoredLogFilePath { get; set; }
        public int MaxLogFileAgeAllowed { get; set; }
        public string TerminatedProcessName { get; set; }
        public string RestartedApplicationPath { get; set; }
        public string LogFileDestinationPath { get; set; }
        public string SqlConnectionString { get; set; }
        
        public void CheckAndRestart()
        {
            if (!IsLogFileCurrent()) // if the log file isn't current, restart the app
            {
                RestartPdfGen();
                throw new ApplicationException("PdfGen appears to have stalled; the log file isn't current. PdfGen has been restarted.");
            }

            int firstStuckJobId = FirstStuckJob();
            if (firstStuckJobId > 0) // if a job is stuck, restart the app
            {
                RestartPdfGen();
                string errorMessage = "PdfGen appears to have stalled; job " +
                    firstStuckJobId.ToString() + " is stuck. PdfGen has been restarted.";
                throw new ApplicationException(errorMessage);
            }
        }

        private void RestartPdfGen()
        {
            CopyLogFile();
            TerminateProcess();
            RestartApplication();
        }

        public static string TimestampedFileName(string fileName)
        {
            return DateTime.Now.ToString("yyyy-MM-dd-HHmm.") + fileName;
        }

        private int FirstStuckJob()
        {
            using(SqlConnection conn = new SqlConnection(SqlConnectionString))
            {
                conn.Open();

                using(PdfGenStuckJobsTableAdapter adapter = new PdfGenStuckJobsTableAdapter())
                {
                    var stuckJobsDataSet = new PdfGenStuckJobs();
                    var stuckJobsTable = (PdfGenStuckJobs.PdfGenStuckJobsDataTable) stuckJobsDataSet.Tables["PdfGenStuckJobs"];

                    adapter.Fill(stuckJobsTable);
                    return (stuckJobsTable.Rows.Count > 0) ? 
                        (int) stuckJobsTable.Rows[0]["Job_ID"] :
                        0;
                }
            }
        }

        private bool IsLogFileCurrent()
        {
            if (string.IsNullOrEmpty(MonitoredLogFilePath))
                throw new ArgumentException("Log file not specified");

            if (!File.Exists(MonitoredLogFilePath))
                throw new FileNotFoundException("Log file not found", MonitoredLogFilePath);

            DateTime lastLogFileModification = File.GetLastWriteTime(MonitoredLogFilePath);
            int secondsSinceLastModification = Convert.ToInt32((DateTime.Now - lastLogFileModification).TotalSeconds);

            return secondsSinceLastModification < MaxLogFileAgeAllowed;
        }

        private void CopyLogFile()
        {
            string destinationLogFilePath = Path.Combine(LogFileDestinationPath, 
                TimestampedFileName(Path.GetFileName(MonitoredLogFilePath)));

            Directory.CreateDirectory(LogFileDestinationPath);
            File.Copy(MonitoredLogFilePath, destinationLogFilePath);
        }

        private void TerminateProcess()
        {
            const int secondsToWaitForTermination = 10;

            Process[] processesToTerminate = Process.GetProcessesByName(TerminatedProcessName);

            foreach(Process process in processesToTerminate)
            {
                process.Kill(); // Note: instead of Kill() we may want to consider CloseMainWindow()
                if (!process.WaitForExit(secondsToWaitForTermination * 1000))
                {
                    string errorMessage = "Unable to terminate process " + TerminatedProcessName;
                    throw new ApplicationException(errorMessage);
                }
            }
        }

        private void RestartApplication()
        {
            // launch the app again, RestartedApplicationPath
            var restartInfo = new ProcessStartInfo();
            restartInfo.WorkingDirectory = Path.GetDirectoryName(RestartedApplicationPath);
            restartInfo.FileName = RestartedApplicationPath;
            Process.Start(restartInfo);
        }
    }
}
