using FileHelpers;
using FileHelpers.Events;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal static class CmsCsvParser
    {
        public static XDocument Parse(ClientDetail client, string fileName, string fileContents)
        {
            var xml = ExtractHelper.CreateEmptyDocument();

            var engine = new FileHelpers.FileHelperAsyncEngine<CmsCsvBody>();
            engine.BeforeReadRecord += Engine_BeforeReadRecord;

            using (engine.BeginReadString(fileContents))
            {
                var metadata = ExtractHelper.GetMetadataElement(xml);
                var rows = ExtractHelper.GetRowsElement(xml);
                var firstRecord = true;
                var rowCount = 0;

                foreach (var body in engine)
                {
                    if (firstRecord)
                        metadata.Add(
                            ExtractHelper.CreateTransformRow(1,
                                ExtractHelper.CreateFieldElement("MONTH", body.Sample_Month),
                                ExtractHelper.CreateFieldElement("YEAR", body.Sample_Year),
                                ExtractHelper.CreateFieldElement("PROVIDER ID", body.M0010),
                                ExtractHelper.CreateFieldElement("PROVIDER NAME", body.Provider_Name),
                                ExtractHelper.CreateFieldElement("TOTAL NUMBER OF PATIENT SERVED", body.Total_Patients_Served),
                                ExtractHelper.CreateFieldElement("NUMBER OF BRANCHES", ""),
                                ExtractHelper.CreateFieldElement("VERSION NUMBER", "")
                                ));

                    firstRecord = false;

                    rowCount++;

                    rows.Add(
                        ExtractHelper.CreateTransformRow(rowCount,
                            ExtractHelper.CreateFieldElement("Patient ID", body.Patient_ID),
                            ExtractHelper.CreateFieldElement("Medical Record Number", body.Patient_ID),
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
                            ExtractHelper.CreateFieldElement("Lookback Period Visits", body.Lookback_Skilled_Visits),
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
                            ExtractHelper.CreateFieldElement("Deceased Indicator", ""),
                            ExtractHelper.CreateFieldElement("Hospice Indicator", ""),
                            ExtractHelper.CreateFieldElement("Maternity Care Only Indicator", ""),
                            ExtractHelper.CreateFieldElement("Branch ID", body.Branch_ID),
                            ExtractHelper.CreateFieldElement("Home Health Visit Type", ""),
                            ExtractHelper.CreateFieldElement("Assessment Reason", ""),
                            ExtractHelper.CreateFieldElement("Discharge Date", ""),
                            ExtractHelper.CreateFieldElement("Admission Source - NF", body.Admission_NF),
                            ExtractHelper.CreateFieldElement("Admission Source - SNF", body.Admission_SNF),
                            ExtractHelper.CreateFieldElement("Admission Source - IPP S", ""),
                            ExtractHelper.CreateFieldElement("Admission Source - LTCH", body.Admission_LTCH),
                            ExtractHelper.CreateFieldElement("Admission Source - IRF", body.Admission_IRF),
                            ExtractHelper.CreateFieldElement("Admission Source - Pysch", ""),
                            ExtractHelper.CreateFieldElement("Admission Source - Other", body.Admission_Other),
                            ExtractHelper.CreateFieldElement("Admission Source - NA (Community)", body.Admission_NA),
                            ExtractHelper.CreateFieldElement("Admission Source - Unknown", ""),
                            ExtractHelper.CreateFieldElement("HMO Indicator", body.HMO_Indicator),
                            ExtractHelper.CreateFieldElement("Dually eligible for Medicare and Medicaid?", body.Dual_eligible),
                            ExtractHelper.CreateFieldElement("Primary Diagnosis ICD_A2", body.ICD_A2),
                            ExtractHelper.CreateFieldElement("Primary Payment Diagnosis ICD_A3", ""),
                            ExtractHelper.CreateFieldElement("Primary Payment Diagnosis ICD_A4", ""),
                            ExtractHelper.CreateFieldElement("Other diagnosis_B2", body.ICD_B2),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_B3", ""),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_B4", ""),
                            ExtractHelper.CreateFieldElement("Other diagnosis_C2", body.ICD_C2),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_C3", ""),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_C4", ""),
                            ExtractHelper.CreateFieldElement("Other diagnosis_D2", body.ICD_D2),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_D3", ""),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_D4", ""),
                            ExtractHelper.CreateFieldElement("Other diagnosis_E2", body.ICD_E2),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_E3", ""),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_E4", ""),
                            ExtractHelper.CreateFieldElement("Other diagnosis_F2", body.ICD_F2),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis  ICD_F3", ""),
                            ExtractHelper.CreateFieldElement("Other Payment Diagnosis ICD_F4", ""),
                            ExtractHelper.CreateFieldElement("Surgical Discharge", body.Surgical_Discharge),
                            ExtractHelper.CreateFieldElement("End-Stage Renal Disease (ESRD)", body.ESRD),
                            ExtractHelper.CreateFieldElement("Dialysis Indicator", ""),
                            ExtractHelper.CreateFieldElement("Referral Source", ""),
                            ExtractHelper.CreateFieldElement("Skilled Nursing", ""),
                            ExtractHelper.CreateFieldElement("Physical Therapy", ""),
                            ExtractHelper.CreateFieldElement("Home Health Aide", ""),
                            ExtractHelper.CreateFieldElement("Social Service", ""),
                            ExtractHelper.CreateFieldElement("Occupational Therapy", ""),
                            ExtractHelper.CreateFieldElement("Companion/Homemaker", ""),
                            ExtractHelper.CreateFieldElement("Speech Therapy", ""),
                            ExtractHelper.CreateFieldElement("ADL_Dress Upper", body.ADL_Upper),
                            ExtractHelper.CreateFieldElement("ADL_Dress Lower", body.ADL_Lower),
                            ExtractHelper.CreateFieldElement("ADL_Bathing", body.ADL_Bath),
                            ExtractHelper.CreateFieldElement("ADL_Toileting", body.ADL_Toilet),
                            ExtractHelper.CreateFieldElement("ADL_Transferring", body.ADL_Transfer),
                            ExtractHelper.CreateFieldElement("ADL_Feed", body.ADL_Feed)
                            ));

                }
            }

            xml.Root.Add(ExtractHelper.CreateRootAttributes(client, fileName));

            return xml;
        }

        private static void Engine_BeforeReadRecord(EngineBase engine, BeforeReadEventArgs<CmsCsvBody> e)
        {
            if (e.RecordLine.StartsWith("Location_Name_Code")) e.SkipThisRecord = true;
        }
    }
}
