using FileHelpers;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class CompactDateConverter : ConverterBase
    {
        public override object StringToField(string from)
        {
            return GetDateTimeFromString(from, false);
        }

        public override string FieldToString(object from)
        {
            if (from == null) return string.Empty;

            return ((DateTime)from).Date.ToString("MMddyyyy");
        }

        public static DateTime? GetDateTimeFromString(string value, bool preferYYYYMMDD)
        {
            value = String.IsNullOrEmpty(value) ? "" : value.Trim();
            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            if (value.IndexOf('/') != -1)
            {
                try
                {
                    return DateTime.Parse(value);
                }
                catch (Exception)
                {
                    return null;
                }
            }

            // either MMDDYYYY, or YYYYMMDD
            IEnumerable<string> formats = new string[] { "MMddyyyy", "yyyyMMdd" };
            if (preferYYYYMMDD)
            {
                formats = formats.Reverse<string>();
            }

            foreach (string fmt in formats)
            {
                string v = value;
                if (v.Length == fmt.Length - 1 && fmt.StartsWith("MM"))
                {
                    v = "0" + v;
                }
                else if (v.Length != fmt.Length) // unfixable, no good
                {
                    continue;
                }

                try
                {
                    DateTime d = DateTime.ParseExact(v, fmt, CultureInfo.CurrentCulture);
                    if (d.Year > 1799)
                    {
                        return d;
                    }
                }
                catch (Exception)
                {
                }
            }

            return null;
        }
    }
}
