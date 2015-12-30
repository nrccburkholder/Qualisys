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
            return ExtractHelper.GetDateTimeFromString(from, false);
        }

        public override string FieldToString(object from)
        {
            if (from == null) return string.Empty;
            return ((DateTime)from).Date.ToString("MMddyyyy");
        }
    }
}
