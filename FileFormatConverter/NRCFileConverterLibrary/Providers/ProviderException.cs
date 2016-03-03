using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.Common;

namespace NRCFileConverterLibrary.Providers
{
    /// <summary>
    /// This exception is used to track Provider Exceptions.
    /// </summary>
    public class ProviderException : NRCFileConversionException
    {
       public ProviderException(string msg): base(msg) {}
    }
}
