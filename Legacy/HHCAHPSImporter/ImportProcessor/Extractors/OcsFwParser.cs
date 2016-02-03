using System;
using System.Linq;
using System.Xml.Linq;
using System.Collections.Generic;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using FileHelpers;
using static HHCAHPSImporter.ImportProcessor.Extractors.ExtractHelper;

namespace HHCAHPSImporter.ImportProcessor.Extractors
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
            var xml = CreateEmptyDocument();
            var lines = GetLinesForFixedWidthFile(fileContents);

            ParseHeader(xml, lines);
            ParseBody(xml, lines);

            xml.Root.Add(CreateRootAttributes(client, fullFileName));

            return xml;
        }

        private static void ParseHeader(XDocument xml, IEnumerable<string> lines)
        {
            var foundHeader = false;
            var metadata = GetMetadataElement(xml);
            foreach (var line in lines)
            {
                if (IsHeader(line))
                {
                    if (foundHeader) throw new InvalidOperationException("More than one header found in file.");
                    foundHeader = true;

                    var header = Parse<OcsFwHeader>(line);

                    metadata.Add(
                        CreateTransformRow(1,
                            CreateFieldElement(MonthField, header.SampleMonth ?? -1),
                            CreateFieldElement(YearField, header.SampleYear ?? -1),
                            CreateFieldElement(ProviderIdField, header.ProviderID),
                            CreateFieldElement(ProviderNameField, header.ProviderName),
                            CreateFieldElement(NpiField, header.NPI),
                            CreateFieldElement(TotalPatientsServedField, header.TotalNumberOfPatientsServed),
                            CreateFieldElement(NumberOfBranchesField, header.NumberOfBranchesServed),
                            CreateFieldElement(VersionNumberField, header.VersionNumber)
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
            
            var rows = GetRowsElement(xml);
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
                        throw new InvalidOperationException($"Unrecognized file version {version}.");
                }

                rows.Add(
                    CreateTransformRow(rowNumber,
                        CreateFieldElement(PatientIDField, body.Patient_ID),
                        CreateFieldElement(MedicalRecordNumberField, body.MedicalRecordNumber),
                        CreateFieldElement(PatientFirstNameField, body.First_Name),
                        CreateFieldElement(PatientMiddleInitialField, body.Middle_Initial),
                        CreateFieldElement(PatientLastNameField, body.Last_Name),
                        CreateFieldElement(PatientMailingAddress1Field, body.Address1),
                        CreateFieldElement(PatientMailingAddress2Field, IsPhoneNumber(body.Address2) ? "" : body.Address2),
                        CreateFieldElement(PatientAddressCityField, body.City),
                        CreateFieldElement(PatientAddressStateField, body.State),
                        CreateFieldElement(PatientAddressZipCodeField, body.ZipCode),
                        CreateFieldElement(TelephoneNumberincludingareacodeField, body.Telephone),
                        CreateFieldElement(GenderField, body.Gender),
                        CreateFieldElement(PatientDateofBirthField, body.DOB),
                        CreateFieldElement(LanguageField, body.Language),
                        CreateFieldElement(StartofCareDateField, body.SOC_Date),
                        CreateFieldElement(NumberofskilledvisitsField, body.CurrentMonth_Skilled_Visits),
                        CreateFieldElement(LookbackPeriodVisitsField, (body.CurrentMonth_Skilled_Visits ?? 0) + (body.PriorMonth_Skilled_Visits ?? 0)),
                        CreateFieldElement(PayerNoneField, body.Payer_None),
                        CreateFieldElement(PayerMedicareFFSField, body.Payer_MedicareFFS),
                        CreateFieldElement(PayerMedicareHMOField, body.Payer_MedicareHMO),
                        CreateFieldElement(PayerMedicaidFFSField, body.Payer_MedicaidFFS),
                        CreateFieldElement(PayerMedicaidHMOField, body.Payer_MedicaidHMO),
                        CreateFieldElement(PayerWorkersCompField, body.Payer_WkersComp),
                        CreateFieldElement(PayerTitleprogramsField, body.Payer_Title),
                        CreateFieldElement(PayerOtherGovernmentField, body.Payer_OtherGov),
                        CreateFieldElement(PayerPrivateInsField, body.Payer_Private),
                        CreateFieldElement(PayerPrivateHMOField, body.Payer_PrivateHMO),
                        CreateFieldElement(PayerSelfpayField, body.Payer_Self),
                        CreateFieldElement(PayerOtherField, body.Payer_Other),
                        CreateFieldElement(PayerUnknownField, body.Payer_UK),
                        CreateFieldElement(DeceasedIndicatorField, body.Deceased_Indicator),
                        CreateFieldElement(HospiceIndicatorField, body.Hospice_Indicator),
                        CreateFieldElement(MaternityCareOnlyIndicatorField, body.Maternity_Indicator),
                        CreateFieldElement(BranchIDField, body.Branch_ID),
                        CreateFieldElement(HomeHealthVisitTypeField, body.HH_Visit_Type),
                        CreateFieldElement(AssessmentReasonField, body.Assessment_Reason),
                        CreateFieldElement(DischargeDateField, body.Discharge_Date),
                        CreateFieldElement(AdmissionSourceNFField, body.Admission_NF),
                        CreateFieldElement(AdmissionSourceSNFField, body.Admission_SNF),
                        CreateFieldElement(AdmissionSourceIPPSField, body.Admission_IPPS),
                        CreateFieldElement(AdmissionSourceLTCHField, body.Admission_LTCH),
                        CreateFieldElement(AdmissionSourceIRFField, body.Admission_IRF),
                        CreateFieldElement(AdmissionSourcePyschField, body.Admission_Pysch),
                        CreateFieldElement(AdmissionSourceOtherField, body.Admission_Other),
                        CreateFieldElement(AdmissionSourceNACommunityField, body.Admission_NA),
                        CreateFieldElement(AdmissionSourceUnknownField, body.Admission_UK),
                        CreateFieldElement(HMOIndicatorField, body.HMO_Indicator),
                        CreateFieldElement(DuallyeligibleforMedicareandMedicaidField, body.Dual_eligible),
                        CreateFieldElement(PrimaryDiagnosisICD_A2Field, body.ICD_A2),
                        CreateFieldElement(PrimaryPaymentDiagnosisICD_A3Field, body.ICD_A3),
                        CreateFieldElement(PrimaryPaymentDiagnosisICD_A4Field, body.ICD_A4),
                        CreateFieldElement(Otherdiagnosis_B2Field, body.ICD_B2),
                        CreateFieldElement(OtherPaymentDiagnosisICD_B3Field, body.ICD_B3),
                        CreateFieldElement(OtherPaymentDiagnosisICD_B4Field, body.ICD_B4),
                        CreateFieldElement(Otherdiagnosis_C2Field, body.ICD_C2),
                        CreateFieldElement(OtherPaymentDiagnosisICD_C3Field, body.ICD_C3),
                        CreateFieldElement(OtherPaymentDiagnosisICD_C4Field, body.ICD_C4),
                        CreateFieldElement(Otherdiagnosis_D2Field, body.ICD_D2),
                        CreateFieldElement(OtherPaymentDiagnosisICD_D3Field, body.ICD_D3),
                        CreateFieldElement(OtherPaymentDiagnosisICD_D4Field, body.ICD_D4),
                        CreateFieldElement(Otherdiagnosis_E2Field, body.ICD_E2),
                        CreateFieldElement(OtherPaymentDiagnosisICD_E3Field, body.ICD_E3),
                        CreateFieldElement(OtherPaymentDiagnosisICD_E4Field, body.ICD_E4),
                        CreateFieldElement(Otherdiagnosis_F2Field, body.ICD_F2),
                        CreateFieldElement(OtherPaymentDiagnosisICD_F3Field, body.ICD_F3),
                        CreateFieldElement(OtherPaymentDiagnosisICD_F4Field, body.ICD_F4),
                        CreateFieldElement(SurgicalDischargeField, body.Surgical_Discharge),
                        CreateFieldElement(EndStageRenalDiseaseESRDField, GetESRD(body.ESRD, body.ICD_A2, body.ICD_B2, body.ICD_C2, body.ICD_D2, body.ICD_E2, body.ICD_F2)),
                        CreateFieldElement(DialysisIndicatorField, body.Dialysis_Indicator),
                        CreateFieldElement(ReferralSourceField, body.Referral_Source),
                        CreateFieldElement(SkilledNursingField, body.SN),
                        CreateFieldElement(PhysicalTherapyField, body.PT),
                        CreateFieldElement(HomeHealthAideField, body.HHA),
                        CreateFieldElement(SocialServiceField, body.Social_Service),
                        CreateFieldElement(OccupationalTherapyField, body.OT),
                        CreateFieldElement(CompanionHomemakerField, body.Comp_Hmkr),
                        CreateFieldElement(SpeechTherapyField, body.ST),
                        CreateFieldElement(ADL_DressUpperField, body.ADL_Upper),
                        CreateFieldElement(ADL_DressLowerField, body.ADL_Lower),
                        CreateFieldElement(ADL_BathingField, body.ADL_Bath),
                        CreateFieldElement(ADL_ToiletingField, body.ADL_Toilet),
                        CreateFieldElement(ADL_TransferringField, body.ADL_Transfer),
                        CreateFieldElement(ADL_FeedField, body.ADL_Feed)
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
                    throw new InvalidOperationException($"{characters} characters found on line {lineNumber} which doesn't match either version 1 or 2 files.");
            }
        }
    }
}
