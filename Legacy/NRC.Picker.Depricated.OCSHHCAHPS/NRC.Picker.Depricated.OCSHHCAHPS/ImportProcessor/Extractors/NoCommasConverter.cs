using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    /// <summary>
    /// Get the string value up to the first comma
    /// </summary>
    public class NoCommasConverter : ConverterBase
    {
        //old        private static Regex _regex = new Regex(@",+$");  // Removed by Eric Faust because this regular expression does not change the from string. 6/5/2011
        private static Regex _regex = new Regex(@",.[^.]+$");

        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from)) return null;

            from = from.Trim();
            string retVal = _regex.Replace(from, string.Empty);

            return retVal;
        }
    }
}
