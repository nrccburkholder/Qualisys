using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Diagnostics;

namespace PdfGenMonitor
{
    class Restarter
    {
        public string MonitoredLogFilePath { get; set; }
        public int MaxLogFileAgeAllowed { get; set; }
        public string TerminatedProcessName { get; set; }
        public string RestartedApplicationPath { get; set; }
        public string LogFileDestinationPath { get; set; }
        
        public void CheckAndRestart()
        {
            if (IsLogFileCurrent())
                return;

            // if log file is too old, copy it, then terminate and restart the app
            CopyLogFile();
            TerminateProcess();
            RestartApplication();
            throw new ApplicationException("The monitored application appears to have stalled and has been restarted.");
        }

        public static string TimestampedFileName(string fileName)
        {
            return DateTime.Now.ToString("yyyy-MM-dd-HHmm.") + fileName;
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
