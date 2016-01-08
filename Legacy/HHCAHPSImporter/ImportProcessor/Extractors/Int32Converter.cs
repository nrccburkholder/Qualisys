using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal class Int32Converter : ConverterBase
    {
        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from)) return null;

            from = from.Trim();

            int retval;
            if (int.TryParse(from, out retval))
            {
                return retval;
            }

            return null;
        }
    }
}
