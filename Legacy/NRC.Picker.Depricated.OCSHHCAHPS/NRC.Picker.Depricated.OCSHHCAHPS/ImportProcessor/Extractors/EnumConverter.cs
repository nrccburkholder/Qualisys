using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    public class EnumConverter : ConverterBase
    {
        private Dictionary<string, string> _values = new Dictionary<string, string>();
        private const string DEFAULT = "DEFAULT";

        // note the first value is the default one, if they put in text but it doesn't match any of the given values
        public EnumConverter(string[] values)
        {
            for (int i = 0; i < values.Length; i++)
            {
                string key = values[i];
                string value = key;
                int ix = key.IndexOf(':');
                if (ix != -1)
                {
                    key = values[i].Substring(0, ix);
                    value = values[i].Substring(ix + 1);
                }
                _values[key.ToUpper()] = value;

                if (i == 0)
                {
                    _values[DEFAULT] = value;
                }
            }
        }

        public override object StringToField(string from)
        {
            if (string.IsNullOrEmpty(from))
            {
                return null;
            }

            from = from.Trim();
            from = from.ToUpper();

            if (_values.ContainsKey(from))
            {
                return _values[from];
            }
            else
            {
                return _values[DEFAULT];
            }
        }
    }
}
