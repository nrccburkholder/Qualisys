using FileHelpers;
using FileHelpers.Events;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using static HHCAHPSImporter.ImportProcessor.Extractors.ExtractHelper;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class PgCsvParser
    {
        public static XDocument Parse(ClientDetail client, string fullFileName, string fileContents)
        {
            var xml = CreateEmptyDocument();

            var engine = new FileHelperAsyncEngine<PgCsvBody>();
            engine.BeforeReadRecord += Engine_BeforeReadRecord;

            using (engine.BeginReadString(fileContents))
            {
                var metadata = GetMetadataElement(xml);
                var rows = GetRowsElement(xml);
                var firstRecord = true;
                var rowNumber = 0;

                foreach (var body in engine)
                {
                    if (firstRecord)
                        metadata.Add(
                            CreateTransformRow(1,
                                CreateFieldElement(MonthField, body.SampleMonth),
                                CreateFieldElement(YearField, body.SampleYear),
                                CreateFieldElement(ProviderIdField, body.ClientNumber),
                                CreateFieldElement(ProviderNameField, ""),
                                CreateFieldElement(NpiField, ""),
                                CreateFieldElement(TotalPatientsServedField, body.TotalNumberOfPatientsServed),
                                CreateFieldElement(NumberOfBranchesField, ""),
                                CreateFieldElement(VersionNumberField, "")
                                ));

                    firstRecord = false;

                    rowNumber++;

                    rows.Add(
                        CreateTransformRow(rowNumber,
                            CreateFieldElement(PatientIDField, body.Patient_ID),
                            CreateFieldElement(MedicalRecordNumberField, ""),
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
                            CreateFieldElement(LookbackPeriodVisitsField, body.LastTwoMonths_Skilled_Visits - body.CurrentMonth_Skilled_Visits),
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
                            CreateFieldElement(DeceasedIndicatorField, ""),
                            CreateFieldElement(HospiceIndicatorField, ""),
                            CreateFieldElement(MaternityCareOnlyIndicatorField, ""),
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
                            CreateFieldElement(AdmissionSourceUnknownField, ""),
                            CreateFieldElement(HMOIndicatorField, body.HMO_Indicator),
                            CreateFieldElement(DuallyeligibleforMedicareandMedicaidField, body.Dual_eligible),
                            CreateFieldElement(PrimaryDiagnosisICD_A2Field, body.ICD_A2),
                            CreateFieldElement(PrimaryPaymentDiagnosisICD_A3Field, ""),
                            CreateFieldElement(PrimaryPaymentDiagnosisICD_A4Field, ""),
                            CreateFieldElement(Otherdiagnosis_B2Field, body.ICD_B2),
                            CreateFieldElement(OtherPaymentDiagnosisICD_B3Field, ""),
                            CreateFieldElement(OtherPaymentDiagnosisICD_B4Field, ""),
                            CreateFieldElement(Otherdiagnosis_C2Field, body.ICD_C2),
                            CreateFieldElement(OtherPaymentDiagnosisICD_C3Field, ""),
                            CreateFieldElement(OtherPaymentDiagnosisICD_C4Field, ""),
                            CreateFieldElement(Otherdiagnosis_D2Field, body.ICD_D2),
                            CreateFieldElement(OtherPaymentDiagnosisICD_D3Field, ""),
                            CreateFieldElement(OtherPaymentDiagnosisICD_D4Field, ""),
                            CreateFieldElement(Otherdiagnosis_E2Field, body.ICD_E2),
                            CreateFieldElement(OtherPaymentDiagnosisICD_E3Field, ""),
                            CreateFieldElement(OtherPaymentDiagnosisICD_E4Field, ""),
                            CreateFieldElement(Otherdiagnosis_F2Field, body.ICD_F2),
                            CreateFieldElement(OtherPaymentDiagnosisICD_F3Field, ""),
                            CreateFieldElement(OtherPaymentDiagnosisICD_F4Field, ""),
                            CreateFieldElement(SurgicalDischargeField, body.Surgical_Discharge),
                            CreateFieldElement(EndStageRenalDiseaseESRDField, body.ESRD),
                            CreateFieldElement(DialysisIndicatorField, ""),
                            CreateFieldElement(ReferralSourceField, body.Referral_Source),
                            CreateFieldElement(SkilledNursingField, ""),
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

            xml.Root.Add(CreateRootAttributes(client, fullFileName));

            return xml;
        }

        private static void Engine_BeforeReadRecord(EngineBase engine, BeforeReadEventArgs<PgCsvBody> e)
        {
            if (IsBlankCsvLine(e.RecordLine)) e.SkipThisRecord = true;
            else if (IsFieldNamesLine(e.RecordLine)) e.SkipThisRecord = true;
        }
    }
}
