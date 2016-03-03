using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NLog;

namespace NRCFileConverterLibrary.Extensions
{
    public static class LogLevelExtension
    {
       /// <summary>
       /// Extension methode to translate NRC-LogLevels to NLog-Logelevels
       /// </summary>
       /// <param name="level"></param>
       /// <returns></returns>
        public static LogLevel ToNLogLogLevel(this NRCFileConverterLibrary.Common.LogLevel level)
        {
            NLog.LogLevel nloglevel = null;
            switch (level)
            {
                case NRCFileConverterLibrary.Common.LogLevel.Debug:
                    nloglevel = NLog.LogLevel.Debug;
                    break;
                case NRCFileConverterLibrary.Common.LogLevel.Error:
                    nloglevel = NLog.LogLevel.Error;
                    break;
                case NRCFileConverterLibrary.Common.LogLevel.Fatal:
                    nloglevel = NLog.LogLevel.Fatal;
                    break;
                case NRCFileConverterLibrary.Common.LogLevel.Info:
                    nloglevel = NLog.LogLevel.Info;
                    break;
                case NRCFileConverterLibrary.Common.LogLevel.Off:
                    nloglevel = NLog.LogLevel.Off;
                    break;
                case NRCFileConverterLibrary.Common.LogLevel.Trace:
                    nloglevel = NLog.LogLevel.Trace;
                    break;
                case NRCFileConverterLibrary.Common.LogLevel.Warn:
                    nloglevel = NLog.LogLevel.Warn;
                    break;
                default:
                    throw new ExtensionException("Invalid LogLevel");
            }
            return nloglevel;
        }
    }
}
