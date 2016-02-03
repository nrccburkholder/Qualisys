using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CommonTools
{
    /// <summary>
    /// Summary description for clsLog.
    /// </summary>
    public class clsLog
    {
        public clsLog()
        {

        }

        public static void LogWarn(System.Type type, String msg, Exception ex)
        {
            //TODO:  IMplement
            //ILog log = LogManager.GetLogger(type);
            //if (log.IsWarnEnabled) log.Warn(msg, ex);
        }

        public static void LogError(System.Type type, String msg, Exception ex)
        {
            //TODO:  IMplement
            //ILog log = LogManager.GetLogger(type);
            //if (log.IsErrorEnabled) log.Error(msg, ex);
        }

    }
}