using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    [DelimitedRecord(",")]
    internal class PgCsvBody
    {
        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string SurveyDesignator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        [FieldConverter(typeof(M0010Converter))]
        public string ClientNumber;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string First_Name;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Middle_Initial;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Last_Name;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Address1;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Address2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string City;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string State;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ZipCode;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(PhoneNumberConverter))]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Telephone;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string HH_Visit_Type;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string SOC_Date;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Assessment_Reason;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Discharge_Date;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string DOB;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0:1", "1:2", "10:3", "3:4", "13:5" } })]
        public string Language;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Gender;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Patient_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Surgical_Discharge;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ESRD;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_None;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_MedicareFFS;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_MedicareHMO;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_MedicaidFFS;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_MedicaidHMO;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_WkersComp;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_Title;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_OtherGov;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_Private;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_PrivateHMO;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_Self;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_Other;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Payer_UK;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string HMO_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_NF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_SNF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_IPPS;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_LTCH;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_IRF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_Pysch;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_Other;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_NA;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Dual_eligible;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_A2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_B2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_C2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_D2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_E2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_F2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Referral_Source;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string PT;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string HHA;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Social_Service;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string OT;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Comp_Hmkr;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ST;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        // this is more values than PG allows, but it seems better not to limit ourselves in the code
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" } })]
        public string ADL_Upper;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        // this is more values than PG allows, but it seems better not to limit ourselves in the code
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" } })]
        public string ADL_Lower;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        // this is more values than PG allows, but it seems better not to limit ourselves in the code
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" } })]
        public string ADL_Bath;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        // this is more values than PG allows, but it seems better not to limit ourselves in the code
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" } })]
        public string ADL_Toilet;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        // this is more values than PG allows, but it seems better not to limit ourselves in the code
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" } })]
        public string ADL_Transfer;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        // this is more values than PG allows, but it seems better not to limit ourselves in the code
        [FieldConverter(typeof(EnumConverter), new object[] { new string[] { "UK:M", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" } })]
        public string ADL_Feed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? CurrentMonth_Skilled_Visits;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? LastTwoMonths_Skilled_Visits;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? SampleMonth;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? SampleYear;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Branch_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Team_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? TotalNumberOfPatientsServed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string EndOfRecordCharacter;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string[] ExtraColumns;
    }
}
