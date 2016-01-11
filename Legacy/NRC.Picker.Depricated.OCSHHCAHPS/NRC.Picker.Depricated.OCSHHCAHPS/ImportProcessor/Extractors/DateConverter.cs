using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class DateConverter : ConverterBase
    {
        public override object StringToField(string from)
        {
            return ExtractHelper.ConvertDateFormat(from);
        }
    }
}
