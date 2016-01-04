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

        public static XDocument Parse(ClientDetail client, string fullFileName, string fileContents)
        {
            var xml = ExtractHelper.CreateEmptyDocument();
            var lines = ExtractHelper.GetLinesForFixedWidthFile(fileContents);

            ParseHeader(xml, lines);
            ParseBody(xml, lines);

            xml.Root.Add(ExtractHelper.CreateRootAttributes(client, fullFileName));

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
                            ExtractHelper.CreateFieldElement(ExtractHelper.MonthField, header.SampleMonth ?? -1),
                            ExtractHelper.CreateFieldElement(ExtractHelper.YearField, header.SampleYear ?? -1),
                            ExtractHelper.CreateFieldElement(ExtractHelper.ProviderIdField, header.ProviderID),
                            ExtractHelper.CreateFieldElement(ExtractHelper.ProviderNameField, header.ProviderName),
                            ExtractHelper.CreateFieldElement(ExtractHelper.TotalPatientsServedField, header.TotalNumberOfPatientsServed),
                            ExtractHelper.CreateFieldElement(ExtractHelper.NumberOfBranchesField, header.NumberOfBranchesServed),
                            ExtractHelper.CreateFieldElement(ExtractHelper.VersionNumberField, header.VersionNumber)
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
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientIDField, body.Patient_ID),
                        ExtractHelper.CreateFieldElement(ExtractHelper.MedicalRecordNumberField, body.MedicalRecordNumber),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientFirstNameField, body.First_Name),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientMiddleInitialField, body.Middle_Initial),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientLastNameField, body.Last_Name),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientMailingAddress1Field, body.Address1),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientMailingAddress2Field, ExtractHelper.IsPhoneNumber(body.Address2) ? "" : body.Address2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientAddressCityField, body.City),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientAddressStateField, body.State),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientAddressZipCodeField, body.ZipCode),
                        ExtractHelper.CreateFieldElement(ExtractHelper.TelephoneNumberincludingareacodeField, body.Telephone),
                        ExtractHelper.CreateFieldElement(ExtractHelper.GenderField, body.Gender),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PatientDateofBirthField, body.DOB),
                        ExtractHelper.CreateFieldElement(ExtractHelper.LanguageField, body.Language),
                        ExtractHelper.CreateFieldElement(ExtractHelper.StartofCareDateField, body.SOC_Date),
                        ExtractHelper.CreateFieldElement(ExtractHelper.NumberofskilledvisitsField, body.CurrentMonth_Skilled_Visits),
                        ExtractHelper.CreateFieldElement(ExtractHelper.LookbackPeriodVisitsField, body.PriorMonth_Skilled_Visits),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerNoneField, body.Payer_None),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerMedicareFFSField, body.Payer_MedicareFFS),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerMedicareHMOField, body.Payer_MedicareHMO),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerMedicaidFFSField, body.Payer_MedicaidFFS),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerMedicaidHMOField, body.Payer_MedicaidHMO),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerWorkersCompField, body.Payer_WkersComp),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerTitleprogramsField, body.Payer_Title),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerOtherGovernmentField, body.Payer_OtherGov),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerPrivateInsField, body.Payer_Private),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerPrivateHMOField, body.Payer_PrivateHMO),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerSelfpayField, body.Payer_Self),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerOtherField, body.Payer_Other),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PayerUnknownField, body.Payer_UK),
                        ExtractHelper.CreateFieldElement(ExtractHelper.DeceasedIndicatorField, body.Deceased_Indicator),
                        ExtractHelper.CreateFieldElement(ExtractHelper.HospiceIndicatorField, body.Hospice_Indicator),
                        ExtractHelper.CreateFieldElement(ExtractHelper.MaternityCareOnlyIndicatorField, body.Maternity_Indicator),
                        ExtractHelper.CreateFieldElement(ExtractHelper.BranchIDField, body.Branch_ID),
                        ExtractHelper.CreateFieldElement(ExtractHelper.HomeHealthVisitTypeField, body.HH_Visit_Type),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AssessmentReasonField, body.Assessment_Reason),
                        ExtractHelper.CreateFieldElement(ExtractHelper.DischargeDateField, body.Discharge_Date),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceNFField, body.Admission_NF),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceSNFField, body.Admission_SNF),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceIPPSField, body.Admission_IPPS),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceLTCHField, body.Admission_LTCH),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceIRFField, body.Admission_IRF),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourcePyschField, body.Admission_Pysch),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceOtherField, body.Admission_Other),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceNACommunityField, body.Admission_NA),
                        ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceUnknownField, body.Admission_UK),
                        ExtractHelper.CreateFieldElement(ExtractHelper.HMOIndicatorField, body.HMO_Indicator),
                        ExtractHelper.CreateFieldElement(ExtractHelper.DuallyeligibleforMedicareandMedicaidField, body.Dual_eligible),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PrimaryDiagnosisICD_A2Field, body.ICD_A2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PrimaryPaymentDiagnosisICD_A3Field, body.ICD_A3),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PrimaryPaymentDiagnosisICD_A4Field, body.ICD_A4),
                        ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_B2Field, body.ICD_B2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_B3Field, body.ICD_B3),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_B4Field, body.ICD_B4),
                        ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_C2Field, body.ICD_C2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_C3Field, body.ICD_C3),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_C4Field, body.ICD_C4),
                        ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_D2Field, body.ICD_D2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_D3Field, body.ICD_D3),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_D4Field, body.ICD_D4),
                        ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_E2Field, body.ICD_E2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_E3Field, body.ICD_E3),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_E4Field, body.ICD_E4),
                        ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_F2Field, body.ICD_F2),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_F3Field, body.ICD_F3),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_F4Field, body.ICD_F4),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SurgicalDischargeField, body.Surgical_Discharge),
                        ExtractHelper.CreateFieldElement(ExtractHelper.EndStageRenalDiseaseESRDField, body.ESRD),
                        ExtractHelper.CreateFieldElement(ExtractHelper.DialysisIndicatorField, body.Dialysis_Indicator),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ReferralSourceField, body.Referral_Source),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SkilledNursingField, body.SN),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PhysicalTherapyField, body.PT),
                        ExtractHelper.CreateFieldElement(ExtractHelper.HomeHealthAideField, body.HHA),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SocialServiceField, body.Social_Service),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OccupationalTherapyField, body.OT),
                        ExtractHelper.CreateFieldElement(ExtractHelper.CompanionHomemakerField, body.Comp_Hmkr),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SpeechTherapyField, body.ST),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_DressUpperField, body.ADL_Upper),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_DressLowerField, body.ADL_Lower),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_BathingField, body.ADL_Bath),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_ToiletingField, body.ADL_Toilet),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_TransferringField, body.ADL_Transfer),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_FeedField, body.ADL_Feed)
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
