using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using System.Linq;
using System.Xml.Linq;
using System.Collections.Generic;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class OcsFwParserTest
    {
        #region Helpers

        private static string GetVersion1File()
        {
            return
                "062010107189AMERICAN PROVIDERS INC                                                                              1346299955          02040041.1\r\n" +
                "N         06719               05719               EDUVIGES                       ALVAREZ                       220 WEST 74 PLACE                                 APT 209                                           HIALEAH                                           FL33014    305823440920601192012042920101        004005000000010010100000000021715.09            356.4             440.21            735.8             414.01            386.11            22M112122221121102MM%\r\n" +
                "          07519               06519               RACHEL                         JENNINGS                      760 NW 65 STREET                                                                                    MIAMI                                             FL33150    30532132712041319121203082010406242010004004000000000010000000000022599.0             041.4             788.41            530.81            356.9             715.09            22M1122222200201M2MM%\r\n" +
                "          09121               08121               DELORES                       DMCCARTNEY                     1731 NW 152 TERR                                                                                    MIAMI                                             FL33054    305688013120215193412051120101        030021000000010010000000000022153.2             197.5             571.5             789.59            V58.31      789.59250.00            22M112122222220102MM%\r\n" +
                "N         09475               08475               RAMONA                         PORTES                        2899 COLLINS AVE                                  APT 1204                                          MIAMI BEACH                                       FL33140    305672047220408191512040920094        030031000000000010000000000022250.70            443.81            331.0             787.20            V55.1             438.20            22M1121222233645M2MM%\r\n";
        }

        private static XDocument GetParsedVersion1File()
        {
            return OcsFwParser.Parse(new ClientDetail(), "file.csv", GetVersion1File());
        }

        private static XElement GetMetadataRowForVersion1File()
        {
            var xml = GetParsedVersion1File();
            return ParserTestHelper.GetMetadataRow(xml);
        }

        private static XElement GetMetadataElementForVersion1File(string field)
        {
            var metadata = GetMetadataRowForVersion1File();
            return ParserTestHelper.GetElement(metadata, field);
        }

        private static IEnumerable<XElement> GetRowsForVersion1File()
        {
            var xml = GetParsedVersion1File();
            return ParserTestHelper.GetRows(xml);
        }

        private static XElement GetRowsElementForVersion1File(string field, int rowNumber)
        {
            var row = GetRowsForVersion1File().ElementAt(rowNumber);
            return ParserTestHelper.GetElement(row, field);
        }

        private static void AssertVersion1FileMetadataHasField(string field, string value)
        {
            var element = ParserTestHelper.GetElement(GetMetadataRowForVersion1File(), field);
            Assert.IsNotNull(element);
            Assert.AreEqual(value, element.Value);
        }

        private static void AssertVersion1FileRowsHaveField(string field, params string[] values)
        {
            for (var i = 0; i < values.Length; i++)
            {
                var element = GetRowsElementForVersion1File(field, i);
                Assert.IsNotNull(element);
                Assert.AreEqual(values[i], element.Value);
            }
        }

        private static string GetVersion2File()
        {
            return
                "062010107189AMERICAN PROVIDERS INC                                                                              1346299955          02040041.2\r\n" +
                "N         06719               05719               EDUVIGES                       ALVAREZ                       220 WEST 74 PLACE                                 APT 209                                           HIALEAH                                           FL33014    305823440920601192012042920101        004005000000010010100000000021715.09                  356.4                   440.21                  735.8                   414.01                  386.11                  22M112122221121102MM%\r\n" +
                "          07519               06519               RACHEL                         JENNINGS                      760 NW 65 STREET                                                                                    MIAMI                                             FL33150    30532132712041319121203082010406242010004004000000000010000000000022599.0                   041.4                   788.41                  530.81                  356.9                   715.09                  22M1122222200201M2MM%\r\n" +
                "          09121               08121               DELORES                       DMCCARTNEY                     1731 NW 152 TERR                                                                                    MIAMI                                             FL33054    305688013120215193412051120101        030021000000010010000000000022153.2                   197.5                   571.5                   789.59                  V58.31          789.59  250.00                  22M112122222220102MM%\r\n" +
                "N         09475               08475               RAMONA                         PORTES                        2899 COLLINS AVE                                  APT 1204                                          MIAMI BEACH                                       FL33140    305672047220408191512040920094        030031000000000010000000000022250.70                  443.81                  331.0                   787.20                  V55.1                   438.20                  22M1121222233645M2MM%\r\n";
        }

        private static XDocument GetParsedVersion2File()
        {
            return OcsFwParser.Parse(new ClientDetail(), "file.csv", GetVersion2File());
        }

        private static XElement GetMetadataRowForVersion2File()
        {
            var xml = GetParsedVersion2File();
            return ParserTestHelper.GetMetadataRow(xml);
        }

        private static XElement GetMetadataElementForVersion2File(string field)
        {
            var metadata = GetMetadataRowForVersion2File();
            return ParserTestHelper.GetElement(metadata, field);
        }

        private static IEnumerable<XElement> GetRowsForVersion2File()
        {
            var xml = GetParsedVersion2File();
            return ParserTestHelper.GetRows(xml);
        }

        private static XElement GetRowsElementForVersion2File(string field, int rowNumber)
        {
            var row = GetRowsForVersion2File().ElementAt(rowNumber);
            return ParserTestHelper.GetElement(row, field);
        }

        private static void AssertVersion2FileMetadataHasField(string field, string value)
        {
            var element = ParserTestHelper.GetElement(GetMetadataRowForVersion2File(), field);
            Assert.IsNotNull(element);
            Assert.AreEqual(value, element.Value);
        }

        private static void AssertVersion2FileRowsHaveField(string field, params string[] values)
        {
            for (var i = 0; i < values.Length; i++)
            {
                var element = GetRowsElementForVersion2File(field, i);
                Assert.IsNotNull(element);
                Assert.AreEqual(values[i], element.Value);
            }
        }

        #endregion Helpers

        #region Parse

        [TestMethod]
        public void Parse_RootAttributesAreSet()
        {
            var xml = OcsFwParser.Parse(new ClientDetail(), "file.csv", GetVersion1File());
            Assert.IsNotNull(xml.Root.Attribute("sourcefile"));
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void Parse_NoHeader_InvalidOperationExceptionIsThrown()
        {
            OcsFwParser.Parse(new ClientDetail(), "file.csv", "");
        }

        #region Version 1

        [TestMethod]
        public void Parse_Version1File_OneMetadataRow()
        {
            var xml = GetParsedVersion1File();
            var metadataRows = ParserTestHelper.GetMetadataRows(xml);
            Assert.AreEqual(1, metadataRows.Count());
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasId1()
        {
            var metadata = GetMetadataRowForVersion1File();
            Assert.AreEqual("1", metadata.Attribute("id").Value);
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasMonth()
        {
            AssertVersion1FileMetadataHasField("MONTH", "6");
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasYear()
        {
            AssertVersion1FileMetadataHasField("YEAR", "2010");
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasProviderId()
        {
            AssertVersion1FileMetadataHasField("PROVIDER ID", "107189");
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasProviderName()
        {
            AssertVersion1FileMetadataHasField("PROVIDER NAME", "AMERICAN PROVIDERS INC");
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertVersion1FileMetadataHasField("TOTAL NUMBER OF PATIENT SERVED", "204");
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasNumberOfBranches()
        {
            AssertVersion1FileMetadataHasField("NUMBER OF BRANCHES", "4");
        }

        [TestMethod]
        public void Parse_Version1File_MetadataHasVersionNumber()
        {
            AssertVersion1FileMetadataHasField("VERSION NUMBER", "1.1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHave4Records()
        {
            var rows = GetRowsForVersion1File();
            Assert.AreEqual(4, rows.Count());
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePatientId()
        {
            AssertVersion1FileRowsHaveField("Patient ID", "06719", "07519", "09121", "09475");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveMedicalRecordNumber()
        {
            AssertVersion1FileRowsHaveField("Medical Record Number", "05719", "06519", "08121", "08475");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveFirstName()
        {
            AssertVersion1FileRowsHaveField("Patient First Name", "EDUVIGES", "RACHEL", "DELORES", "RAMONA");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveMiddleInitial()
        {
            AssertVersion1FileRowsHaveField("Patient Middle Initial", "", "", "D", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveLastName()
        {
            AssertVersion1FileRowsHaveField("Patient Last Name", "ALVAREZ", "JENNINGS", "MCCARTNEY", "PORTES");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAddress1()
        {
            AssertVersion1FileRowsHaveField("Patient Mailing Address 1", "220 WEST 74 PLACE", "760 NW 65 STREET", "1731 NW 152 TERR", "2899 COLLINS AVE");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAddress2()
        {
            AssertVersion1FileRowsHaveField("Patient Mailing Address 2", "APT 209", "", "", "APT 1204");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveCity()
        {
            AssertVersion1FileRowsHaveField("Patient Address City", "HIALEAH", "MIAMI", "MIAMI", "MIAMI BEACH");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveState()
        {
            AssertVersion1FileRowsHaveField("Patient Address State", "FL", "FL", "FL", "FL");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveZip()
        {
            AssertVersion1FileRowsHaveField("Patient Address Zip Code", "33014", "33150", "33054", "33140");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePhone()
        {
            AssertVersion1FileRowsHaveField("Telephone Number including area code", "3058234409", "3053213271", "3056880131", "3056720472");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveGender()
        {
            AssertVersion1FileRowsHaveField("Gender", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveDateOfBirth()
        {
            AssertVersion1FileRowsHaveField("Patient Date of Birth", "06011920", "04131912", "02151934", "04081915");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveLanguage()
        {
            AssertVersion1FileRowsHaveField("Language", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveStartOfCareDate()
        {
            AssertVersion1FileRowsHaveField("Start of Care Date", "04292010", "03082010", "05112010", "04092009");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertVersion1FileRowsHaveField("Number of skilled visits", "4", "4", "30", "30");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveLookbackSkilledVisits()
        {
            AssertVersion1FileRowsHaveField("Lookback Period Visits", "5", "4", "21", "31");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerNone()
        {
            AssertVersion1FileRowsHaveField("Payer - None", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerMedicareFFS()
        {
            AssertVersion1FileRowsHaveField("Payer - Medicare FFS", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerMedicareHMO()
        {
            AssertVersion1FileRowsHaveField("Payer - Medicare HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerMedicaidFFS()
        {
            AssertVersion1FileRowsHaveField("Payer - Medicaid FFS", "1", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerMedicaidHMO()
        {
            AssertVersion1FileRowsHaveField("Payer - Medicaid HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerWorkersComp()
        {
            AssertVersion1FileRowsHaveField("Payer - Workers Comp", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerTitlePrograms()
        {
            AssertVersion1FileRowsHaveField("Payer - Title programs", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerOtherGovt()
        {
            AssertVersion1FileRowsHaveField("Payer - Other Government", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerPrivateIns()
        {
            AssertVersion1FileRowsHaveField("Payer - Private Ins", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerPrivateHMO()
        {
            AssertVersion1FileRowsHaveField("Payer - Private HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerPrivateSelf()
        {
            AssertVersion1FileRowsHaveField("Payer - Self-pay", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerOther()
        {
            AssertVersion1FileRowsHaveField("Payer - Other", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePayerUnknown()
        {
            AssertVersion1FileRowsHaveField("Payer - Unknown", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveDeceasedIndicator()
        {
            AssertVersion1FileRowsHaveField("Deceased Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveHospiceIndicator()
        {
            AssertVersion1FileRowsHaveField("Hospice Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveMaternityCareOnlyIndicator()
        {
            AssertVersion1FileRowsHaveField("Maternity Care Only Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveBranchID()
        {
            AssertVersion1FileRowsHaveField("Branch ID", "N", "", "", "N");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveHomeHealthVisitType()
        {
            AssertVersion1FileRowsHaveField("Home Health Visit Type", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAssessmentReason()
        {
            AssertVersion1FileRowsHaveField("Assessment Reason", "1", "4", "1", "4");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveDischargeDate()
        {
            AssertVersion1FileRowsHaveField("Discharge Date", "", "06242010", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceNF()
        {
            AssertVersion1FileRowsHaveField("Admission Source - NF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceSNF()
        {
            AssertVersion1FileRowsHaveField("Admission Source - SNF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertVersion1FileRowsHaveField("Admission Source - IPP S", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertVersion1FileRowsHaveField("Admission Source - LTCH", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceIRF()
        {
            AssertVersion1FileRowsHaveField("Admission Source - IRF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourcePysch()
        {
            AssertVersion1FileRowsHaveField("Admission Source - Pysch", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceOther()
        {
            AssertVersion1FileRowsHaveField("Admission Source - Other", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertVersion1FileRowsHaveField("Admission Source - NA (Community)", "1", "0", "1", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertVersion1FileRowsHaveField("Admission Source - Unknown", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveHMOIndicator()
        {
            AssertVersion1FileRowsHaveField("HMO Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertVersion1FileRowsHaveField("Dually eligible for Medicare and Medicaid?", "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertVersion1FileRowsHaveField("Primary Diagnosis ICD_A2", "715.09", "599.0", "153.2", "250.70");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePrimaryPaymentDiagnosisICD_A3()
        {
            AssertVersion1FileRowsHaveField("Primary Payment Diagnosis ICD_A3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePrimaryPaymentDiagnosisICD_A4()
        {
            AssertVersion1FileRowsHaveField("Primary Payment Diagnosis ICD_A4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherdiagnosis_B2()
        {
            AssertVersion1FileRowsHaveField("Other diagnosis_B2", "356.4", "041.4", "197.5", "443.81");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_B3()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis  ICD_B3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_B4()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis ICD_B4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherdiagnosis_C2()
        {
            AssertVersion1FileRowsHaveField("Other diagnosis_C2", "440.21", "788.41", "571.5", "331.0");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_C3()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis  ICD_C3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_C4()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis ICD_C4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherdiagnosis_D2()
        {
            AssertVersion1FileRowsHaveField("Other diagnosis_D2", "735.8", "530.81", "789.59", "787.20");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_D3()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis  ICD_D3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_D4()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis ICD_D4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherdiagnosis_E2()
        {
            AssertVersion1FileRowsHaveField("Other diagnosis_E2", "414.01", "356.9", "V58.31", "V55.1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_E3()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis  ICD_E3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_E4()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis ICD_E4", "", "", "789.59", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherdiagnosis_F2()
        {
            AssertVersion1FileRowsHaveField("Other diagnosis_F2", "386.11", "715.09", "250.00", "438.20");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_F3()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis  ICD_F3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOtherPaymentDiagnosisICD_F4()
        {
            AssertVersion1FileRowsHaveField("Other Payment Diagnosis ICD_F4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveSurgicalDischarge()
        {
            AssertVersion1FileRowsHaveField("Surgical Discharge", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertVersion1FileRowsHaveField("End-Stage Renal Disease (ESRD)", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveDialysisIndicator()
        {
            AssertVersion1FileRowsHaveField("Dialysis Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveReferralSource()
        {
            AssertVersion1FileRowsHaveField("Referral Source", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveSkilledNursing()
        {
            AssertVersion1FileRowsHaveField("Skilled Nursing", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHavePhysicalTherapy()
        {
            AssertVersion1FileRowsHaveField("Physical Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveHomeHealthAide()
        {
            AssertVersion1FileRowsHaveField("Home Health Aide", "1", "2", "1", "1");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveSocialService()
        {
            AssertVersion1FileRowsHaveField("Social Service", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveOccupationalTherapy()
        {
            AssertVersion1FileRowsHaveField("Occupational Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveCompanionHomemaker()
        {
            AssertVersion1FileRowsHaveField("Companion/Homemaker", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveSpeechTherapy()
        {
            AssertVersion1FileRowsHaveField("Speech Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveADL_DressUpper()
        {
            AssertVersion1FileRowsHaveField("ADL_Dress Upper", "1", "0", "2", "3");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveADL_DressLower()
        {
            AssertVersion1FileRowsHaveField("ADL_Dress Lower", "1", "0", "2", "3");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveADL_Bathing()
        {
            AssertVersion1FileRowsHaveField("ADL_Bathing", "2", "2", "2", "6");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveADL_Toileting()
        {
            AssertVersion1FileRowsHaveField("ADL_Toileting", "1", "0", "0", "4");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveADL_Transferring()
        {
            AssertVersion1FileRowsHaveField("ADL_Transferring", "1", "1", "1", "5");
        }

        [TestMethod]
        public void Parse_Version1File_RowsHaveADL_Feed()
        {
            AssertVersion1FileRowsHaveField("ADL_Feed", "0", "M", "0", "M");
        }

        #endregion Version 1

        #region Version 2

        [TestMethod]
        public void Parse_Version2File_OneMetadataRow()
        {
            var xml = GetParsedVersion2File();
            var metadataRows = ParserTestHelper.GetMetadataRows(xml);
            Assert.AreEqual(1, metadataRows.Count());
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasId1()
        {
            var metadata = GetMetadataRowForVersion2File();
            Assert.AreEqual("1", metadata.Attribute("id").Value);
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasMonth()
        {
            AssertVersion2FileMetadataHasField("MONTH", "6");
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasYear()
        {
            AssertVersion2FileMetadataHasField("YEAR", "2010");
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasProviderId()
        {
            AssertVersion2FileMetadataHasField("PROVIDER ID", "107189");
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasProviderName()
        {
            AssertVersion2FileMetadataHasField("PROVIDER NAME", "AMERICAN PROVIDERS INC");
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertVersion2FileMetadataHasField("TOTAL NUMBER OF PATIENT SERVED", "204");
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasNumberOfBranches()
        {
            AssertVersion2FileMetadataHasField("NUMBER OF BRANCHES", "4");
        }

        [TestMethod]
        public void Parse_Version2File_MetadataHasVersionNumber()
        {
            AssertVersion2FileMetadataHasField("VERSION NUMBER", "1.2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHave4Records()
        {
            var rows = GetRowsForVersion2File();
            Assert.AreEqual(4, rows.Count());
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePatientId()
        {
            AssertVersion2FileRowsHaveField("Patient ID", "06719", "07519", "09121", "09475");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveMedicalRecordNumber()
        {
            AssertVersion2FileRowsHaveField("Medical Record Number", "05719", "06519", "08121", "08475");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveFirstName()
        {
            AssertVersion2FileRowsHaveField("Patient First Name", "EDUVIGES", "RACHEL", "DELORES", "RAMONA");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveMiddleInitial()
        {
            AssertVersion2FileRowsHaveField("Patient Middle Initial", "", "", "D", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveLastName()
        {
            AssertVersion2FileRowsHaveField("Patient Last Name", "ALVAREZ", "JENNINGS", "MCCARTNEY", "PORTES");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAddress1()
        {
            AssertVersion2FileRowsHaveField("Patient Mailing Address 1", "220 WEST 74 PLACE", "760 NW 65 STREET", "1731 NW 152 TERR", "2899 COLLINS AVE");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAddress2()
        {
            AssertVersion2FileRowsHaveField("Patient Mailing Address 2", "APT 209", "", "", "APT 1204");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveCity()
        {
            AssertVersion2FileRowsHaveField("Patient Address City", "HIALEAH", "MIAMI", "MIAMI", "MIAMI BEACH");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveState()
        {
            AssertVersion2FileRowsHaveField("Patient Address State", "FL", "FL", "FL", "FL");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveZip()
        {
            AssertVersion2FileRowsHaveField("Patient Address Zip Code", "33014", "33150", "33054", "33140");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePhone()
        {
            AssertVersion2FileRowsHaveField("Telephone Number including area code", "3058234409", "3053213271", "3056880131", "3056720472");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveGender()
        {
            AssertVersion2FileRowsHaveField("Gender", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveDateOfBirth()
        {
            AssertVersion2FileRowsHaveField("Patient Date of Birth", "06011920", "04131912", "02151934", "04081915");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveLanguage()
        {
            AssertVersion2FileRowsHaveField("Language", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveStartOfCareDate()
        {
            AssertVersion2FileRowsHaveField("Start of Care Date", "04292010", "03082010", "05112010", "04092009");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertVersion2FileRowsHaveField("Number of skilled visits", "4", "4", "30", "30");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveLookbackSkilledVisits()
        {
            AssertVersion2FileRowsHaveField("Lookback Period Visits", "5", "4", "21", "31");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerNone()
        {
            AssertVersion2FileRowsHaveField("Payer - None", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerMedicareFFS()
        {
            AssertVersion2FileRowsHaveField("Payer - Medicare FFS", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerMedicareHMO()
        {
            AssertVersion2FileRowsHaveField("Payer - Medicare HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerMedicaidFFS()
        {
            AssertVersion2FileRowsHaveField("Payer - Medicaid FFS", "1", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerMedicaidHMO()
        {
            AssertVersion2FileRowsHaveField("Payer - Medicaid HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerWorkersComp()
        {
            AssertVersion2FileRowsHaveField("Payer - Workers Comp", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerTitlePrograms()
        {
            AssertVersion2FileRowsHaveField("Payer - Title programs", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerOtherGovt()
        {
            AssertVersion2FileRowsHaveField("Payer - Other Government", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerPrivateIns()
        {
            AssertVersion2FileRowsHaveField("Payer - Private Ins", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerPrivateHMO()
        {
            AssertVersion2FileRowsHaveField("Payer - Private HMO", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerPrivateSelf()
        {
            AssertVersion2FileRowsHaveField("Payer - Self-pay", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerOther()
        {
            AssertVersion2FileRowsHaveField("Payer - Other", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePayerUnknown()
        {
            AssertVersion2FileRowsHaveField("Payer - Unknown", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveDeceasedIndicator()
        {
            AssertVersion2FileRowsHaveField("Deceased Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveHospiceIndicator()
        {
            AssertVersion2FileRowsHaveField("Hospice Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveMaternityCareOnlyIndicator()
        {
            AssertVersion2FileRowsHaveField("Maternity Care Only Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveBranchID()
        {
            AssertVersion2FileRowsHaveField("Branch ID", "N", "", "", "N");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveHomeHealthVisitType()
        {
            AssertVersion2FileRowsHaveField("Home Health Visit Type", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAssessmentReason()
        {
            AssertVersion2FileRowsHaveField("Assessment Reason", "1", "4", "1", "4");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveDischargeDate()
        {
            AssertVersion2FileRowsHaveField("Discharge Date", "", "06242010", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceNF()
        {
            AssertVersion2FileRowsHaveField("Admission Source - NF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceSNF()
        {
            AssertVersion2FileRowsHaveField("Admission Source - SNF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceIPPS()
        {
            AssertVersion2FileRowsHaveField("Admission Source - IPP S", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceLTCH()
        {
            AssertVersion2FileRowsHaveField("Admission Source - LTCH", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceIRF()
        {
            AssertVersion2FileRowsHaveField("Admission Source - IRF", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourcePysch()
        {
            AssertVersion2FileRowsHaveField("Admission Source - Pysch", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceOther()
        {
            AssertVersion2FileRowsHaveField("Admission Source - Other", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceNACommunity()
		{
            AssertVersion2FileRowsHaveField("Admission Source - NA (Community)", "1", "0", "1", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveAdmissionSourceUnknown()
        {
            AssertVersion2FileRowsHaveField("Admission Source - Unknown", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveHMOIndicator()
        {
            AssertVersion2FileRowsHaveField("HMO Indicator", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {
            AssertVersion2FileRowsHaveField("Dually eligible for Medicare and Medicaid?", "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertVersion2FileRowsHaveField("Primary Diagnosis ICD_A2", "715.09", "599.0", "153.2", "250.70");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePrimaryPaymentDiagnosisICD_A3()
        {
            AssertVersion2FileRowsHaveField("Primary Payment Diagnosis ICD_A3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePrimaryPaymentDiagnosisICD_A4()
        {
            AssertVersion2FileRowsHaveField("Primary Payment Diagnosis ICD_A4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherdiagnosis_B2()
        {
            AssertVersion2FileRowsHaveField("Other diagnosis_B2", "356.4", "041.4", "197.5", "443.81");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_B3()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis  ICD_B3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_B4()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis ICD_B4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherdiagnosis_C2()
        {
            AssertVersion2FileRowsHaveField("Other diagnosis_C2", "440.21", "788.41", "571.5", "331.0");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_C3()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis  ICD_C3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_C4()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis ICD_C4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherdiagnosis_D2()
        {
            AssertVersion2FileRowsHaveField("Other diagnosis_D2", "735.8", "530.81", "789.59", "787.20");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_D3()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis  ICD_D3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_D4()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis ICD_D4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherdiagnosis_E2()
        {
            AssertVersion2FileRowsHaveField("Other diagnosis_E2", "414.01", "356.9", "V58.31", "V55.1");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_E3()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis  ICD_E3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_E4()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis ICD_E4", "", "", "789.59", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherdiagnosis_F2()
        {
            AssertVersion2FileRowsHaveField("Other diagnosis_F2", "386.11", "715.09", "250.00", "438.20");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_F3()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis  ICD_F3", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOtherPaymentDiagnosisICD_F4()
        {
            AssertVersion2FileRowsHaveField("Other Payment Diagnosis ICD_F4", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveSurgicalDischarge()
        {
            AssertVersion2FileRowsHaveField("Surgical Discharge", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveEndStageRenalDiseaseESRD()
		{
            AssertVersion2FileRowsHaveField("End-Stage Renal Disease (ESRD)", "2", "2", "2", "2");
		}

		[TestMethod]
        public void Parse_Version2File_RowsHaveDialysisIndicator()
        {
            AssertVersion2FileRowsHaveField("Dialysis Indicator", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveReferralSource()
        {
            AssertVersion2FileRowsHaveField("Referral Source", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveSkilledNursing()
        {
            AssertVersion2FileRowsHaveField("Skilled Nursing", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHavePhysicalTherapy()
        {
            AssertVersion2FileRowsHaveField("Physical Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveHomeHealthAide()
        {
            AssertVersion2FileRowsHaveField("Home Health Aide", "1", "2", "1", "1");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveSocialService()
        {
            AssertVersion2FileRowsHaveField("Social Service", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveOccupationalTherapy()
        {
            AssertVersion2FileRowsHaveField("Occupational Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveCompanionHomemaker()
        {
            AssertVersion2FileRowsHaveField("Companion/Homemaker", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveSpeechTherapy()
        {
            AssertVersion2FileRowsHaveField("Speech Therapy", "2", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveADL_DressUpper()
        {
            AssertVersion2FileRowsHaveField("ADL_Dress Upper", "1", "0", "2", "3");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveADL_DressLower()
        {
            AssertVersion2FileRowsHaveField("ADL_Dress Lower", "1", "0", "2", "3");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveADL_Bathing()
        {
            AssertVersion2FileRowsHaveField("ADL_Bathing", "2", "2", "2", "6");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveADL_Toileting()
        {
            AssertVersion2FileRowsHaveField("ADL_Toileting", "1", "0", "0", "4");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveADL_Transferring()
        {
            AssertVersion2FileRowsHaveField("ADL_Transferring", "1", "1", "1", "5");
        }

        [TestMethod]
        public void Parse_Version2File_RowsHaveADL_Feed()
        {
            AssertVersion2FileRowsHaveField("ADL_Feed", "0", "M", "0", "M");
        }

        #endregion Version 2

        [TestMethod]
        public void Parse_BlankLine_LineIsSkipped()
        {
            const string fileContents =
                "062010107189AMERICAN PROVIDERS INC                                                                              1346299955          02040041.1\r\n" +
                "N         06719               05719               EDUVIGES                       ALVAREZ                       220 WEST 74 PLACE                                 APT 209                                           HIALEAH                                           FL33014    305823440920601192012042920101        004005000000010010100000000021715.09            356.4             440.21            735.8             414.01            386.11            22M112122221121102MM%\r\n" +
                "\r\n" +
                "N         09475               08475               RAMONA                         PORTES                        2899 COLLINS AVE                                  APT 1204                                          MIAMI BEACH                                       FL33140    305672047220408191512040920094        030031000000000010000000000022250.70            443.81            331.0             787.20            V55.1             438.20            22M1121222233645M2MM%\r\n";
            var xml = OcsFwParser.Parse(new ClientDetail(), "file.csv", fileContents);
            var rows = ParserTestHelper.GetRows(xml);
            Assert.AreEqual(2, rows.Count());
        }

        #endregion Parse
    }
}
