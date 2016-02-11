using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using HHCAHPSImporter.ImportProcessor.Validation;

namespace HHCAHPSImporter.ImportProcessor.DAL.Generated
{
    [MetadataType(typeof(TransformTarget_Validation))]
    public partial class TransformTarget
    {
        public int? TransformId
        {
            get
            {
                this.TransformDefinition.Load();
                if (this.TransformDefinition.FirstOrDefault() == null)
                {
                    return null;
                }
                return this.TransformDefinition.FirstOrDefault().TransformId;
            }
        }
    }

    public class TransformTarget_Validation
    {
        [Required(ErrorMessage = "Required")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string TargetName { get; set; }

        [Required(ErrorMessage = "Required")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        [TableName()]
        public string TargetTable { get; set; }
    }
}