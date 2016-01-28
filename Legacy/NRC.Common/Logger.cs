using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;

using NLog;
using NLog.Targets;
using NLog.Config;
using InnerLogger = NLog.Logger;

using EventClient = NRC.Common.Application.EventClient;
using FileUtils = NRC.Common.IO.FileUtils;

namespace NRC.Common
{
    /// <summary>
    /// This is the standard logger for NRC applications. It logs to L:\NRC\Logs\ (or to C:\NRC\Logs\ if that doesn't exist), archiving by date.
    /// 
    /// To use the logger, put a call like this in any class you want to log in:
    ///    private static Logger _logger = Logger.GetLogger();
    ///    ...
    ///    _logger.Error("An error occurred!");
    /// 
    /// By default, the logger will log all messages to a file in the log directory with a name based on the application name. It is best practice, but not required, 
    /// to specify a per-application name for the logger, particularly in the case of web applications (where the application name has no useful information). You do this using the 
    /// alternate form of GetLogger:
    ///    private static Logger _logger = Logger.GetLogger("myapp");
    /// 
    /// If you want to specify a per-application name, the location for this call is based on the type of application (since it must occur before any other logging calls):
    ///   - For a service or other executable, put it in the class with the Main() method
    ///   - For a web application, put it in the Globals.aspx file, either in the Application_Start method or on the class itself.
    ///   
    /// In normal use, you'll initialize the logger, read in your configuration, and then update the logger behavior based on settings in the configuration (a log-trace flag, for instance).
    /// Therefore, you'll want to read in configuration as soon as possible once the program starts (possibly right after the GetLogger("name") call).
    /// 
    /// This logger also handles event logging. To use _logger.Event(), you'll need to set an event collector url on the logger (probably from the configuration file as described above).
    /// </summary>
    public class Logger
    {
        protected const string DEFAULT_LOGNAME = "Logger";
        protected const string DEFAULT_LOG_DIR = @"L:\NRC\Logs\";
        protected const string DEFAULT_FALLBACK_LOG_DIR = @"C:\NRC\Logs\";
        
        protected const string FILE_TARGET = "file";
        protected const string EVENT_TARGET = "eventlog";

        protected static InnerLogger _logger = null;
        protected static string _logfile = null;
        protected static EventClient _eventClient = null;
        protected static object _syncLock = new object();

        /// <summary>
        /// Use this method to create a logger for a library class, or outside the core class of the application. See the class comments for details.
        /// </summary>
        public static Logger GetLogger()
        {
            return new Logger();
        }

        /// <summary>
        /// Use this method to create a logger for the core class of the application. See the class comments for details.
        /// </summary>
        public static Logger GetLogger(string applicationName)
        {
            string dir = null;
            if (Directory.Exists(DEFAULT_LOG_DIR) || FileUtils.CanWriteDirectory(DEFAULT_LOG_DIR))
            {
                dir = DEFAULT_LOG_DIR;
            }
            else
            {
                dir = DEFAULT_FALLBACK_LOG_DIR;
            }

            return new Logger(dir, applicationName, false, false, false);
        }

        private Logger()
        {
        }

        /// <summary>
        /// This constructor should only be used by applications that run outside the NRC network (ie, on client machines) or
        /// have exceptional needs for a custom logger; in normal cases, use the static methods above to get a logger
        /// </summary>
        protected Logger(string dir, string applicationName, bool withTrace, bool toEventLog, bool reinitializing)
        {
            lock (_syncLock)
            {
                if (_logger != null && !reinitializing)
                {
                    // InitializationFailure("The logger has already been initialized for an application; the logger must be initialized for an application exactly once (see comments on the Logger class for initialization instructions).", null);
                    // The Logger is already set
                    Info("The logger has already been initialized for an application; the logger must be initialized for an application exactly once (see comments on the Logger class for initialization instructions).");
                    return;
                }

                try
                {
                    _logger = CreateLogger(dir, applicationName, withTrace, toEventLog);
                }
                catch (Exception ex)
                {
                    InitializationFailure(ex.Message, ex);
                }
            }
        }

        private static void InitializationFailure(string msg, Exception ex)
        {
            List<string> extras = new List<string>();
            while (ex != null)
            {
                extras.Add(ex.Message);
                ex = ex.InnerException;
            }

            if (extras.Count > 0)
            {
                msg += String.Format(" (traceback: {0})", String.Join(" / ", extras.ToArray()));
            }

            try
            {
                string src = "Logger setup";
                if (!EventLog.SourceExists(src))
                {
                    EventLog.CreateEventSource(src, "Application");
                }
                EventLog.WriteEntry(src, msg);
            }
            catch (Exception) // just swallow event log failure and throw the deeper exception regardless
            {
            }
            // Do not allow the application to possibly stop running because it cannot log.
            // throw new Exception(String.Format("Failure setting up logger: {0}", msg));
        }

        private static InnerLogger CreateLogger(string dir, string applicationName, bool withTrace, bool toEventLog)
        {
            LoggingConfiguration config = new LoggingConfiguration();

            if (dir != null)
            {
                if (!FileUtils.CanWriteDirectory(dir))
                {
                    throw new Exception(String.Format("Logging requires write access to the directory {0}", dir));
                }
                
                FileTarget fileTarget = new FileTarget();
                _logfile = Path.Combine(dir, String.Format("{0}.txt", applicationName));
                fileTarget.FileName = _logfile;
                // ### is a magic NLog thing for its log-rolling: # means keep 10 backups, ## means keep 100, etc
                fileTarget.ArchiveFileName = Path.Combine(dir, Path.Combine("archive", String.Format("{0}-{1}-${{shortdate}}-{{##}}.txt", applicationName, "error")));
                fileTarget.Layout = "[${longdate}] ${level}: ${message} ${exception:format=tostring}";
                fileTarget.ArchiveAboveSize = 10 * 1024 * 1024;
                fileTarget.ArchiveEvery = FileArchivePeriod.Day;
                fileTarget.Encoding = Encoding.UTF8;
                config.AddTarget(FILE_TARGET, fileTarget);

                LoggingRule fileRule = new LoggingRule("*", (withTrace ? LogLevel.Trace : LogLevel.Info), fileTarget);
                config.LoggingRules.Add(fileRule);
            }

            if (toEventLog)
            {
                EventLogTarget eventTarget = new EventLogTarget();
                config.AddTarget(EVENT_TARGET, eventTarget);

                LoggingRule eventRule = new LoggingRule("*", (withTrace ? LogLevel.Trace : LogLevel.Info), eventTarget);
                config.LoggingRules.Add(eventRule);
            }

            LogFactory factory = new LogFactory(config);
            return factory.GetLogger(applicationName);
        }

        public string LogPath
        {
            get
            {
                CheckInitialization();
                return _logfile;
            }
        }

        public void EnableTrace(bool enableTrace)
        {
            CheckInitialization();
            lock (_syncLock)
            {
                foreach (LoggingRule rule in _logger.Factory.Configuration.LoggingRules)
                {
                    if (enableTrace)
                    {
                        rule.EnableLoggingForLevel(LogLevel.Trace);
                    }
                    else
                    {
                        rule.DisableLoggingForLevel(LogLevel.Trace);
                    }
                }
                _logger.Factory.ReconfigExistingLoggers();
            }
        }

        public void ConfigureEventSending(string eventCollectorUrl)
        {
            _eventClient = (eventCollectorUrl != null) ? new EventClient(eventCollectorUrl, a => _logger.Trace(a), (a, b) => _logger.Error(b,a)) : null;
        }

        private void CheckInitialization()
        {
            if (_logger == null)
            {
                try
                {
                    string defaultName = DEFAULT_LOGNAME;
                    Logger logger = GetLogger(defaultName);
                    logger.Info(String.Format("Log attempt received when no logger exists; using default name {0} for log.", defaultName));
                }
                catch (Exception ex)
                {
                    InitializationFailure("Unable to Log.", ex);
                }
            }
        }

        public void Trace(string text)
        {
            CheckInitialization();
            _logger.Trace(text);
        }

        public void Info(string text)
        {
            CheckInitialization();
            _logger.Info(text);
        }

        public void Info(string text, Exception exception)
        {
            CheckInitialization();
            _logger.Info(exception, text);
        }

        public void Error(string text)
        {
            CheckInitialization();
            _logger.Error(text);
            Event(null, "General.Error", new { }, new { });
        }

        public void Error(string text, Exception exception)
        {
            CheckInitialization();
            _logger.Error(exception, text);
            Event(null, "General.Error", new { }, new { });
        }

        public void Event(string id, string type, object intData, object stringData)
        {
            CheckInitialization();

            try
            {
                if (_eventClient != null)
                {
                    _eventClient.AddEvent(id, type, intData ?? new { }, stringData ?? new { });
                }
            }
            catch (Exception ex)
            {
                _logger.Error(ex, String.Format("Unable to log event of type {0}: {1}", type, ex.Message));
            }
        }

        public void Finish()
        {
            if (_eventClient != null)
            {
                _eventClient.Stop();
            }
        }
    }
}
