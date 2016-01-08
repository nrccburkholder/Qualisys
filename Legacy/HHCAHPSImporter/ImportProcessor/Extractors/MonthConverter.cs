using FileHelpers;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public class MonthConverter : ConverterBase
    {
        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from)) return null;

            from = from.Trim();
            from = from.ToLower();

            int retval;

            for (int i = 0; i < DateTimeFormatInfo.CurrentInfo.MonthNames.Length; i++)
            {
                if (from.Equals(DateTimeFormatInfo.CurrentInfo.MonthNames[i].ToLower()))
                {
                    return i + 1; // january is 1, etc
                }
            }

            if (int.TryParse(from, out retval))
            {
                return retval;
            }

            return null;
        }
    }
}
