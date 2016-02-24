using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.Common;

namespace NRCFileConverterLibrary.Extensions
{
    /// <summary>
    /// Exception to track Extension Exceptions.
    /// </summary>
    public class ExtensionException : NRCFileConversionException
    {
        public ExtensionException(string msg)
            : base(msg)
        {
        }
    }
}
