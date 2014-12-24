using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ServiceLogging
{

    /// <summary>
    /// Log levels used in NRC.
    /// </summary>
    public enum LogLevel
    {
        Debug,
        Error,
        Fatal,
        Info,
        Off,
        Trace,
        Warn
    }
}