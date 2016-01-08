using FileHelpers;
using FileHelpers.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    [DelimitedRecord(",")]
    internal class OcsPtctCsvHeader
    {
        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(MonthConverter))]
        public int? SampleMonth;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? SampleYear;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(M0010Converter))]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ProviderID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ProviderName;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string NPI;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(Int32Converter))]
        [FieldOptional]
        public int? TotalNumberOfPatientsServed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? NumberOfBranchesServed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string VersionNumber;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string[] ExtraColumns;
    }
}
