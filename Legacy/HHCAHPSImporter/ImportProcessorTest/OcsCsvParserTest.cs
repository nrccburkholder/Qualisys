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
            AssertSample1FileMetadataHasField(ExtractHelper.ProviderIdField, "58110");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderName()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.ProviderNameField, "New Haven Home Health and Hospice Inc.");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNpi()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.NpiField, "1881609436");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.TotalPatientsServedField, "192");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasNumberOfBranches()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.NumberOfBranchesField, "");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasVersionNumber()
        {
            AssertSample1FileMetadataHasField(ExtractHelper.VersionNumberField, "1.1");
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
            AssertSample1FileRowsHaveField(ExtractHelper.PatientIDField, "2004-816", "2010-5030", "2010-5097", "2010-5029");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMedicalRecordNumber()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.MedicalRecordNumberField, "2004-817", "2010-5030", "2010-5097", "2010-5029");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveFirstName()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientFirstNameField, "Paul", "JEAN", "MARIA", "MARY");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMiddleInitial()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMiddleInitialField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLastName()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientLastNameField, "Abuda", "ABBOTT", "ABELLA", "ADAMS");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress1()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMailingAddress1Field, "417 Templeton Ave", "1519 ADOBE DRIVE", "391 30TH AVE", "2640 MUIRFIELD CIRCLE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientMailingAddress2Field, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCity()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressCityField, "DALY CITY", "PACIFICA", "SAN FRANCISCO", "SAN BRUNO");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveState()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressStateField, "CA", "CA", "CA", "CA");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveZip()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientAddressZipCodeField, "94014", "94044", "94121", "94066");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhone()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.TelephoneNumberincludingareacodeField, "4159941519", "9168066600", "4153864538", "6504839997");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveGender()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.GenderField, "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDateOfBirth()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PatientDateofBirthField, "06291931", "03021925", "09121940", "11251921");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLanguage()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.LanguageField, "M", "1", "M", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveStartOfCareDate()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.StartofCareDateField, "05192010", "06102010", "05202010", "04222010");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.NumberofskilledvisitsField, "3", "7", "3", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLookbackSkilledVisits()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.LookbackPeriodVisitsField, "7", "11", "11", "13");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerNone()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerNoneField, "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareFFS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicareFFSField, "0", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareHMO()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PayerMedicareHMOField, "1", "0", "0", "0");
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
            AssertSample1FileRowsHaveField(ExtractHelper.PayerUnknownField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDeceasedIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DeceasedIndicatorField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHospiceIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HospiceIndicatorField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMaternityCareOnlyIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.MaternityCareOnlyIndicatorField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveBranchID()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.BranchIDField, "N", "N", "N", "N");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthVisitType()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HomeHealthVisitTypeField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAssessmentReason()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AssessmentReasonField, "6", "1", "9", "9");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDischargeDate()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DischargeDateField, "06022010", "", "06052010", "06102010");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceNFField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceSNF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceSNFField, "", "1", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceIPPSField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceLTCHField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIRF()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceIRFField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourcePysch()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourcePyschField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceOther()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceOtherField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceNACommunityField, "", "0", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.AdmissionSourceUnknownField, "1", "0", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHMOIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HMOIndicatorField, "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertSample1FileRowsHaveField(ExtractHelper.DuallyeligibleforMedicareandMedicaidField, "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PrimaryDiagnosisICD_A2Field, "", "", "", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_B2Field, "", "294.1", "", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_C2Field, "", "", "", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_D2Field, "", "403.9", "", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_E2Field, "", "585.3", "", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.Otherdiagnosis_F2Field, "", "728.87", "", "");
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
            AssertSample1FileRowsHaveField(ExtractHelper.SurgicalDischargeField, "M", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.EndStageRenalDiseaseESRDField, "M", "2", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDialysisIndicator()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.DialysisIndicatorField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveReferralSource()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ReferralSourceField, "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSkilledNursing()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SkilledNursingField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhysicalTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.PhysicalTherapyField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthAide()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.HomeHealthAideField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSocialService()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SocialServiceField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOccupationalTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.OccupationalTherapyField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCompanionHomemaker()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.CompanionHomemakerField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSpeechTherapy()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.SpeechTherapyField, "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressUpper()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_DressUpperField, "M", "2", "0", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressLower()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_DressLowerField, "M", "2", "0", "3");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Bathing()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_BathingField, "M", "3", "1", "3");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Toileting()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_ToiletingField, "M", "1", "0", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Transferring()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_TransferringField, "M", "1", "0", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Feed()
        {
            AssertSample1FileRowsHaveField(ExtractHelper.ADL_FeedField, "M", "1", "0", "0");
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

        [TestMethod]
        public void Parse_TooFewColumns_MissingColumnsAreBlank()
        {
            const string fileContents =
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number\r\n" +
                "6,2010,58110,New Haven Home Health and Hospice Inc.,1881609436,192,,1.1\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M";
            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(1, rows.Count());
            var element = ParserTestHelper.GetElement(rows.First(), "ADL_Feed");
            Assert.IsNotNull(element);
            Assert.AreEqual("", element.Value);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void Parse_EmptyFile_InvalidOperationExceptionIsThrown()
        {
            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", "", false);
        }

        [TestMethod]
        public void Parse_ProviderNameHasComma_ProviderNameParses()
        {
            const string fileContents =
                "Sample Month,Sample Year,Provider ID,Provider Name,NPI,Total number of patients served,Number of branches served,Version Number\r\n" +
                "6,2010,58110,\"New Haven Home Health and Hospice, Inc.\",1881609436,192,8,1.1\r\n" +
                "PatientCode,Medical Number,PatientFirstName,PatientMiddleInitial,PatientLastName,PatientAddress1,PatientAddress2,PatientCity,PatientState,PatientZipCode,PatientTelephone,PatientGender,PatientBirthdate,PrimaryLanguage,START_CARE_DT,NumberOfSkilledVisits,NumberOfSkilledVisits_IncludingLookBack,CPAY_NONE,CPAY_MCARE_FFS,CPAY_MCARE_HMO,CPAY_MCAID_FFS,CPAY_MCAID_HMO,CPAY_WRKCOMP,CPAY_TITLEPGMS,CPAY_OTH_GOVT,CPAY_PRIV_INS,CPAY_PRIV_HMO,CPAY_SELFPAY,CPAY_OTHER,CPAY_UNKNOWN,Deceased,Hospice,Maternity Care Only,BRANCH_ID,Home Health Visit Type,ASSMT_REASON,DC_TRAN_DTH_DT,M1000_DC_LTC_14_DA,M1000_DC_SNF_14_DA,M1000_DC_IPPS_14_DA,M1000_DC_LTCH_14_DA,M1000_DC_IRF_14_DA,M1000_DC_PSYCH_14_DA,M1000_DC_OTH_14_DA,M1000_DC_NONE_14_DA,AdmissionSourceUnknown,IsHMO,EligibleMedicareAndMedicaid,PRIMARY_DIAG_ICD,PMT_DIAG_ICD_A3,PMT_DIAG_ICD_A4,OTH_DIAG1_ICD,PMT_DIAG_ICD_B3,PMT_DIAG_ICD_B4,OTH_DIAG2_ICD,PMT_DIAG_ICD_C3,PMT_DIAG_ICD_C4,OTH_DIAG3_ICD,PMT_DIAG_ICD_D3,PMT_DIAG_ICD_D4,OTH_DIAG4_ICD,PMT_DIAG_ICD_E3,PMT_DIAG_ICD_E4,OTH_DIAG5_ICD,PMT_DIAG_ICD_F3,PMT_DIAG_ICD_F4,SurgicalDischarge,HasEndStageRenalDisease,DialysisIndicator,ReferralSource,SkilledNursing,PhysicalTherapy,HomeHealthAide,SocialService,OccupationalTherapy,CompanionHomemaker,SpeechTherapy,CUR_DRESS_UPPER,CUR_DRESS_LOWER,CRNT_BATHG,CUR_TOILTG,CUR_TRNSFRNG,CUR_FEEDING\r\n" +
                "2004-816,2004-817,Paul,,Abuda,417 Templeton Ave,,DALY CITY,CA,94014,4159941519,1,6291931,M,5192010,3,7,0,0,1,0,0,0,0,0,0,0,0,0,,2,2,2,N,2,6,20100602,,,,,,,,,1,1,2,,,,,,,,,,,,,,,,,,,M,M,M,,M,M,M,M,M,M,M,M,M,M";
            var xml = OcsPtctCsvParser.Parse(new ClientDetail(), "file.csv", fileContents, false);
            var metadata = ParserTestHelper.GetMetadataRow(xml);
            var element = ParserTestHelper.GetElement(metadata, ExtractHelper.ProviderNameField);

            Assert.IsNotNull(element);
            Assert.AreEqual("New Haven Home Health and Hospice, Inc.", element.Value);
        }

        #endregion Parse
    }
}
