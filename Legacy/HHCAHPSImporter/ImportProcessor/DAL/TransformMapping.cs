using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Validation;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated
{
    [MetadataType(typeof(TransformMapping_Validation))]
    [TransformMapping()]
    [EitherFieldRequired("SourceFieldName", "Transform", "Either SourceFiledName or Transform are required")]
    public partial class TransformMapping
    {
        public int? TransformId
        {
            get
            {
                this.TransformTarget.TransformDefinition.Load();
                if (this.TransformTarget.TransformDefinition.FirstOrDefault() == null)
                {
                    return null;// this.TransformTarget.TransformDefinition.FirstOrDefault().TransformId;
                }
                return this.TransformTarget.TransformDefinition.FirstOrDefault().TransformId;
            }
        }
    }

    public class TransformMapping_Validation
    {
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string SourceFieldName { get; set; }

        [Required(ErrorMessage = "Required")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string TargetFieldname { get; set; }

        [StringLength(5000, ErrorMessage = "Must be under 5000 characters")]
        public string Transform { get; set; }
    }

}