using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class BitConverter : ConverterBase
    {
        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from)) return null;

            from = from.Trim();

            if (from.Equals("0"))
            {
                return false;
            }
            else if (from.Equals("1"))
            {
                return true;
            }
            else
            {
                return null;
            }
        }

        public override string FieldToString(object from)
        {
            if (from == null)
            {
                return string.Empty;
            }

            return ((bool)from) ? "1" : "0";
        }
    }
}
