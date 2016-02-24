using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRCFileConverterLibrary.Common
{
    /// <summary>
    /// EventArgs passed by log events.
    /// </summary>
    public class LogTraceArgs : EventArgs
    {
        public string Message { get; set; }
        public LogLevel LogLevel { get; set; }
    }
}