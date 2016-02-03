using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Tools
{
    /// <summary>
    /// Summary description for clsTextLog.
    /// </summary>
    public class clsTextLog
    {
        public const string CONFIG_LOGFILE_KEY = "LogFile";

        public clsTextLog()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static void Log(FileInfo logFile, string logMessage)
        {
            StreamWriter sw = null;
            try
            {
                if (!logFile.Directory.Exists) logFile.Directory.Create();
                sw = new StreamWriter(GetLogFilename(logFile), true);
                sw.WriteLine("{0:t}: {1}", DateTime.Now, logMessage);
            }
            finally
            {
                if (sw != null) sw.Close();
            }
        }

        public static void Log(string logFilename, string logMessage)
        {
            FileInfo logFile = new FileInfo(logFilename);
            Log(logFile, logMessage);
        }

        public static void Log(string logMessage)
        {
            System.Configuration.AppSettingsReader asrConfigReader = new System.Configuration.AppSettingsReader();
            string logFilename = asrConfigReader.GetValue(CONFIG_LOGFILE_KEY, typeof(string)).ToString();
            Log(logFilename, logMessage);
        }

        public static string GetLogFilename(FileInfo logFile)
        {
            return string.Format("{0}\\{1}{2:yyyy}{2:MM}{2:dd}{3}", logFile.DirectoryName, logFile.Name.Replace(logFile.Extension, ""), DateTime.Now, logFile.Extension);
        }
    }

    //	Public Const CONFIG_LOGFILE_KEY As String = "LogFile"
    //
    //	Public Shared Sub Log(ByVal logFilename As System.IO.FileInfo, ByVal logMessage As String)
    //	Dim logFile As System.IO.StreamWriter
    //	Try
    //	If Not logFilename.Directory.Exists Then logFilename.Directory.Create()
    //	logFile = New System.IO.StreamWriter(MakeLogFilename(logFilename), True)
    //	logFile.WriteLine("{0:t}: {1}", Date.Now, logMessage)
    //	Finally
    //	If Not IsNothing(logFile) Then logFile.Close()
    //	End Try
    //	End Sub
    //
    //	Public Shared Sub Log(ByVal logFilename As String, ByVal logMessage As String)
    //	Dim file As New System.IO.FileInfo(logFilename)
    //	Log(file, logMessage)
    //
    //	End Sub
    //
    //	Public Shared Sub Log(ByVal logMessage As String)
    //	Dim logfile As String = Configuration.ConfigurationSettings.AppSettings.GetValues(CONFIG_LOGFILE_KEY)(0)
    //	Log(logfile, logMessage)
    //
    //	End Sub
    //
    //	Public Shared Function MakeLogFilename(ByVal log As System.IO.FileInfo) As String
    //	Return String.Format("{0}\{1}{2:yyyy}{2:MM}{2:dd}{3}", log.DirectoryName, log.Name.Replace(log.Extension, ""), DateTime.Now, log.Extension)
    //
    //	End Function

}
