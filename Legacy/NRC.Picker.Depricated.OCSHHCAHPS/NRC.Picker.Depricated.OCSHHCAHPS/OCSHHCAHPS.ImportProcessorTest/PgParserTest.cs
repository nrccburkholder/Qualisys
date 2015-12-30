using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Xml.Linq;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using System.Collections.Generic;
using System.Linq;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class PgParserTest
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
            return PgCsvParser.Parse(new ClientDetail(), "file.csv", GetSample1File());
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
            Assert.AreEqual("1", metadata.Attribute("id").Value);
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasMonth()
        {
            AssertSample1FileMetadataHasField("MONTH", "6");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasYear()
        {
            AssertSample1FileMetadataHasField("YEAR", "2010");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderId()
        {
            AssertSample1FileMetadataHasField("PROVIDER ID", "147714");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderName()
        {
            AssertSample1FileMetadataHasField("PROVIDER NAME", "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertSample1FileMetadataHasField("TOTAL NUMBER OF PATIENT SERVED", "298");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNumberOfBranches()
        {
            AssertSample1FileMetadataHasField("NUMBER OF BRANCHES", "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasVersionNumber()
        {
            AssertSample1FileMetadataHasField("VERSION NUMBER", "");
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
            AssertSample1FileRowsHaveField("Patient ID", "JA1560", "JA2506", "FA3172", "JB2619");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMedicalRecordNumber()
        {
            AssertSample1FileRowsHaveField("Medical Record Number", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveFirstName()
        {
            AssertSample1FileRowsHaveField("Patient First Name", "JUAN", "JULIES", "FELIX", "JESSIE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMiddleInitial()
        {
            AssertSample1FileRowsHaveField("Patient Middle Initial", "J", "K", "", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLastName()
        {
            AssertSample1FileRowsHaveField("Patient Last Name", "ANDRADE", "ANWIYA", "ARES", "BAILEY");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress1()
        {
            AssertSample1FileRowsHaveField("Patient Mailing Address 1", "6970 N. WOLCOTT AVE", "6607 N. SEELEY AVENUE", "9356 SHERMER", "415 51st AVENUE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress2()
        {
            AssertSample1FileRowsHaveField("Patient Mailing Address 2", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCity()
        {
            AssertSample1FileRowsHaveField("Patient Address City", "CHICAGO", "CHICAGO", "MORTON GROVE", "BELLWOOD");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveState()
        {
            AssertSample1FileRowsHaveField("Patient Address State", "IL", "IL", "IL", "IL");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveZip()
        {
            AssertSample1FileRowsHaveField("Patient Address Zip Code", "60626", "60645", "60053", "60104");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhone()
        {
            AssertSample1FileRowsHaveField("Telephone Number including area code", "7732627035", "7737618103", "8476738373", "7085479908");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveGender()
        {
            AssertSample1FileRowsHaveField("Gender", "1", "2", "1", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDateOfBirth()
        {
            AssertSample1FileRowsHaveField("Patient Date of Birth", "10281944", "07011935", "09051960", "03071945");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLanguage()
        {
            AssertSample1FileRowsHaveField("Language", "1", "", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveStartOfCareDate()
        {
            AssertSample1FileRowsHaveField("Start of Care Date", "02262010", "06162010", "06202010", "04062010");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertSample1FileRowsHaveField("Number of skilled visits", "4", "1", "1", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLookbackSkilledVisits()
        {
            AssertSample1FileRowsHaveField("Lookback Period Visits", "3", "0", "0", "4");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerNone()
        {
            AssertSample1FileRowsHaveField("Payer - None", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareFFS()
        {
            AssertSample1FileRowsHaveField("Payer - Medicare FFS", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareHMO()
        {
            AssertSample1FileRowsHaveField("Payer - Medicare HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicaidFFS()
        {
            AssertSample1FileRowsHaveField("Payer - Medicaid FFS", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicaidHMO()
        {
            AssertSample1FileRowsHaveField("Payer - Medicaid HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerWorkersComp()
        {
            AssertSample1FileRowsHaveField("Payer - Workers Comp", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerTitlePrograms()
        {
            AssertSample1FileRowsHaveField("Payer - Title programs", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerOtherGovt()
        {
            AssertSample1FileRowsHaveField("Payer - Other Government", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerPrivateIns()
        {
            AssertSample1FileRowsHaveField("Payer - Private Ins", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerPrivateHMO()
        {
            AssertSample1FileRowsHaveField("Payer - Private HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerPrivateSelf()
        {
            AssertSample1FileRowsHaveField("Payer - Self-pay", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerOther()
        {
            AssertSample1FileRowsHaveField("Payer - Other", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerUnknown()
        {
            AssertSample1FileRowsHaveField("Payer - Unknown", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDeceasedIndicator()
        {
            AssertSample1FileRowsHaveField("Deceased Indicator", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHospiceIndicator()
        {
            AssertSample1FileRowsHaveField("Hospice Indicator", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMaternityCareOnlyIndicator()
        {
            AssertSample1FileRowsHaveField("Maternity Care Only Indicator", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveBranchID()
        {
            AssertSample1FileRowsHaveField("Branch ID", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthVisitType()
        {
            AssertSample1FileRowsHaveField("Home Health Visit Type", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAssessmentReason()
        {
            AssertSample1FileRowsHaveField("Assessment Reason", "4", "1", "1", "4");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDischargeDate()
        {
            AssertSample1FileRowsHaveField("Discharge Date", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNF()
        {
            AssertSample1FileRowsHaveField("Admission Source - NF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceSNF()
        {
            AssertSample1FileRowsHaveField("Admission Source - SNF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertSample1FileRowsHaveField("Admission Source - IPP S", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertSample1FileRowsHaveField("Admission Source - LTCH", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIRF()
        {
            AssertSample1FileRowsHaveField("Admission Source - IRF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourcePysch()
        {
            AssertSample1FileRowsHaveField("Admission Source - Pysch", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceOther()
        {
            AssertSample1FileRowsHaveField("Admission Source - Other", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertSample1FileRowsHaveField("Admission Source - NA (Community)", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertSample1FileRowsHaveField("Admission Source - Unknown", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHMOIndicator()
        {
            AssertSample1FileRowsHaveField("HMO Indicator", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertSample1FileRowsHaveField("Dually eligible for Medicare and Medicaid?", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertSample1FileRowsHaveField("Primary Diagnosis ICD_A2", "716.99", "716.99", "716.96", "401.9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryPaymentDiagnosisICD_A3()
        {
            AssertSample1FileRowsHaveField("Primary Payment Diagnosis ICD_A3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryPaymentDiagnosisICD_A4()
        {
            AssertSample1FileRowsHaveField("Primary Payment Diagnosis ICD_A4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_B2()
        {
            AssertSample1FileRowsHaveField("Other diagnosis_B2", "403.91", "719.7", "401.9", "716.86");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_B3()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis  ICD_B3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_B4()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis ICD_B4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_C2()
        {
            AssertSample1FileRowsHaveField("Other diagnosis_C2", "585.6", "401.9", "780.79", "477.9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_C3()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis  ICD_C3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_C4()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis ICD_C4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_D2()
        {
            AssertSample1FileRowsHaveField("Other diagnosis_D2", "285.21", "780.79", "535.5", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_D3()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis  ICD_D3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_D4()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis ICD_D4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_E2()
        {
            AssertSample1FileRowsHaveField("Other diagnosis_E2", "414.01", "", "345.3", "244.9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_E3()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis  ICD_E3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_E4()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis ICD_E4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherdiagnosis_F2()
        {
            AssertSample1FileRowsHaveField("Other diagnosis_F2", "493.9", "", "300.02", "174.9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_F3()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis  ICD_F3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOtherPaymentDiagnosisICD_F4()
        {
            AssertSample1FileRowsHaveField("Other Payment Diagnosis ICD_F4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSurgicalDischarge()
        {
            AssertSample1FileRowsHaveField("Surgical Discharge", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertSample1FileRowsHaveField("End-Stage Renal Disease (ESRD)", "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDialysisIndicator()
        {
            AssertSample1FileRowsHaveField("Dialysis Indicator", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveReferralSource()
        {
            AssertSample1FileRowsHaveField("Referral Source", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSkilledNursing()
        {
            AssertSample1FileRowsHaveField("Skilled Nursing", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhysicalTherapy()
        {
            AssertSample1FileRowsHaveField("Physical Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthAide()
        {
            AssertSample1FileRowsHaveField("Home Health Aide", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSocialService()
        {
            AssertSample1FileRowsHaveField("Social Service", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOccupationalTherapy()
        {
            AssertSample1FileRowsHaveField("Occupational Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCompanionHomemaker()
        {
            AssertSample1FileRowsHaveField("Companion/Homemaker", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSpeechTherapy()
        {
            AssertSample1FileRowsHaveField("Speech Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressUpper()
        {
            AssertSample1FileRowsHaveField("ADL_Dress Upper", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressLower()
        {
            AssertSample1FileRowsHaveField("ADL_Dress Lower", "1", "2", "2", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Bathing()
        {
            AssertSample1FileRowsHaveField("ADL_Bathing", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Toileting()
        {
            AssertSample1FileRowsHaveField("ADL_Toileting", "0", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Transferring()
        {
            AssertSample1FileRowsHaveField("ADL_Transferring", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Feed()
        {
            AssertSample1FileRowsHaveField("ADL_Feed", "", "", "", "");
        }

        #endregion Sample1File

        [TestMethod]
        public void Parse_NoDollarSignAtEnd_StillParses()
        {
            const string fileContents = 
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298\r\n" +
                "OCS,147714,JUAN,J,ANDRADE,6970 N. WOLCOTT AVE,,CHICAGO,IL,60626,7732627035,2,2/26/2010,4,,10/28/1944,0,1,JA1560,2,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,716.99,403.91,585.6,285.21,414.01,493.9,1,2,2,2,2,2,2,1,1,2,0,1,,4,7,6,2010,,,298,";
            var xml = PgCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
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
            var xml = PgCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
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
            var xml = PgCsvParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        #endregion Parse
    }
}
