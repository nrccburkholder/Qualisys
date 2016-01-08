using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Exceptions
{
    public class InvalidArgumentException : System.Exception
    {
        public InvalidArgumentException(string message)
            : base(message)
        {
        }

        public InvalidArgumentException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}
