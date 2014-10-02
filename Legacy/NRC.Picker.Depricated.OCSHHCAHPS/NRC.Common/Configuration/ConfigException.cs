using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common.Configuration
{
    public class ConfigException : Exception
    {
        public ConfigException(string message) : base(message) { }
        public ConfigException(string message, Exception inner) : base(message, inner) { }
    }
}
