using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel.DataAnnotations;

namespace HHCAHPSImporter.ImportProcessor.Validation
{
    [AttributeUsage(AttributeTargets.Class)] 
    public class EitherFieldRequiredAttribute : ValidationAttribute
    {
        public readonly string FirstProperty;     
        public readonly string SecondProperty;     
        public readonly string Message;

        public EitherFieldRequiredAttribute(string firstProperty, string secondProperty, string message)     
        {         
            FirstProperty = firstProperty;         
            SecondProperty = secondProperty;         
            Message = message;     
        } 

        public override bool IsValid(object value)
        {
            var p1 = value.GetType().GetProperty(FirstProperty);
            var p2 = value.GetType().GetProperty(SecondProperty);
            if (p1 == null )
            {
                throw new Exception( string.Format("could not find the specified propertie '{0}'", FirstProperty) );
            }
            if (p2 == null)
            {
                throw new Exception(string.Format("could not find the specified propertie '{0}'", SecondProperty));
            }

            object v1 = p1.GetValue(value, null);
            object v2 = p2.GetValue(value, null);

            if (v1 == null && v2 == null)
            {
                return false;
            }

            return true;
        }
    }
}
