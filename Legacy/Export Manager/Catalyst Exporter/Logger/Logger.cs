using System;
using System.Configuration;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace Nrc.CatalystExporter.Logging
{
    public class Logger
    {
        public static void Log(string message, TraceEventType severity, UserContext context, string category)
        {
            Trace.WriteLine(message);

            string disable = ConfigurationManager.AppSettings["DisableLogging"];
            if (string.IsNullOrWhiteSpace(disable) || disable == "false")
            {
                try
                {
                    var logEntry = new LogEntry();
                    logEntry.Categories.Add(category);
                    logEntry.Severity = severity;
                    logEntry.Message = message;
                    logEntry.TimeStamp = DateTime.Now;


                    if (context != null)
                    {
                        logEntry.ExtendedProperties.Add("UserName", context.UserName);
                    }

                    Microsoft.Practices.EnterpriseLibrary.Logging.Logger.Write(logEntry);
                }
                catch (Exception ex)
                {
                    Trace.WriteLine(ex.ToString()); // don't allow logging to kill application
                }
            }
        }

        public static void Log(string message, TraceEventType severity, UserContext userContext)
        {
            Log(message, severity, userContext, "General");
        }

        public static void Verbose(string message, UserContext userContext)
        {
            Log(message, TraceEventType.Verbose, userContext, "General");
        }

        public static void Error(string message, UserContext userContext)
        {
            Log(message, TraceEventType.Error, userContext, "General");
        }

        public static void Log(Exception ex, UserContext userContext)
        {
            var stack = new System.Text.StringBuilder();
            stack.Append(ex.Message);
            var e2 = ex.InnerException;
            while (e2 != null)
            {
                stack.Append(e2.Message);
                e2 = e2.InnerException;
            }
            stack.Append(ex.StackTrace);

            Error(stack.ToString(), userContext);
        }
    }
}
