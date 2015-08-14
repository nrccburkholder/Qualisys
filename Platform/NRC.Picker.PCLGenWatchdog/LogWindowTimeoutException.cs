using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.PCLGenWatchdog
{
    public class LogWindowTimeoutException : Exception
    {
        public LogWindowTimeoutException()
            : base()
        {
        }

        public LogWindowTimeoutException(string message)
            : base(message)
        {
        }
    }
}
