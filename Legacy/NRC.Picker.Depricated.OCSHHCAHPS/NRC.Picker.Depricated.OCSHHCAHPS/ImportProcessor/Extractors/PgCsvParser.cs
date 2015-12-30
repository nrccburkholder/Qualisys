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
    internal static class PgCsvParser
    {
        public static XDocument Parse(ClientDetail client, string fileName, string fileContents)
        {
            var xml = ExtractHelper.CreateEmptyDocument();

            var engine = new FileHelperAsyncEngine<PgCsvBody>();
            engine.BeforeReadRecord += Engine_BeforeReadRecord;

            using (engine.BeginReadString(fileContents))
            {
                var metadata = ExtractHelper.GetMetadataElement(xml);
                var rows = ExtractHelper.GetRowsElement(xml);
                var firstRecord = true;
                var rowNumber = 0;

                foreach (var body in engine)
                {
                    if (firstRecord)
                        metadata.Add(
                            ExtractHelper.CreateTransformRow(1,
                                ExtractHelper.CreateFieldElement(ExtractHelper.MonthField, body.SampleMonth),
                                ExtractHelper.CreateFieldElement(ExtractHelper.YearField, body.SampleYear),
                                ExtractHelper.CreateFieldElement(ExtractHelper.ProviderIdField, body.ClientNumber),
                                ExtractHelper.CreateFieldElement(ExtractHelper.ProviderNameField, ""),
                                ExtractHelper.CreateFieldElement(ExtractHelper.TotalPatientsServedField, body.TotalNumberOfPatientsServed),
                                ExtractHelper.CreateFieldElement(ExtractHelper.NumberOfBranchesField, ""),
                                ExtractHelper.CreateFieldElement(ExtractHelper.VersionNumberField, "")
                                ));

                    firstRecord = false;

                    rowNumber++;

                    rows.Add(
                        ExtractHelper.CreateTransformRow(rowNumber,
                            ExtractHelper.CreateFieldElement(ExtractHelper.PatientIDField, body.Patient_ID),
                            ExtractHelper.CreateFieldElement(ExtractHelper.MedicalRecordNumberField, ""),
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
                            ExtractHelper.CreateFieldElement(ExtractHelper.PatientDateofBirthField, ExtractHelper.ConvertDateFormat(body.DOB, false)),
                            ExtractHelper.CreateFieldElement(ExtractHelper.LanguageField, body.Language),
                            ExtractHelper.CreateFieldElement(ExtractHelper.StartofCareDateField, ExtractHelper.ConvertDateFormat(body.SOC_Date, false)),
                            ExtractHelper.CreateFieldElement(ExtractHelper.NumberofskilledvisitsField, body.CurrentMonth_Skilled_Visits),
                            ExtractHelper.CreateFieldElement(ExtractHelper.LookbackPeriodVisitsField, body.LastTwoMonths_Skilled_Visits - body.CurrentMonth_Skilled_Visits),
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
                            ExtractHelper.CreateFieldElement(ExtractHelper.DeceasedIndicatorField, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.HospiceIndicatorField, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.MaternityCareOnlyIndicatorField, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.BranchIDField, body.Branch_ID),
                            ExtractHelper.CreateFieldElement(ExtractHelper.HomeHealthVisitTypeField, body.HH_Visit_Type),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AssessmentReasonField, body.Assessment_Reason),
                            ExtractHelper.CreateFieldElement(ExtractHelper.DischargeDateField, ExtractHelper.ConvertDateFormat(body.Discharge_Date, false)),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceNFField, body.Admission_NF),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceSNFField, body.Admission_SNF),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceIPPSField, body.Admission_IPPS),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceLTCHField, body.Admission_LTCH),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceIRFField, body.Admission_IRF),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourcePyschField, body.Admission_Pysch),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceOtherField, body.Admission_Other),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceNACommunityField, body.Admission_NA),
                            ExtractHelper.CreateFieldElement(ExtractHelper.AdmissionSourceUnknownField, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.HMOIndicatorField, body.HMO_Indicator),
                            ExtractHelper.CreateFieldElement(ExtractHelper.DuallyeligibleforMedicareandMedicaidField, body.Dual_eligible),
                            ExtractHelper.CreateFieldElement(ExtractHelper.PrimaryDiagnosisICD_A2Field, body.ICD_A2),
                            ExtractHelper.CreateFieldElement(ExtractHelper.PrimaryPaymentDiagnosisICD_A3Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.PrimaryPaymentDiagnosisICD_A4Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_B2Field, body.ICD_B2),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_B3Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_B4Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_C2Field, body.ICD_C2),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_C3Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_C4Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_D2Field, body.ICD_D2),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_D3Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_D4Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_E2Field, body.ICD_E2),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_E3Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_E4Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.Otherdiagnosis_F2Field, body.ICD_F2),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_F3Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.OtherPaymentDiagnosisICD_F4Field, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.SurgicalDischargeField, body.Surgical_Discharge),
                            ExtractHelper.CreateFieldElement(ExtractHelper.EndStageRenalDiseaseESRDField, body.ESRD),
                            ExtractHelper.CreateFieldElement(ExtractHelper.DialysisIndicatorField, ""),
                            ExtractHelper.CreateFieldElement(ExtractHelper.ReferralSourceField, body.Referral_Source),
                            ExtractHelper.CreateFieldElement(ExtractHelper.SkilledNursingField, ""),
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

            xml.Root.Add(ExtractHelper.CreateRootAttributes(client, fileName));

            return xml;
        }

        private static void Engine_BeforeReadRecord(EngineBase engine, BeforeReadEventArgs<PgCsvBody> e)
        {
            if (ExtractHelper.IsBlankCsvLine(e.RecordLine)) e.SkipThisRecord = true;
            else if (e.RecordLine.StartsWith("Survey_Designator")) e.SkipThisRecord = true;
        }
    }
}
