using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class PhoneNumberConverter : ConverterBase
    {
        private static Regex _regex = new Regex("[^0-9]");

        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from)) return null;

            string retVal = _regex.Replace(from, "");

            return retVal;
        }
    }
}
