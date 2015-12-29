using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    [DelimitedRecord(",")]
    internal class CmsCsvBody
    {
        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Branch_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Provider_Name;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(M0010Converter))]
        [FieldOptional]
        [FieldTrim(TrimMode.Both)]
        public string M0010;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string NPI;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(Int32Converter))]
        [FieldOptional]
        public int? Sample_Month;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(Int32Converter))]
        [FieldOptional]
        public int? Sample_Year;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? Total_Patients_Served;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? Total_in_File;

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
        public string Gender;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string DOB;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string SOC_Date;

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
        public string Patient_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public int? CurrentMonth_Skilled_Visits;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? Lookback_Skilled_Visits;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_NF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_SNF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_LTCH;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_IRF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_Other;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        public string Admission_NA;

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
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string HMO_Indicator;

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
        public string Surgical_Discharge;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ESRD;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(Int32Converter))]
        [FieldOptional]
        public int? ADL_Deficit_Count;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ADL_Upper;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ADL_Lower;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ADL_Bath;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ADL_Toilet;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ADL_Transfer;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ADL_Feed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Language;

        //[FieldQuoted('"', QuoteMode.OptionalForBoth)]
        //[FieldTrim(TrimMode.Both)]
        //[FieldOptional]
        //public string[] ExtraColumns;
    }
}
