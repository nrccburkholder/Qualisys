using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common
{
    /// <summary>
    /// This class is designed to hold a message that is safe to display to an end user (and is generally the result of 
    /// erroneous user behavior -- calling a web service with the wrong arguments, say).
    /// </summary>
    public class UserException: Exception
    {
        public UserException(string message) : base(message)
        {
        }

        public UserException(string message, Exception inner) : base(message, inner)
        {
        }
    }
}
