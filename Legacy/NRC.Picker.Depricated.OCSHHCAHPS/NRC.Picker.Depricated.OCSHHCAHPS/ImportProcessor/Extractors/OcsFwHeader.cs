using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    [FixedLengthRecord(FixedMode.AllowVariableLength)]
    internal class OcsFwHeader
    {
        [FieldFixedLength(2)]
        [FieldConverter(typeof(Int32Converter))]
        public int? SampleMonth;

        [FieldFixedLength(4)]
        [FieldConverter(typeof(Int32Converter))]
        public int? SampleYear;

        [FieldFixedLength(6)]
        [FieldTrim(TrimMode.Both)]
        [FieldConverter(typeof(M0010Converter))]
        public string ProviderID;

        [FieldFixedLength(100)]
        [FieldTrim(TrimMode.Both)]
        public string ProviderName;

        [FieldFixedLength(20)]
        [FieldTrim(TrimMode.Both)]
        public string NPI;

        [FieldFixedLength(4)]
        [FieldConverter(typeof(Int32Converter))]
        public int? TotalNumberOfPatientsServed;

        [FieldFixedLength(3)]
        [FieldConverter(typeof(Int32Converter))]
        public int? NumberOfBranchesServed;

        [FieldFixedLength(4)]
        [FieldTrim(TrimMode.Both)]
        public string VersionNumber;
    }
}
