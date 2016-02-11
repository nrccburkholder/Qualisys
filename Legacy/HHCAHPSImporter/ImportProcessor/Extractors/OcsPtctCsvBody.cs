using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    [DelimitedRecord(",")]
    internal class OcsPtctCsvBody
    {
        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Patient_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string MedicalRecordNumber;

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
        public string Gender;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(DateConverter))]
        public string DOB;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Language;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(DateConverter))]
        public string SOC_Date;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? CurrentMonth_Skilled_Visits;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldOptional]
        [FieldConverter(typeof(Int32Converter))]
        public int? PriorMonth_Skilled_Visits;

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
        public string Deceased_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Hospice_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Maternity_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Branch_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string HH_Visit_Type;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Assessment_Reason;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        [FieldConverter(typeof(DateConverter))]
        public string Discharge_Date;

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
        [FieldOptional]
        public string Admission_UK;

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
        public string ICD_A3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_A4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_B2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_B3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_B4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_C2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_C3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_C4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_D2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_D3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_D4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_E2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_E3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_E4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_F2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_F3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldConverter(typeof(IcdConverter))]
        [FieldOptional]
        public string ICD_F4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Surgical_Discharge;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string ESRD;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Dialysis_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string Referral_Source;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string SN;

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
        public string[] ExtraColumns;
    }
}
