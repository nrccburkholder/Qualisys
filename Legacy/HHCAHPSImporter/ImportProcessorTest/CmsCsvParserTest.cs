using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Linq;
using HHCAHPSImporter.ImportProcessor.Extractors;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class CmsCsvParserTest
    {
        #region Helpers

        private static string GetSample1File()
        {
            return
                "Location_Name_Code,ProviderName,Provider_ID,NPI,Sample_Month,Sample_Year,Total_Patients_Served_in_Period,Total_Patients_In_File,Patient_First_Name,Patient_Middle_Inital,Patient_Last_Name,Gender,Patient_Date_of_Birth,Start_Of_Care_Date,Patient_Mailing_Address_1,Patient_Mailing_Address_2,Patient_Mailing_City,Patient_State,Patient_Address_Zip_Code,Patient_Phone,Patient_Medical_Record_Number,Visits_In_Sample_Month,Visits_In_Lookback_Period,Inpatient_Facility_Long_Term_Nursing_Facility,Inpatient_Facility_Skilled_Nursing_Facility,Inpatient_Facility_Long_Term_Care_Hospital,Inpatient_Facility_Inpatient_Rehab_Hospital,Inpatient_Facility_Other,Inpatient_Facility_NA,Payer_None,Payer_Medicare_Fee_For_Service,Payer_Medicare_HMO_Managed_Care,Payer_Medicaid_Fee_For_Service,Payer_Medicaid_HMO_Managed_Care,Payer_Workers_Comp,Payer_Title_Programs,Payer_Other_Government,Payer_Private_Insurance,Payer_Private_HMO_Managed_Care,Payer_Self_Pay,Payer_Other_Sources,Payer_Unknown,HMO_Indicator,Medicare_Medicaid_Dually_Elgible,Primary_Diagnosis,Secondary_Diagnosis_1,Secondary_Diagnosis_2,Secondary_Diagnosis_3,Secondary_Diagnosis_4,Secondary_Diagnosis_5,Surgical_Discharge,ESRD,Number_ADL_Deficits,ADL_Dress_Upper,ADL_Dress_Lower,ADL_Bathing,ADL_Toileting,ADL_Transferring,ADL_Feeding,Language\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M,1\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,CHARLES,M,BENTZLEY,1,8101939,4092010,138 Wellstone Drive,,Palm Coast,FL,32164,3863160540,698711M,8,19,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,345.9,250,401.9,414,294.1,272.4,2,M,5,1,2,2,1,1,M,1\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,BETTY,W,FOX,2,6261933,4092010,820 E. 8th Ave.,,New Smyrna Beach,FL,32169,3864284353,699010M,7,11,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,491.2,427.31,300,V46.2,V10.43,M,2,M,5,1,1,2,1,1,M,1\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,MAYBELLE,,WILSON,2,12261928,2122009,640 Fremont Ave,,Daytona Beach,FL,32114,3862522371,167111M,23,28,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,555.9,356.9,438.89,728.87,276.51,V58.81,2,M,2,0,0,4,0,1,M,1\r\n";
        }

        private static XDocument GetParsedSample1File()
        {
            return CmsCsvParser.Parse(new ClientDetail(), "file.csv", GetSample1File());
        }

        private static XElement GetMetadataRowForSample1File()
        {
            var xml = GetParsedSample1File();
            return ParserTestHelper.GetMetadataRow(xml);
        }

        private static XElement GetMetadataElementForSample1File(string field)
        {
            var metadata = GetMetadataRowForSample1File();
            return ParserTestHelper.GetElement(metadata, field);
        }

        private static IEnumerable<XElement> GetRowsForSample1File()
        {
            var xml = GetParsedSample1File();
            return ParserTestHelper.GetRows(xml);
        }

        private static XElement GetRowsElementForSample1File(string field, int rowNumber)
        {
            var row = GetRowsForSample1File().ElementAt(rowNumber);
            return ParserTestHelper.GetElement(row, field);
        }

        private static void AssertSample1FileMetadataHasField(string field, string value)
        {
            var element = ParserTestHelper.GetElement(GetMetadataRowForSample1File(), field);
            Assert.IsNotNull(element);
            Assert.AreEqual(value, element.Value);
        }

        private static void AssertSample1FileRowsHaveField(string field, params string[] values)
        {
            for (var i = 0; i < values.Length; i++)
            {
                var element = GetRowsElementForSample1File(field, i);
                Assert.IsNotNull(element);
                Assert.AreEqual(values[i], element.Value);
            }
        }

        #endregion Helpers

        #region Parse

        #region Sample1File

        [TestMethod]
        public void Parse_Sample1File_OneMetadataRow()
        {
            var xml = GetParsedSample1File();
            var metadataRows = ParserTestHelper.GetMetadataRows(xml);
            Assert.AreEqual(1, metadataRows.Count());
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasId1()
        {
            var metadata = GetMetadataRowForSample1File();
            Assert.AreEqual("1", metadata.Attribute(ExtractHelper.IdAttributeName).Value);
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasMonth()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.MonthField, "6");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasYear()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.YearField, "2010");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderId()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.ProviderIdField, "107207");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderName()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.ProviderNameField, "NURSE ON CALL INC.");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNpi()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.NpiField, "1558306159");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.TotalPatientsServedField, "730");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNumberOfBranches()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.NumberOfBranchesField, "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasVersionNumber()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.VersionNumberField, "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHave4Records()
        {
            var rows = GetRowsForSample1File();
            Assert.AreEqual(4, rows.Count());
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePatientId()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientIDField, "689311M", "698711M", "699010M", "167111M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMedicalRecordNumber()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.MedicalRecordNumberField, "689311M", "698711M", "699010M", "167111M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveFirstName()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientFirstNameField, "GEORGE", "CHARLES", "BETTY", "MAYBELLE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMiddleInitial()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMiddleInitialField, "J", "M", "W", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLastName()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientLastNameField, "BURKE", "BENTZLEY", "FOX", "WILSON");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress1()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMailingAddress1Field, "4 Woodholm Lane", "138 Wellstone Drive", "820 E. 8th Ave.", "640 Fremont Ave");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMailingAddress2Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCity()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressCityField, "Palm Coast", "Palm Coast", "New Smyrna Beach", "Daytona Beach");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveState()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressStateField, "FL", "FL", "FL", "FL");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveZip()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressZipCodeField, "32164", "32164", "32169", "32114");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhone()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.TelephoneNumberincludingareacodeField, "3864469610", "3863160540", "3864284353", "3862522371");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveGender()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.GenderField, "1", "1", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDateOfBirth()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientDateofBirthField, "06181941", "08101939", "06261933", "12261928");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLanguage()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.LanguageField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveStartOfCareDate()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.StartofCareDateField, "04052010", "04092010", "04092010", "02122009");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.NumberofskilledvisitsField, "15", "8", "7", "23");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLookbackSkilledVisits()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.LookbackPeriodVisitsField, "47", "19", "11", "28");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerNone()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerNoneField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareFFS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicareFFSField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareHMO()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicareHMOField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicaidFFS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicaidFFSField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicaidHMO()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicaidHMOField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerWorkersComp()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerWorkersCompField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerTitlePrograms()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerTitleprogramsField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerOtherGovt()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerOtherGovernmentField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerPrivateIns()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerPrivateInsField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerPrivateHMO()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerPrivateHMOField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerPrivateSelf()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerSelfpayField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerOther()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerOtherField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerUnknown()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerUnknownField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDeceasedIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DeceasedIndicatorField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHospiceIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HospiceIndicatorField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMaternityCareOnlyIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.MaternityCareOnlyIndicatorField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveBranchID()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.BranchIDField, "P", "P", "P", "P");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthVisitType()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HomeHealthVisitTypeField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAssessmentReason()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AssessmentReasonField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDischargeDate()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DischargeDateField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceNFField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceSNF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceSNFField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceIPPSField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceLTCHField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIRF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceIRFField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourcePysch()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourcePyschField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceOther()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceOtherField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceNACommunityField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceUnknownField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHMOIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HMOIndicatorField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertSample1FileRowsHaveField(ExtractHelper.DuallyeligibleforMedicareandMedicaidField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PrimaryDiagnosisICD_A2Field, "998.83", "345.9", "491.2", "555.9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryPaymentDiagnosisICD_A3()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PrimaryPaymentDiagnosisICD_A3Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryPaymentDiagnosisICD_A4()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PrimaryPaymentDiagnosisICD_A4Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_B2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_B2Field, "", "", "427.31", "356.9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_B3()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_B3Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_B4()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_B4Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_C2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_C2Field, "401.9", "401.9", "", "438.89");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_C3()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_C3Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_C4()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_C4Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_D2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_D2Field, "", "", "V46.2", "728.87");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_D3()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_D3Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_D4()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_D4Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_E2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_E2Field, "715.9", "294.1", "V10.43", "276.51");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_E3()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_E3Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_E4()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_E4Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_F2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_F2Field, "443.9", "272.4", "", "V58.81");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_F3()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_F3Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_F4()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OtherPaymentDiagnosisICD_F4Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSurgicalDischarge()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SurgicalDischargeField, "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.EndStageRenalDiseaseESRDField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDialysisIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DialysisIndicatorField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveReferralSource()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ReferralSourceField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSkilledNursing()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SkilledNursingField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhysicalTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PhysicalTherapyField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthAide()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HomeHealthAideField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSocialService()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SocialServiceField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOccupationalTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OccupationalTherapyField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCompanionHomemaker()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.CompanionHomemakerField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSpeechTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SpeechTherapyField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressUpper()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_DressUpperField, "1", "1", "1", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressLower()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_DressLowerField, "2", "2", "1", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Bathing()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_BathingField, "5", "2", "2", "4");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Toileting()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_ToiletingField, "0", "1", "1", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Transferring()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_TransferringField, "0", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Feed()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_FeedField, "M", "M", "M", "M");
        }

        #endregion Sample1File

        [TestMethod]
        public void Parse_BlankLine_LineIsSkipped()
        {
            const string fileContents =
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M,1\r\n" +
                "\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,CHARLES,M,BENTZLEY,1,8101939,4092010,138 Wellstone Drive,,Palm Coast,FL,32164,3863160540,698711M,8,19,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,345.9,250,401.9,414,294.1,272.4,2,M,5,1,2,2,1,1,M,1\r\n";
            var xml = CmsCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_LineWithOnlyCommas_LineIsSkipped()
        {
            const string fileContents =
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M,1\r\n" +
                ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,CHARLES,M,BENTZLEY,1,8101939,4092010,138 Wellstone Drive,,Palm Coast,FL,32164,3863160540,698711M,8,19,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,345.9,250,401.9,414,294.1,272.4,2,M,5,1,2,2,1,1,M,1\r\n";
            var xml = CmsCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_ExtraColumns_ExtraColumnsAreIgnored()
        {
            const string fileContents =
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M,1,extra\r\n" +
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M,1,\r\n";
            var xml = CmsCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_TooFewColumns_MissingColumnsAreBlank()
        {
            const string fileContents =
                "P,NURSE ON CALL INC.,107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M";
            var xml = CmsCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(1, rows.Count());
            var element = ParserTestHelper.GetElement(rows.First(), "Language");
            Assert.IsNotNull(element);
            Assert.AreEqual("", element.Value);
        }

        [TestMethod]
        public void Parse_EmptyFile_NoExceptions()
        {
            var xml = CmsCsvParser.Parse(new ClientDetail(), "file.csv", "");
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(0, rows.Count());
        }

        [TestMethod]
        public void Parse_ProviderNameHasComma_ProviderNameParses()
        {
            const string fileContents =
                "P,\"NURSE ON CALL, INC.\",107207,1558306159,6,2010,730,290,GEORGE,J,BURKE,1,6181941,4052010,4 Woodholm Lane,,Palm Coast,FL,32164,3864469610,689311M,15,47,,,,,,,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,998.83,250,401.9,414,715.9,443.9,1,M,3,1,2,5,0,0,M,1";
            var xml = CmsCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var metadata = ParserTestHelper.GetMetadataRow(xml);
            var element = ParserTestHelper.GetElement(metadata, ExtractHelper.ProviderNameField);

            Assert.IsNotNull(element);
            Assert.AreEqual("NURSE ON CALL, INC.", element.Value);
        }

        #endregion Parse
    }
}
