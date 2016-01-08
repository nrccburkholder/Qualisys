using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

using Generated = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Validation
{
    /// <summary>
    /// Always returns true.  Not sure how doable this is.
    /// </summary>
    public class TransformMappingAttribute : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            Generated.TransformMapping transformMapping = (Generated.TransformMapping)value;

            if (string.IsNullOrEmpty(value.ToString()))
            {
                return true;
            }

            try
            {
                // Utils.ValidatedCode(newTransformMapping);
                // NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Transforms.Factory.GetTransformProcessor(null).TestTransfrom(value.ToString());
                return true;
            }
            catch (Exception ex)
            {
                string msg = ex.Message;
                // TODO: Can this be used and the validation message?
            }

            return false;
        }


    }
}
