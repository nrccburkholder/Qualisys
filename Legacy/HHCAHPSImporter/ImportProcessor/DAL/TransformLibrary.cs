using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using HHCAHPSImporter.ImportProcessor.Validation;

namespace HHCAHPSImporter.ImportProcessor.DAL.Generated
{
    [MetadataType(typeof(TransformLibrary_Validation))]
    public partial class TransformLibrary
    {
        public void ValidatedCode()
        {
            if (string.IsNullOrEmpty(this.Code))
            {
                return;
            }

            HHCAHPSImporter.ImportProcessor.Transforms.Factory.GetTransformProcessor(null).TestLibrary(this.Code);
        }
    }

    public class TransformLibrary_Validation
    {
        [Required(ErrorMessage = "Required")]
        [StringLength(50, ErrorMessage = "Must be under 50 characters")]
        public string TransformLibraryName { get; set; }

        [Required(ErrorMessage = "Required")]
        [LibraryCode(ErrorMessage="Invalid Code")]
        [StringLength(5000, ErrorMessage = "Must be under 5000 characters")]
        public string Code { get; set; }
    }
}