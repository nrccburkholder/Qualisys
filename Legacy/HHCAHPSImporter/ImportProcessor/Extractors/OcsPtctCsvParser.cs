using FileHelpers.MasterDetail;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using static HHCAHPSImporter.ImportProcessor.Extractors.ExtractHelper;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class OcsPtctCsvParser
    {
        public static XDocument Parse(ClientDetail client, string fullFileName, string fileContents, bool isPtct)
        {
            var xml = CreateEmptyDocument();

            var engine = new MasterDetailEngine<OcsPtctCsvHeader, OcsPtctCsvBody>(new MasterDetailSelector(RecordSelector));
            var result = engine.ReadString(AddTrailingCommas(fileContents));

            if (result.Length == 0) throw new InvalidOperationException("No header found in file.");
            if (result.Length > 1) throw new InvalidOperationException("More than one header found in file.");

            ParseHeader(xml, result[0].Master);
            ParseBody(xml, result[0].Details, isPtct);

            xml.Root.Add(CreateRootAttributes(client, fullFileName));

            return xml;
        }

        private static RecordAction RecordSelector(string record)
        {
            if (string.IsNullOrWhiteSpace(record) || IsFieldNamesLine(record))
                return RecordAction.Skip;

            var columnsWithData = ColumnsWithData(record);

            if (columnsWithData == 0)
                return RecordAction.Skip;
            else if (columnsWithData <= 8)
                return RecordAction.Master;
            else
                return RecordAction.Detail;
        }

        private static void ParseHeader(XDocument xml, OcsPtctCsvHeader header)
        {
            var metadata = GetMetadataElement(xml);

            metadata.Add(
                CreateTransformRow(1,
                    CreateFieldElement(MonthField, header.SampleMonth),
                    CreateFieldElement(YearField, header.SampleYear),
                    CreateFieldElement(ProviderIdField, header.ProviderID),
                    CreateFieldElement(ProviderNameField, header.ProviderName),
                    CreateFieldElement(NpiField, header.NPI),
                    CreateFieldElement(TotalPatientsServedField, header.TotalNumberOfPatientsServed),
                    CreateFieldElement(NumberOfBranchesField, header.NumberOfBranchesServed),
                    CreateFieldElement(VersionNumberField, header.VersionNumber)
                    ));
        }

        private static void ParseBody(XDocument xml, IEnumerable<OcsPtctCsvBody> records, bool isPtct)
        {
            var rows = GetRowsElement(xml);
            int rowCount = 0;
            foreach (var body in records)
            {
                rowCount++;

                rows.Add(
                    CreateTransformRow(rowCount,
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
                        CreateFieldElement(LookbackPeriodVisitsField, GetLookbackSkilledVisits(body.PriorMonth_Skilled_Visits, body.CurrentMonth_Skilled_Visits, isPtct)),
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
                        CreateFieldElement(HMOIndicatorField, ZeroFixup(body.HMO_Indicator, isPtct)),
                        CreateFieldElement(DuallyeligibleforMedicareandMedicaidField, ZeroFixup(body.Dual_eligible, isPtct)),
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
                        CreateFieldElement(SurgicalDischargeField, ZeroFixup(body.Surgical_Discharge, isPtct)),
                        CreateFieldElement(EndStageRenalDiseaseESRDField, GetESRD(ZeroFixup(body.ESRD, isPtct), body.ICD_A2, body.ICD_B2, body.ICD_C2, body.ICD_D2, body.ICD_E2, body.ICD_F2)),
                        CreateFieldElement(DialysisIndicatorField, body.Dialysis_Indicator),
                        CreateFieldElement(ReferralSourceField, body.Referral_Source),
                        CreateFieldElement(SkilledNursingField, ZeroFixup(body.SN, isPtct)),
                        CreateFieldElement(PhysicalTherapyField, ZeroFixup(body.PT, isPtct)),
                        CreateFieldElement(HomeHealthAideField, ZeroFixup(body.HHA, isPtct)),
                        CreateFieldElement(SocialServiceField, ZeroFixup(body.Social_Service, isPtct)),
                        CreateFieldElement(OccupationalTherapyField, ZeroFixup(body.OT, isPtct)),
                        CreateFieldElement(CompanionHomemakerField, body.Comp_Hmkr),
                        CreateFieldElement(SpeechTherapyField, ZeroFixup(body.ST, isPtct)),
                        CreateFieldElement(ADL_DressUpperField, body.ADL_Upper),
                        CreateFieldElement(ADL_DressLowerField, body.ADL_Lower),
                        CreateFieldElement(ADL_BathingField, body.ADL_Bath),
                        CreateFieldElement(ADL_ToiletingField, body.ADL_Toilet),
                        CreateFieldElement(ADL_TransferringField, body.ADL_Transfer),
                        CreateFieldElement(ADL_FeedField, body.ADL_Feed)
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
                return (priorMonthSkilledVisits ?? 0) - (currentMonthSkilledVisits ?? 0);
            else
                return priorMonthSkilledVisits ?? currentMonthSkilledVisits;
        }
    }
}
