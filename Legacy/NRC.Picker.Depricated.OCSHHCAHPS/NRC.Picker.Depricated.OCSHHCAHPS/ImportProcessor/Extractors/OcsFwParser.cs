using System;
using System.Linq;
using System.Xml.Linq;
using System.Collections.Generic;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using FileHelpers;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal static class OcsFwParser
    {
        private enum OcsFwBodyVersion
        {
            V1,
            V2
        }

        private const int BODY_LINE_LENGTH_V1 = 469;
        private const int BODY_LINE_LENGTH_V2 = 505;
        private const int BODY_LINE_LENGTH = 505;
        private const int SHORT_LINE_FLEX = 20; // consider that they might not pad the last field, so a body line might be short by let's say 20
        private const int MIN_BODY_LINE_LENGTH = BODY_LINE_LENGTH - SHORT_LINE_FLEX;

        public static XDocument Parse(ClientDetail client, string fileName, string fileContents)
        {
            var xml = ExtractHelper.CreateEmptyDocument();
            var lines = ExtractHelper.GetLinesForFixedWidthFile(fileContents);

            ParseHeader(xml, lines);
            ParseBody(xml, lines);

            xml.Root.Add(ExtractHelper.CreateRootAttributes(client, fileName));

            return xml;
        }

        private static void ParseHeader(XDocument xml, IEnumerable<string> lines)
        {
            var foundHeader = false;
            var metadata = ExtractHelper.GetMetadataElement(xml);
            foreach (var line in lines)
            {
                if (IsHeader(line))
                {
                    if (foundHeader) throw new InvalidOperationException("More than one header found in file.");
                    foundHeader = true;

                    var header = ExtractHelper.Parse<OcsFwHeader>(line);

                    metadata.Add(
                        ExtractHelper.CreateTransformRow(1,
                            ExtractHelper.CreateFieldElement("MONTH", header.SampleMonth ?? -1),
                            ExtractHelper.CreateFieldElement("YEAR", header.SampleYear ?? -1),
                            ExtractHelper.CreateFieldElement("PROVIDER ID", header.ProviderID),
                            ExtractHelper.CreateFieldElement("PROVIDER NAME", header.ProviderName),
                            ExtractHelper.CreateFieldElement("TOTAL NUMBER OF PATIENT SERVED", header.TotalNumberOfPatientsServed),
                            ExtractHelper.CreateFieldElement("NUMBER OF BRANCHES", header.NumberOfBranchesServed),
                            ExtractHelper.CreateFieldElement("VERSION NUMBER", header.VersionNumber)
                            ));
                }
            }

            if (!foundHeader) throw new InvalidOperationException("No header found in file.");
        }

        private static bool IsHeader(string line)
        {
            return (line.TrimEnd().Length < MIN_BODY_LINE_LENGTH && line.Length > 1 && !line.EndsWith("%"));
        }

        private static bool IsBlank(string line)
        {
            return string.IsNullOrWhiteSpace(line);
        }

        private static void ParseBody(XDocument xml, IEnumerable<string> lines)
        {
            var engineV1 = new FileHelperAsyncEngine<OcsFwBodyV1>();
            var engineV2 = new FileHelperAsyncEngine<OcsFwBodyV2>();
            
            var rows = ExtractHelper.GetRowsElement(xml);
            int rowNumber = 0;
            int lineNumber = 0;
            foreach (var line in lines)
            {
                lineNumber++;
                if (IsBlank(line)) continue;
                if (IsHeader(line)) continue;
                rowNumber++;
                
                var version = GetBodyVersion(line, lineNumber);
                dynamic body;
                switch (version)
                {
                    case OcsFwBodyVersion.V1:
                        using (engineV1.BeginReadString(line))
                        {
                            body = engineV1.ReadNext();
                        }
                        break;
                    case OcsFwBodyVersion.V2:
                        using (engineV2.BeginReadString(line))
                        {
                            body = engineV2.ReadNext();
                        }
                        break;
                    default:
                        throw new InvalidOperationException(string.Format("Unrecognized file version {0}.", version));
                }

                rows.Add(
                    ExtractHelper.CreateTransformRow(rowNumber,
                        ExtractHelper.CreateFieldElement("Patient ID", body.Patient_ID),
                        ExtractHelper.CreateFieldElement("Medical Record Number", body.MedicalRecordNumber),
                        ExtractHelper.CreateFieldElement("Patient First Name", body.First_Name),
                        ExtractHelper.CreateFieldElement("Patient Middle Initial", body.Middle_Initial),
                        ExtractHelper.CreateFieldElement("Patient Last Name", body.Last_Name),
                        ExtractHelper.CreateFieldElement("Patient Mailing Address 1", body.Address1),
                        ExtractHelper.CreateFieldElement("Patient Mailing Address 2", ExtractHelper.IsPhoneNumber(body.Address2) ? "" : body.Address2),
                        ExtractHelper.CreateFieldElement("Patient Address City", body.City),
                        ExtractHelper.CreateFieldElement("Patient Address State", body.State),
                        ExtractHelper.CreateFieldElement("Patient Address Zip Code", body.ZipCode),
                        ExtractHelper.CreateFieldElement("Telephone Number including area code", body.Telephone),
                        ExtractHelper.CreateFieldElement("Gender", body.Gender),
                        ExtractHelper.CreateFieldElement("Patient Date of Birth", ExtractHelper.ConvertDateFormat(body.DOB, false)),
                        ExtractHelper.CreateFieldElement("Language", body.Language),
                        ExtractHelper.CreateFieldElement("Start of Care Date", ExtractHelper.ConvertDateFormat(body.SOC_Date, false)),
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
                        ExtractHelper.CreateFieldElement("Discharge Date", ExtractHelper.ConvertDateFormat(body.Discharge_Date, false)),
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

        private static OcsFwBodyVersion GetBodyVersion(string line, int lineNumber)
        {
            var index = line.LastIndexOf("%");
            var characters = (index > 0) ? index + 1 : line.Length;

            switch (characters)
            {
                case BODY_LINE_LENGTH_V1:
                    return OcsFwBodyVersion.V1;
                case BODY_LINE_LENGTH_V2:
                    return OcsFwBodyVersion.V2;
                default:
                    throw new InvalidOperationException(string.Format("{0} characters found on line {1} which doesn't match either version 1 or 2 files.", characters, lineNumber));
            }
        }
    }
}
