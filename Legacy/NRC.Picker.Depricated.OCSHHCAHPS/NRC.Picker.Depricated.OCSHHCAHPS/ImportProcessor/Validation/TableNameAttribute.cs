using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Validation
{
    class TableNameAttribute :  ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            Regex r = new Regex(@"^[a-z]\w*$", RegexOptions.IgnoreCase);
            if( r.IsMatch(value.ToString()) )
            {
                return true;
            }
            return false;
        }
    }
}
