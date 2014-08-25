using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated
{
    [MetadataType(typeof(Transform_Validation))]
    public partial class Transform
    {
    }

    public class Transform_Validation
    {
        [Required(ErrorMessage = "Transform Name Required")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string TransformName { get; set; }
    }
}