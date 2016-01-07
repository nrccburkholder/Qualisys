using FileHelpers.MasterDetail;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors
{
    internal static class OcsPtctCsvParser
    {
        public static XDocument Parse(ClientDetail client, string fullFileName, string fileContents, bool isPtct)
        {
            var xml = ExtractHelper.CreateEmptyDocument();

            var engine = new MasterDetailEngine<OcsPtctCsvHeader, OcsPtctCsvBody>(new MasterDetailSelector(RecordSelector));
            var result = engine.ReadString(ExtractHelper.AddTrailingCommas(fileContents));

            if (result.Length == 0) throw new InvalidOperationException("No header found in file.");
            if (result.Length > 1) throw new InvalidOperationException("More than one header found in file.");

            ParseHeader(xml, result[0].Master);
            ParseBody(xml, result[0].Details, isPtct);

            xml.Root.Add(ExtractHelper.CreateRootAttributes(client, fullFileName));

            return xml;
        }

        private static RecordAction RecordSelector(string record)
        {
            if (string.IsNullOrWhiteSpace(record) || ExtractHelper.IsFieldNamesLine(record))
                return RecordAction.Skip;

            var columnsWithData = ExtractHelper.ColumnsWithData(record);

            if (columnsWithData == 0)
                return RecordAction.Skip;
            else if (columnsWithData <= 8)
                return RecordAction.Master;
            else
                return RecordAction.Detail;
        }

        private static void ParseHeader(XDocument xml, OcsPtctCsvHeader header)
        {
            var metadata = ExtractHelper.GetMetadataElement(xml);

            metadata.Add(
                ExtractHelper.CreateTransformRow(1,
                    ExtractHelper.CreateFieldElement(ExtractHelper.MonthField, header.SampleMonth),
                    ExtractHelper.CreateFieldElement(ExtractHelper.YearField, header.SampleYear),
                    ExtractHelper.CreateFieldElement(ExtractHelper.ProviderIdField, header.ProviderID),
                    ExtractHelper.CreateFieldElement(ExtractHelper.ProviderNameField, header.ProviderName),
                    ExtractHelper.CreateFieldElement(ExtractHelper.NpiField, header.NPI),
                    ExtractHelper.CreateFieldElement(ExtractHelper.TotalPatientsServedField, header.TotalNumberOfPatientsServed),
                    ExtractHelper.CreateFieldElement(ExtractHelper.NumberOfBranchesField, header.NumberOfBranchesServed),
                    ExtractHelper.CreateFieldElement(ExtractHelper.VersionNumberField, header.VersionNumber)
                    ));
        }

        private static void ParseBody(XDocument xml, IEnumerable<OcsPtctCsvBody> records, bool isPtct)
        {
            var rows = ExtractHelper.GetRowsElement(xml);
            int rowCount = 0;
            foreach (var body in records)
            {
                rowCount++;

                rows.Add(
                    ExtractHelper.CreateTransformRow(rowCount,
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
                        ExtractHelper.CreateFieldElement(ExtractHelper.LookbackPeriodVisitsField, GetLookbackSkilledVisits(body.PriorMonth_Skilled_Visits, body.CurrentMonth_Skilled_Visits, isPtct)),
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
                        ExtractHelper.CreateFieldElement(ExtractHelper.HMOIndicatorField, ZeroFixup(body.HMO_Indicator, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.DuallyeligibleforMedicareandMedicaidField, ZeroFixup(body.Dual_eligible, isPtct)),
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
                        ExtractHelper.CreateFieldElement(ExtractHelper.SurgicalDischargeField, ZeroFixup(body.Surgical_Discharge, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.EndStageRenalDiseaseESRDField, ZeroFixup(body.ESRD, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.DialysisIndicatorField, body.Dialysis_Indicator),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ReferralSourceField, body.Referral_Source),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SkilledNursingField, ZeroFixup(body.SN, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.PhysicalTherapyField, ZeroFixup(body.PT, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.HomeHealthAideField, ZeroFixup(body.HHA, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SocialServiceField, ZeroFixup(body.Social_Service, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.OccupationalTherapyField, ZeroFixup(body.OT, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.CompanionHomemakerField, body.Comp_Hmkr),
                        ExtractHelper.CreateFieldElement(ExtractHelper.SpeechTherapyField, ZeroFixup(body.ST, isPtct)),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_DressUpperField, body.ADL_Upper),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_DressLowerField, body.ADL_Lower),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_BathingField, body.ADL_Bath),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_ToiletingField, body.ADL_Toilet),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_TransferringField, body.ADL_Transfer),
                        ExtractHelper.CreateFieldElement(ExtractHelper.ADL_FeedField, body.ADL_Feed)
                        ));
            }
        }

        private static string ZeroFixup(string value, bool isPtct)
        {
            if (isPtct && value != null && value.Equals("0"))
            {
                return "2";
            }
            else
            {
                return value;
            }
        }

        private static int? GetLookbackSkilledVisits(int? priorMonthSkilledVisits, int? currentMonthSkilledVisits, bool isPtct)
        {
            if (isPtct)
                return priorMonthSkilledVisits - currentMonthSkilledVisits;
            else
                return priorMonthSkilledVisits;
        }
    }
}
