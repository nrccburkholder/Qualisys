using FileHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    [FixedLengthRecord(FixedMode.ExactLength)]
    internal class OcsFwBodyV1
    {
        [FieldFixedLength(10)]
        [FieldTrim(TrimMode.Both)]
        public string Branch_ID;

        [FieldFixedLength(20)]
        [FieldTrim(TrimMode.Both)]
        public string Patient_ID;

        [FieldFixedLength(20)]
        [FieldTrim(TrimMode.Both)]
        public string MedicalRecordNumber;

        [FieldFixedLength(30)]
        [FieldTrim(TrimMode.Both)]
        public string First_Name;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Middle_Initial;

        [FieldFixedLength(30)]
        [FieldTrim(TrimMode.Both)]
        public string Last_Name;

        [FieldFixedLength(50)]
        [FieldTrim(TrimMode.Both)]
        public string Address1;

        [FieldFixedLength(50)]
        [FieldTrim(TrimMode.Both)]
        public string Address2;

        [FieldFixedLength(50)]
        [FieldTrim(TrimMode.Both)]
        public string City;

        [FieldFixedLength(2)]
        [FieldTrim(TrimMode.Both)]
        public string State;

        [FieldFixedLength(9)]
        [FieldTrim(TrimMode.Both)]
        public string ZipCode;

        [FieldFixedLength(10)]
        [FieldTrim(TrimMode.Both)]
        [FieldConverter(typeof(PhoneNumberConverter))]
        public string Telephone;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Gender;

        [FieldFixedLength(8)]
        [FieldTrim(TrimMode.Both)]
        [FieldConverter(typeof(DateConverter))]
        public string DOB;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Language;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string HH_Visit_Type;

        [FieldFixedLength(8)]
        [FieldTrim(TrimMode.Both)]
        [FieldConverter(typeof(DateConverter))]
        public string SOC_Date;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Assessment_Reason;

        [FieldFixedLength(8)]
        [FieldTrim(TrimMode.Both)]
        [FieldConverter(typeof(DateConverter))]
        public string Discharge_Date;

        [FieldFixedLength(3)]
        [FieldConverter(typeof(Int32Converter))]
        public int? CurrentMonth_Skilled_Visits;

        [FieldFixedLength(3)]
        [FieldConverter(typeof(Int32Converter))]
        public int? PriorMonth_Skilled_Visits;

        [FieldFixedLength(1)]
        public string Admission_NF;

        [FieldFixedLength(1)]
        public string Admission_SNF;

        [FieldFixedLength(1)]
        public string Admission_IPPS;

        [FieldFixedLength(1)]
        public string Admission_LTCH;

        [FieldFixedLength(1)]
        public string Admission_IRF;

        [FieldFixedLength(1)]
        public string Admission_Pysch;

        [FieldFixedLength(1)]
        public string Admission_Other;

        [FieldFixedLength(1)]
        public string Admission_NA;

        [FieldFixedLength(1)]
        public string Admission_UK;

        [FieldFixedLength(1)]
        public string Payer_None;

        [FieldFixedLength(1)]
        public string Payer_MedicareFFS;

        [FieldFixedLength(1)]
        public string Payer_MedicareHMO;

        [FieldFixedLength(1)]
        public string Payer_MedicaidFFS;

        [FieldFixedLength(1)]
        public string Payer_MedicaidHMO;

        [FieldFixedLength(1)]
        public string Payer_WkersComp;

        [FieldFixedLength(1)]
        public string Payer_Title;

        [FieldFixedLength(1)]
        public string Payer_OtherGov;

        [FieldFixedLength(1)]
        public string Payer_Private;

        [FieldFixedLength(1)]
        public string Payer_PrivateHMO;

        [FieldFixedLength(1)]
        public string Payer_Self;

        [FieldFixedLength(1)]
        public string Payer_Other;

        [FieldFixedLength(1)]
        public string Payer_UK;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string HMO_Indicator;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Dual_eligible;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_A2;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_A3;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_A4;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_B2;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_B3;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_B4;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_C2;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_C3;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_C4;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_D2;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_D3;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_D4;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_E2;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_E3;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_E4;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_F2;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_F3;

        [FieldFixedLength(6)]
        [FieldConverter(typeof(IcdConverter))]
        public string ICD_F4;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Surgical_Discharge;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ESRD;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Dialysis_Indicator;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Referral_Source;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string SN;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string PT;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string HHA;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Social_Service;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string OT;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Comp_Hmkr;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ST;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ADL_Upper;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ADL_Lower;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ADL_Bath;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ADL_Toilet;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ADL_Transfer;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string ADL_Feed;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Deceased_Indicator;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Hospice_Indicator;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string Maternity_Indicator;

        [FieldFixedLength(1)]
        [FieldTrim(TrimMode.Both)]
        public string RecordTerminatingCharacter;
    }
}