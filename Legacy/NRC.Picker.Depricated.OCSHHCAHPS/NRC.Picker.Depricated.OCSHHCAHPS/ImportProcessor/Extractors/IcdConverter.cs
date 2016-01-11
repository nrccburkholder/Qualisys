using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal class IcdConverter : ConverterBase
    {
        /*
         Input codes are interpreted as follows (they may also have leading/trailing whitespace, which is trimmed):
          
         INPUT HAS A DECIMAL POINT:
         - Before the decimal point can be either "V" followed by 1-2 digits, or 1-3 digits
         - After the decimal point can be 0-2 digits
         
         INPUT HAS NO DECIMAL POINT:
         - Input must be 5 digits, or "V" followed by 4 digits
         - A decimal point is inserted after the first three characters
         
         Strings not matching these rules are rejected (not the line, just the individual value).
          
         On output, the code is padded with an initial space, and then trailing spaces to make the overall length 7 characters. 
         (The code seems to be doing 8 characters, which I think is wrong, but I don't want to break things by "fixing" it.)
        */
        private static readonly Regex _withDecimalRegex = new Regex(@"^[V0-9][0-9]{0,2}\.[0-9]{0,2}$");
        private static readonly Regex _withoutDecimalRegex = new Regex(@"^[V0-9][0-9]{4}$");
        private static readonly Regex _ICD10WithDecimalRegex = new Regex(@"^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$");
        private static readonly Regex _ICD10WithoutDecimalRegex = new Regex(@"^[A-TV-Z][0-9][A-Z0-9]([A-Z0-9]{1,4})?$");

        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from)) return null;

            from = from.Trim();
            from = from.ToUpper();

            if (_withDecimalRegex.Match(from).Success || _ICD10WithDecimalRegex.Match(from).Success)
            {
                ; // everything's fine
            }
            else if (_withoutDecimalRegex.Match(from).Success || _ICD10WithoutDecimalRegex.Match(from).Success)
            {
                from = from.Substring(0, 3) + "." + from.Substring(3, from.Length - 3);
            }
            else
            {
                return null;
            }

            return from;
        }

        public override string FieldToString(object from)
        {
            if (from == null) return string.Empty;

            string code = (string)from;
            code = " " + code;
            while (code.Length < 8)
            {
                code += " ";
            }

            return code;
        }
    }
}
