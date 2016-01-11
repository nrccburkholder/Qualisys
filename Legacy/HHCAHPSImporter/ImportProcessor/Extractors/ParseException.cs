using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public class ParseException : Exception
    {
        public ParseException() : base() { }

        public ParseException(string message) : base(message) { }

        public ParseException(string message, Exception innerException) : base(message, innerException) { }

        public ParseException(SerializationInfo info, StreamingContext context) : base(info, context) { }
    }
}
