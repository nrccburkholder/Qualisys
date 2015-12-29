using FileHelpers;
using FileHelpers.Events;
using FileHelpers.MasterDetail;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal static class OcsCsvParser
    {
        public static XDocument Parse(ClientDetail client, string fileName, string fileContents)
        {
            var xml = ExtractHelper.CreateEmptyDocument();

            var engine = new MasterDetailEngine<OcsCsvHeader, OcsCsvBody>(new MasterDetailSelector(RecordSelector));
            var result = engine.ReadString(ExtractHelper.AddTrailingCommas(fileContents));

            if (result.Length == 0) throw new InvalidOperationException("No header found in file.");
            if (result.Length > 1) throw new InvalidOperationException("More than one header found in file.");

            ParseHeader(xml, result[0].Master);
            ParseBody(xml, result[0].Details);

            xml.Root.Add(ExtractHelper.CreateRootAttributes(client, fileName));

            return xml;
        }

        private static RecordAction RecordSelector(string record)
        {
            if (record.Length < 2 || record.StartsWith("Sample") || record.StartsWith("PatientCode"))
                return RecordAction.Skip;

            var columnsWithData = ColumnsWithData(record);

            if (columnsWithData == 0)
                return RecordAction.Skip;
            else if (columnsWithData <= 8)
                return RecordAction.Master;
            else
                return RecordAction.Detail;
        }

        private static int ColumnsWithData(string record)
        {
            return record.Split(',').Where(value => !string.IsNullOrWhiteSpace(value)).Count();
        }

        private static void ParseHeader(XDocument xml, OcsCsvHeader header)
        {
            var metadata = ExtractHelper.GetMetadataElement(xml);

            metadata.Add(
                ExtractHelper.CreateTransformRow(1,
                    ExtractHelper.CreateFieldElement("MONTH", header.SampleMonth),
                    ExtractHelper.CreateFieldElement("YEAR", header.SampleYear),
                    ExtractHelper.CreateFieldElement("PROVIDER ID", header.ProviderID),
                    ExtractHelper.CreateFieldElement("PROVIDER NAME", header.ProviderName),
                    ExtractHelper.CreateFieldElement("TOTAL NUMBER OF PATIENT SERVED", header.TotalNumberOfPatientsServed),
                    ExtractHelper.CreateFieldElement("NUMBER OF BRANCHES", header.NumberOfBranchesServed),
                    ExtractHelper.CreateFieldElement("VERSION NUMBER", header.VersionNumber)
                    ));
        }

        private static void ParseBody(XDocument xml, IEnumerable<OcsCsvBody> records)
        {
            var rows = ExtractHelper.GetRowsElement(xml);
            int rowCount = 0;
            foreach (var body in records)
            {
                rowCount++;

                rows.Add(
                    ExtractHelper.CreateTransformRow(rowCount,
                        ExtractHelper.CreateFieldElement("Patient ID", body.Patient_ID),
                        ExtractHelper.CreateFieldElement("Medical Record Number", body.MedicalRecordNumber),
                        ExtractHelper.CreateFieldElement("Patient First Name", body.First_Name),
                        ExtractHelper.CreateFieldElement("Patient Middle Initial", body.Middle_Initial),
                        ExtractHelper.CreateFieldElement("Patient Last Name", body.Last_Name),
                        ExtractHelper.CreateFieldElement("Patient Mailing Address 1", body.Address1),
                        ExtractHelper.CreateFieldElement("Patient Mailing Address 2", body.Address2),
                        ExtractHelper.CreateFieldElement("Patient Address City", body.City),
                        ExtractHelper.CreateFieldElement("Patient Address State", body.State),
                        ExtractHelper.CreateFieldElement("Patient Address Zip Code", body.ZipCode),
                        ExtractHelper.CreateFieldElement("Telephone Number including area code", body.Telephone),
                        ExtractHelper.CreateFieldElement("Gender", body.Gender),
                        ExtractHelper.CreateFieldElement("Patient Date of Birth", body.DOB),
                        ExtractHelper.CreateFieldElement("Language", body.Language),
                        ExtractHelper.CreateFieldElement("Start of Care Date", body.SOC_Date),
                        ExtractHelper.CreateFieldElement("Number of skilled visits", body.CurrentMonth_Skilled_Visits),
                        ExtractHelper.CreateFieldElement("Lookback Period Visits", body.PriorMonth_Skilled_Visits),
                        ExtractHelper.CreateFieldElement("Payer - None", body.Payer_None),
                        ExtractHelper.CreateFieldElement("Payer - Medicare FFS", body.Payer_MedicareFFS),
                        ExtractHelper.CreateFieldElement("Payer - Medicare HMO", body.Payer_MedicareHMO),
                        ExtractHelper.CreateFieldElement("Payer - Medicaid FFS", body.Payer_MedicaidFFS),
                        ExtractHelper.CreateFieldElement("Payer - Medicaid HMO", body.Payer_MedicaidHMO),
                        ExtractHelper.CreateFieldElement("Payer - Workers Comp", body.Payer_WkersComp),
                        ExtractHelper.CreateFieldElement("Payer - Title programs", body.Payer_Title),
                        ExtractHelper.CreateFieldElement("Payer - Other Government", body.Payer_OtherGov),
                        ExtractHelper.CreateFieldElement("Payer - Private Ins", body.Payer_Private),
                        ExtractHelper.CreateFieldElement("Payer - Private HMO", body.Payer_PrivateHMO),
                        ExtractHelper.CreateFieldElement("Payer - Self-pay", body.Payer_Self),
                        ExtractHelper.CreateFieldElement("Payer - Other", body.Payer_Other),
                        ExtractHelper.CreateFieldElement("Payer - Unknown", body.Payer_UK),
                        ExtractHelper.CreateFieldElement("Deceased Indicator", body.Deceased_Indicator),
                        ExtractHelper.CreateFieldElement("Hospice Indicator", body.Hospice_Indicator),
                        ExtractHelper.CreateFieldElement("Maternity Care Only Indicator", body.Maternity_Indicator),
                        ExtractHelper.CreateFieldElement("Branch ID", body.Branch_ID),
                        ExtractHelper.CreateFieldElement("Home Health Visit Type", body.HH_Visit_Type),
                        ExtractHelper.CreateFieldElement("Assessment Reason", body.Assessment_Reason),
                        ExtractHelper.CreateFieldElement("Discharge Date", body.Discharge_Date),
                        ExtractHelper.CreateFieldElement("Admission Source - NF", body.Admission_NF),
                        ExtractHelper.CreateFieldElement("Admission Source - SNF", body.Admission_SNF),
                        ExtractHelper.CreateFieldElement("Admission Source - IPP S", body.Admission_IPPS),
                        ExtractHelper.CreateFieldElement("Admission Source - LTCH", body.Admission_LTCH),
                        ExtractHelper.CreateFieldElement("Admission Source - IRF", body.Admission_IRF),
                        ExtractHelper.CreateFieldElement("Admission Source - Pysch", body.Admission_Pysch),
                        ExtractHelper.CreateFieldElement("Admission Source - Other", body.Admission_Other),
                        ExtractHelper.CreateFieldElement("Admission Source - NA (Community)", body.Admission_NA),
                        ExtractHelper.CreateFieldElement("Admission Source - Unknown", body.Admission_UK),
                        ExtractHelper.CreateFieldElement("HMO Indicator", body.HMO_Indicator),
                        ExtractHelper.CreateFieldElement("Dually eligible for Medicare and Medicaid?", body.Dual_eligible),
                        ExtractHelper.CreateFieldElement("Primary Diagnosis ICD_A2", body.ICD_A2),
                        ExtractHelper.CreateFieldElement("Primary Payment Diagnosis ICD_A3", body.ICD_A3),
                        ExtractHelper.CreateFieldElement("Primary Payment Diagnosis ICD_A4", body.ICD_A4),
                        ExtractHelper.CreateFieldElement("Other diagnosis_B2", body.ICD_B2),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_B3", body.ICD_B3),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_B4", body.ICD_B4),
                        ExtractHelper.CreateFieldElement("Other diagnosis_C2", body.ICD_C2),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_C3", body.ICD_C3),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_C4", body.ICD_C4),
                        ExtractHelper.CreateFieldElement("Other diagnosis_D2", body.ICD_D2),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_D3", body.ICD_D3),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_D4", body.ICD_D4),
                        ExtractHelper.CreateFieldElement("Other diagnosis_E2", body.ICD_E2),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_E3", body.ICD_E3),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_E4", body.ICD_E4),
                        ExtractHelper.CreateFieldElement("Other diagnosis_F2", body.ICD_F2),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_F3", body.ICD_F3),
                        ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_F4", body.ICD_F4),
                        ExtractHelper.CreateFieldElement("Surgical Discharge", body.Surgical_Discharge),
                        ExtractHelper.CreateFieldElement("End-Stage Renal Disease (ESRD)", body.ESRD),
                        ExtractHelper.CreateFieldElement("Dialysis Indicator", body.Dialysis_Indicator),
                        ExtractHelper.CreateFieldElement("Referral Source", body.Referral_Source),
                        ExtractHelper.CreateFieldElement("Skilled Nursing", body.SN),
                        ExtractHelper.CreateFieldElement("Physical Therapy", body.PT),
                        ExtractHelper.CreateFieldElement("Home Health Aide", body.HHA),
                        ExtractHelper.CreateFieldElement("Social Service", body.Social_Service),
                        ExtractHelper.CreateFieldElement("Occupational Therapy", body.OT),
                        ExtractHelper.CreateFieldElement("Companion/Homemaker", body.Comp_Hmkr),
                        ExtractHelper.CreateFieldElement("Speech Therapy", body.ST),
                        ExtractHelper.CreateFieldElement("ADL_Dress Upper", body.ADL_Upper),
                        ExtractHelper.CreateFieldElement("ADL_Dress Lower", body.ADL_Lower),
                        ExtractHelper.CreateFieldElement("ADL_Bathing", body.ADL_Bath),
                        ExtractHelper.CreateFieldElement("ADL_Toileting", body.ADL_Toilet),
                        ExtractHelper.CreateFieldElement("ADL_Transferring", body.ADL_Transfer),
                        ExtractHelper.CreateFieldElement("ADL_Feed", body.ADL_Feed)
                        ));
            }
        }
    }
}
