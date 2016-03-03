using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.Common;

namespace NRCFileConverterLibrary.Factory
{
    /// <summary>
    /// Exception to track Factory Exception.
    /// </summary>
    public class FactoryException : NRCFileConversionException
    {
        public FactoryException(string message)
            : base(message)
        {
        }
    }
}
