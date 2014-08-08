using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Validation
{
    public class LibraryCodeAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            if (string.IsNullOrEmpty(value.ToString()))
            {
                return true;
            }

            try
            {
                NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.Factory.GetTransformProcessor(null).TestLibrary(value.ToString());
                return true;
            }
            catch(Exception ex) 
            {
                string msg = ex.Message;
                // TODO: Can this be used and the validation message?
            }

            return false;
        }
    }
}
