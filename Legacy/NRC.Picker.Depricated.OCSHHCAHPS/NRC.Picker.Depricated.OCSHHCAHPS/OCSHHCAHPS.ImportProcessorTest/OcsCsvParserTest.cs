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
    public class OcsCsvParserTest
    {
        #region Helpers

        private static string GetSample1File()
        {
            return
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n" +
                "2010-5030,2010-5030,JEAN,,ABBOTT,1519 ADOBE DRIVE,,PACIFICA,CA,94044,9168066600,2,3021925,1,6102010,7,11,0,1,0,0,0,0,0,0,0,0,0,0,0,2,2,2,N,2,1,,0,1,0,0,0,0,0,0,0,2,2,331,,,294.1,,,300,,,403.9,,,585.3,,,728.87,,,2,2,M,,M,M,M,M,M,M,M,2,2,3,1,1,1\r\n" +
                "2010-5097,2010-5097,MARIA,,ABELLA,391 30TH AVE,,SAN FRANCISCO,CA,94121,4153864538,2,9121940,M,5202010,3,11,0,1,0,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,9,20100605,,,,,,,,,1,2,2,,,,,,,,,,,,,,,,,,,2,M,M,,M,M,M,M,M,M,M,0,0,1,0,0,0\r\n" +
                "2010-5029,2010-5029,MARY,,ADAMS,2640 MUIRFIELD CIRCLE,,SAN BRUNO,CA,94066,6504839997,2,11251921,1,4222010,2,13,0,1,0,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,9,20100610,,,,,,,,,1,2,2,,,,,,,,,,,,,,,,,,,2,M,M,,M,M,M,M,M,M,M,2,3,3,1,1,0\r\n";
        }
        
        private static XDocument GetParsedSample1File()
        {
            return OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", GetSample1File(), false);
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
            AssertSample1FileMetadataHasField("PROVIDER ID", "58110");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderName()
        {
            AssertSample1FileMetadataHasField("PROVIDER NAME", "New Haven Home Health and Hospice Inc.");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertSample1FileMetadataHasField("TOTAL NUMBER OF PATIENT SERVED", "192");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNumberOfBranches()
        {
            AssertSample1FileMetadataHasField("NUMBER OF BRANCHES", "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasVersionNumber()
        {
            AssertSample1FileMetadataHasField("VERSION NUMBER", "1.1");
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
            AssertSample1FileRowsHaveField("Patient ID", "2004-816", "2010-5030", "2010-5097", "2010-5029");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMedicalRecordNumber()
        {
            AssertSample1FileRowsHaveField("Medical Record Number", "2004-817", "2010-5030", "2010-5097", "2010-5029");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveFirstName()
        {
            AssertSample1FileRowsHaveField("Patient First Name", "Paul", "JEAN", "MARIA", "MARY");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMiddleInitial()
        {
            AssertSample1FileRowsHaveField("Patient Middle Initial", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLastName()
        {
            AssertSample1FileRowsHaveField("Patient Last Name", "Abuda", "ABBOTT", "ABELLA", "ADAMS");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress1()
        {
            AssertSample1FileRowsHaveField("Patient Mailing Address 1", "417 Templeton Ave", "1519 ADOBE DRIVE", "391 30TH AVE", "2640 MUIRFIELD CIRCLE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress2()
        {
            AssertSample1FileRowsHaveField("Patient Mailing Address 2", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCity()
        {
            AssertSample1FileRowsHaveField("Patient Address City", "DALY CITY", "PACIFICA", "SAN FRANCISCO", "SAN BRUNO");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveState()
        {
            AssertSample1FileRowsHaveField("Patient Address State", "CA", "CA", "CA", "CA");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveZip()
        {
            AssertSample1FileRowsHaveField("Patient Address Zip Code", "94014", "94044", "94121", "94066");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhone()
        {
            AssertSample1FileRowsHaveField("Telephone Number including area code", "4159941519", "9168066600", "4153864538", "6504839997");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveGender()
        {
            AssertSample1FileRowsHaveField("Gender", "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDateOfBirth()
        {
            AssertSample1FileRowsHaveField("Patient Date of Birth", "06291931", "03021925", "09121940", "11251921");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLanguage()
        {
            AssertSample1FileRowsHaveField("Language", "M", "1", "M", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveStartOfCareDate()
        {
            AssertSample1FileRowsHaveField("Start of Care Date", "05192010", "06102010", "05202010", "04222010");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertSample1FileRowsHaveField("Number of skilled visits", "3", "7", "3", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLookbackSkilledVisits()
        {
            AssertSample1FileRowsHaveField("Lookback Period Visits", "7", "11", "11", "13");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerNone()
        {
            AssertSample1FileRowsHaveField("Payer - None", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareFFS()
        {
            AssertSample1FileRowsHaveField("Payer - Medicare FFS", "0", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareHMO()
        {
            AssertSample1FileRowsHaveField("Payer - Medicare HMO", "1", "0", "0", "0");
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
            AssertSample1FileRowsHaveField("Payer - Unknown", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDeceasedIndicator()
        {
            AssertSample1FileRowsHaveField("Deceased Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHospiceIndicator()
        {
            AssertSample1FileRowsHaveField("Hospice Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMaternityCareOnlyIndicator()
        {
            AssertSample1FileRowsHaveField("Maternity Care Only Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveBranchID()
        {
            AssertSample1FileRowsHaveField("Branch ID", "N", "N", "N", "N");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthVisitType()
        {
            AssertSample1FileRowsHaveField("Home Health Visit Type", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAssessmentReason()
        {
            AssertSample1FileRowsHaveField("Assessment Reason", "6", "1", "9", "9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDischargeDate()
        {
            AssertSample1FileRowsHaveField("Discharge Date", "06022010", "", "06052010", "06102010");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNF()
        {
            AssertSample1FileRowsHaveField("Admission Source - NF", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceSNF()
        {
            AssertSample1FileRowsHaveField("Admission Source - SNF", "", "1", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertSample1FileRowsHaveField("Admission Source - IPP S", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertSample1FileRowsHaveField("Admission Source - LTCH", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIRF()
        {
            AssertSample1FileRowsHaveField("Admission Source - IRF", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourcePysch()
        {
            AssertSample1FileRowsHaveField("Admission Source - Pysch", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceOther()
        {
            AssertSample1FileRowsHaveField("Admission Source - Other", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertSample1FileRowsHaveField("Admission Source - NA (Community)", "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertSample1FileRowsHaveField("Admission Source - Unknown", "1", "0", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHMOIndicator()
        {
            AssertSample1FileRowsHaveField("HMO Indicator", "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertSample1FileRowsHaveField("Dually eligible for Medicare and Medicaid?", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertSample1FileRowsHaveField("Primary Diagnosis ICD_A2", "", "", "", "");
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
            AssertSample1FileRowsHaveField("Other diagnosis_B2", "", "294.1", "", "");
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
            AssertSample1FileRowsHaveField("Other diagnosis_C2", "", "", "", "");
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
            AssertSample1FileRowsHaveField("Other diagnosis_D2", "", "403.9", "", "");
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
            AssertSample1FileRowsHaveField("Other diagnosis_E2", "", "585.3", "", "");
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
            AssertSample1FileRowsHaveField("Other diagnosis_F2", "", "728.87", "", "");
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
            AssertSample1FileRowsHaveField("Surgical Discharge", "M", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertSample1FileRowsHaveField("End-Stage Renal Disease (ESRD)", "M", "2", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDialysisIndicator()
        {
            AssertSample1FileRowsHaveField("Dialysis Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveReferralSource()
        {
            AssertSample1FileRowsHaveField("Referral Source", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSkilledNursing()
        {
            AssertSample1FileRowsHaveField("Skilled Nursing", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhysicalTherapy()
        {
            AssertSample1FileRowsHaveField("Physical Therapy", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthAide()
        {
            AssertSample1FileRowsHaveField("Home Health Aide", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSocialService()
        {
            AssertSample1FileRowsHaveField("Social Service", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOccupationalTherapy()
        {
            AssertSample1FileRowsHaveField("Occupational Therapy", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCompanionHomemaker()
        {
            AssertSample1FileRowsHaveField("Companion/Homemaker", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSpeechTherapy()
        {
            AssertSample1FileRowsHaveField("Speech Therapy", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressUpper()
        {
            AssertSample1FileRowsHaveField("ADL_Dress Upper", "M", "2", "0", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressLower()
        {
            AssertSample1FileRowsHaveField("ADL_Dress Lower", "M", "2", "0", "3");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Bathing()
        {
            AssertSample1FileRowsHaveField("ADL_Bathing", "M", "3", "1", "3");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Toileting()
        {
            AssertSample1FileRowsHaveField("ADL_Toileting", "M", "1", "0", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Transferring()
        {
            AssertSample1FileRowsHaveField("ADL_Transferring", "M", "1", "0", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Feed()
        {
            AssertSample1FileRowsHaveField("ADL_Feed", "M", "1", "0", "0");
        }

        #endregion Sample1File

        [TestMethod]
        public void Parse_MissingHeaderHeader_MetadataIsSet()
        {
            var fileContents =
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n";

            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var metadata = ParserTestHelper.GetMetadataRow(xml);
            var element = ParserTestHelper.GetElement(metadata, "MONTH");

            Assert.IsNotNull(element);
            Assert.AreEqual("6", element.Value);
        }

        [TestMethod]
        public void Parse_MissingBodyHeader_HasRows()
        {
            var fileContents =
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n";

            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var rows = ParserTestHelper.GetRows(xml);
            
            Assert.AreEqual(1, rows.Count());
        }

        [TestMethod]
        public void Parse_HeaderNotEndedWithCommas_MetadataIsSet()
        {
            var fileContents =
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number\r\n" +
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n";

            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var metadata = ParserTestHelper.GetMetadataRow(xml);
            var element = ParserTestHelper.GetElement(metadata, "MONTH");

            Assert.IsNotNull(element);
            Assert.AreEqual("6", element.Value);
        }

        [TestMethod]
        public void Parse_BlankLine_LineIsSkipped()
        {
            const string fileContents =
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number\r\n" +
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n" +
                "\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n";
            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        [TestMethod]
        public void Parse_LineWithOnlyCommas_LineIsSkipped()
        {
            const string fileContents =
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number\r\n" +
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n" +
                ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M,M,M,M\r\n";
            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        #endregion Parse
    }
}
