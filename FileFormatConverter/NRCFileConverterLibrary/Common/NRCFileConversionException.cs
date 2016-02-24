using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRCFileConverterLibrary.Common
{
    /// <summary>
    /// To track NRCFileConversion Exception
    /// </summary>
    public class NRCFileConversionException : Exception
    {
        public NRCFileConversionException(string msg)
            : base(msg)
        {
        }
    }
}
