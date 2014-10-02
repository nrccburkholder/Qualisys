using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using NLog;

namespace ServiceLogging
{
    public static class Logs
    {

        private static Logger _logger = LogManager.GetCurrentClassLogger();

        public static string FormatMessage(string msg)
        {
            return DateTime.Now.ToString() + " : " + msg;
        }

        /// <summary>
        /// Logs Fatal Exception
        /// </summary>
        /// <param name="exc"></param>
        public static void LogFatalException(Exception exc)
        {
            string message = String.Format(
            "(Application {0}) {1}", "Get version", exc.Message);

            _logger.Fatal(message, exc);
        }

        /// <summary>
        /// Logs Exception
        /// </summary>
        /// <param name="exc"></param>
        public static void LogException(string info, Exception exc)
        {
            string message = info + " " + String.Format(
            "(Application {0}) {1}", "Get version", exc.Message);

            _logger.Fatal(message, exc);
        }
        /// <summary>
        /// Logs informational messages.
        /// </summary>
        /// <param name="info"></param>
        public static void Info(string info)
        {
            _logger.Log(NLog.LogLevel.Info, info);
        }

        /// <summary>
        /// Logs Trace level messages.
        /// </summary>
        /// <param name="info"></param>
        public static void Trace(string info)
        {
            _logger.Log(NLog.LogLevel.Trace, info);
        }

        /// <summary>
        /// Logs warning messages.
        /// </summary>
        /// <param name="info"></param>
        public static void Warn(string info)
        {
            _logger.Log(NLog.LogLevel.Warn, info);
        }

        /// <summary>
        /// Generates appropriate logs based on the Log Level provided.
        /// </summary>
        /// <param name="nrcLogLevel"></param>
        /// <param name="msg"></param>
        public static void Log(LogLevel nrcLogLevel, string msg)
        {
            _logger.Log(nrcLogLevel.ToNLogLogLevel(), msg);
        }

        /// <summary>
        /// This is to catch App domain level UnhandledException.
        ///usage: /AppDomain.CurrentDomain.UnhandledException += OnUnhandledException; 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public static void OnUnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
            if (e.IsTerminating)
            {
                _logger.Info("Application is terminating due to an unhandled exception in a secondary thread.");
            }
            LogFatalException(e.ExceptionObject as Exception);
        }

        /// <summary>
        /// This is to catch ThreadException UnhandledException.
        ///usage: Application.ThreadException += OnThreadException;
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public static void OnThreadException(object sender, ThreadExceptionEventArgs e)
        {
            LogFatalException(e.Exception);
        }

        public static NLog.LogLevel ToNLogLogLevel(this LogLevel level)
        {
            NLog.LogLevel nloglevel = null;
            switch (level)
            {
                case LogLevel.Debug:
                    nloglevel = NLog.LogLevel.Debug;
                    break;
                case LogLevel.Error:
                    nloglevel = NLog.LogLevel.Error;
                    break;
                case LogLevel.Fatal:
                    nloglevel = NLog.LogLevel.Fatal;
                    break;
                case LogLevel.Info:
                    nloglevel = NLog.LogLevel.Info;
                    break;
                case LogLevel.Off:
                    nloglevel = NLog.LogLevel.Off;
                    break;
                case LogLevel.Trace:
                    nloglevel = NLog.LogLevel.Trace;
                    break;
                case LogLevel.Warn:
                    nloglevel = NLog.LogLevel.Warn;
                    break;
                default:
                    throw new Exception("Invalid LogLevel");
            }
            return nloglevel;
        }

    }
}
