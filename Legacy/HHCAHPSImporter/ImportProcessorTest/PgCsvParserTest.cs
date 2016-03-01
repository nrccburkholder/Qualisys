using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Xml.Linq;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using HHCAHPSImporter.ImportProcessor.Extractors;
using System.Collections.Generic;
using System.Linq;

namespace HHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class PgCsvParserTest
    {
        #region Helpers

        private static string GetSample1File()
        {
            return
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,$\r\n" +
                "OCS,147714,JULIES,K,ANWIYA,6607 N. SEELEY AVENUE,,CHICAGO,IL,60645,7737618103,2,6/16/2010,1,,7/1/1935,,2,JA2506,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,719.7,401.9,780.79,272,,1,2,2,2,2,2,2,1,2,2,1,1,,1,1,6,2010,,,298,$\r\n" +
                "OCS,147714,FELIX,,ARES,9356 SHERMER,,MORTON GROVE,IL,60053,8476738373,2,6/20/2010,1,,9/5/1960,1,1,FA3172,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.96,401.9,780.79,535.5,345.3,300.02,1,2,2,2,2,2,2,1,2,2,1,1,,1,1,6,2010,,,298,$\r\n" +
                "OCS,147714,JESSIE,M,BAILEY,415 51st AVENUE,,BELLWOOD,IL,60104,7085479908,2,4/6/2010,4,,3/7/1945,1,2,JB2619,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,401.9,716.86,477.9,272,244.9,174.9,1,2,2,2,2,2,2,1,1,2,1,1,,2,6,6,2010,,,298,$\r\n";
        }

        private static XDocument GetParsedSample1File()
        {
            return PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", GetSample1File());
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
            AssertSample1FileMetadataHasField(ExtractHelper.ProviderIdField, "147714");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderName()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.ProviderNameField, "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNpi()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.NpiField, "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.TotalPatientsServedField, "298");
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
            AssertSample1FileRowsHaveField(ExtractHelper.PatientIDField, "JA1560", "JA2506", "FA3172", "JB2619");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMedicalRecordNumber()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.MedicalRecordNumberField, "JA1560", "JA2506", "FA3172", "JB2619");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveFirstName()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientFirstNameField, "JUAN", "JULIES", "FELIX", "JESSIE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMiddleInitial()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMiddleInitialField, "J", "K", "", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLastName()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientLastNameField, "ANDRADE", "ANWIYA", "ARES", "BAILEY");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress1()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMailingAddress1Field, "6970 N. WOLCOTT AVE", "6607 N. SEELEY AVENUE", "9356 SHERMER", "415 51st AVENUE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMailingAddress2Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCity()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressCityField, "CHICAGO", "CHICAGO", "MORTON GROVE", "BELLWOOD");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveState()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressStateField, "IL", "IL", "IL", "IL");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveZip()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressZipCodeField, "60626", "60645", "60053", "60104");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhone()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.TelephoneNumberincludingareacodeField, "7732627035", "7737618103", "8476738373", "7085479908");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveGender()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.GenderField, "1", "2", "1", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDateOfBirth()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientDateofBirthField, "10281944", "07011935", "09051960", "03071945");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLanguage()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.LanguageField, "1", "", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveStartOfCareDate()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.StartofCareDateField, "02262010", "06162010", "06202010", "04062010");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.NumberofskilledvisitsField, "4", "1", "1", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLookbackSkilledVisits()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.LookbackPeriodVisitsField, "3", "0", "0", "4");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerNone()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerNoneField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareFFS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicareFFSField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareHMO()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicareHMOField, "0", "0", "0", "0");
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
            AssertSample1FileRowsHaveField(ExtractHelper.BranchIDField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthVisitType()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HomeHealthVisitTypeField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAssessmentReason()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AssessmentReasonField, "4", "1", "1", "4");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDischargeDate()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DischargeDateField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceNFField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceSNF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceSNFField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceIPPSField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceLTCHField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIRF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceIRFField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourcePysch()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourcePyschField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceOther()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceOtherField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceNACommunityField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceUnknownField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHMOIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HMOIndicatorField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertSample1FileRowsHaveField(ExtractHelper.DuallyeligibleforMedicareandMedicaidField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PrimaryDiagnosisICD_A2Field, "716.99", "716.99", "716.96", "401.9");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_B2Field, "403.91", "719.7", "401.9", "716.86");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_C2Field, "585.6", "401.9", "780.79", "477.9");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_D2Field, "285.21", "780.79", "535.5", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_E2Field, "414.01", "", "345.3", "244.9");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_F2Field, "493.9", "", "300.02", "174.9");
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
            AssertSample1FileRowsHaveField(ExtractHelper.SurgicalDischargeField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.EndStageRenalDiseaseESRDField, "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDialysisIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DialysisIndicatorField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveReferralSource()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ReferralSourceField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSkilledNursing()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SkilledNursingField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhysicalTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PhysicalTherapyField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthAide()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HomeHealthAideField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSocialService()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SocialServiceField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOccupationalTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OccupationalTherapyField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCompanionHomemaker()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.CompanionHomemakerField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSpeechTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SpeechTherapyField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressUpper()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_DressUpperField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressLower()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_DressLowerField, "1", "2", "2", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Bathing()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_BathingField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Toileting()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_ToiletingField, "0", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Transferring()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_TransferringField, "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Feed()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_FeedField, "", "", "", "");
        }

        #endregion Sample1File

        [TestMethod]
        public void Parse_NoDollarSignAtEnd_StillParses()
        {
            const string fileContents = 
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298\r\n" +
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,";
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_BlankLine_LineIsSkipped()
        {
            const string fileContents =
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,$\r\n" +
                "\r\n" +
                "OCS,147714,FELIX,,ARES,9356 SHERMER,,MORTON GROVE,IL,60053,8476738373,2,6/20/2010,1,,9/5/1960,1,1,FA3172,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.96,401.9,780.79,535.5,345.3,300.02,1,2,2,2,2,2,2,1,2,2,1,1,,1,1,6,2010,,,298,$";
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_LineWithOnlyCommas_LineIsSkipped()
        {
            const string fileContents =
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,$\r\n" +
                ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "OCS,147714,FELIX,,ARES,9356 SHERMER,,MORTON GROVE,IL,60053,8476738373,2,6/20/2010,1,,9/5/1960,1,1,FA3172,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.96,401.9,780.79,535.5,345.3,300.02,1,2,2,2,2,2,2,1,2,2,1,1,,1,1,6,2010,,,298,$";
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_ExtraColumns_ExtraColumnsAreIgnored()
        {
            const string fileContents =
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,$,extra\r\n" +
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,$,\r\n";
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_TooFewColumns_MissingColumnsAreBlank()
        {
            const string fileContents =
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,";
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", fileContents);
            var rows = ParserTestHelper.GetMetadataRow(xml);
            var element = ParserTestHelper.GetElement(rows, "TOTAL NUMBER OF PATIENT SERVED");
            Assert.IsNotNull(element);
            Assert.AreEqual("", element.Value);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void Parse_EmptyFile_InvalidOperationException()
        {
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", "");
        }

        [TestMethod]
        public void Parse_AddressHasComma_ProviderNameParses()
        {
            const string fileContents =
                "OCS,147714,JUAN,J,ANDRADE,\"6970 N. WOLCOTT, AVE\",,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,$";
            var xml = PgCsvParser.Parse(new ClientDetail { CCN = "147714" }, "HHCAHPS_147714_1.csv", fileContents);

            var row = ParserTestHelper.GetRows(xml).ElementAt(0);
            var element = ParserTestHelper.GetElement(row, ExtractHelper.PatientMailingAddress1Field);

            Assert.IsNotNull(element);
            Assert.AreEqual("6970 N. WOLCOTT, AVE", element.Value);
        }

        #endregion Parse
    }
}
