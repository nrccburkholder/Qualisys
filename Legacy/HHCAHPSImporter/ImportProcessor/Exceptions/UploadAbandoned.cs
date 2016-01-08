using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Exceptions
{
    public class UploadAbandonedException : System.Exception
    {
        public UploadAbandonedException(string message)
            : base(message)
        {
        }

        public UploadAbandonedException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}
