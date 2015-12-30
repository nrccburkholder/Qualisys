using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Linq;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;

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
            AssertSample1FileMetadataHasField("PROVIDER ID", "107207");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasProviderName()
        {
            AssertSample1FileMetadataHasField("PROVIDER NAME", "NURSE ON CALL INC.");
        }

        [TestMethod]
        public void Parse_Sample1File_MetadataHasTotalNumberOfPatientsServed()
        {
            AssertSample1FileMetadataHasField("TOTAL NUMBER OF PATIENT SERVED", "730");
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
            AssertSample1FileRowsHaveField("Patient ID", "689311M", "698711M", "699010M", "167111M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMedicalRecordNumber()
        {
            AssertSample1FileRowsHaveField("Medical Record Number", "689311M", "698711M", "699010M", "167111M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveFirstName()
        {
            AssertSample1FileRowsHaveField("Patient First Name", "GEORGE", "CHARLES", "BETTY", "MAYBELLE");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveMiddleInitial()
        {
            AssertSample1FileRowsHaveField("Patient Middle Initial", "J", "M", "W", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLastName()
        {
            AssertSample1FileRowsHaveField("Patient Last Name", "BURKE", "BENTZLEY", "FOX", "WILSON");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress1()
        {
            AssertSample1FileRowsHaveField("Patient Mailing Address 1", "4 Woodholm Lane", "138 Wellstone Drive", "820 E. 8th Ave.", "640 Fremont Ave");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAddress2()
        {
            AssertSample1FileRowsHaveField("Patient Mailing Address 2", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCity()
        {
            AssertSample1FileRowsHaveField("Patient Address City", "Palm Coast", "Palm Coast", "New Smyrna Beach", "Daytona Beach");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveState()
        {
            AssertSample1FileRowsHaveField("Patient Address State", "FL", "FL", "FL", "FL");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveZip()
        {
            AssertSample1FileRowsHaveField("Patient Address Zip Code", "32164", "32164", "32169", "32114");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhone()
        {
            AssertSample1FileRowsHaveField("Telephone Number including area code", "3864469610", "3863160540", "3864284353", "3862522371");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveGender()
        {
            AssertSample1FileRowsHaveField("Gender", "1", "1", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDateOfBirth()
        {
            AssertSample1FileRowsHaveField("Patient Date of Birth", "06181941", "08101939", "06261933", "12261928");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLanguage()
        {
            AssertSample1FileRowsHaveField("Language", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveStartOfCareDate()
        {
            AssertSample1FileRowsHaveField("Start of Care Date", "04052010", "04092010", "04092010", "02122009");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCurrentMonthSkilledVisits()
        {
            AssertSample1FileRowsHaveField("Number of skilled visits", "15", "8", "7", "23");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveLookbackSkilledVisits()
        {
            AssertSample1FileRowsHaveField("Lookback Period Visits", "47", "19", "11", "28");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerNone()
        {
            AssertSample1FileRowsHaveField("Payer - None", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareFFS()
        {
            AssertSample1FileRowsHaveField("Payer - Medicare FFS", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePayerMedicareHMO()
        {
            AssertSample1FileRowsHaveField("Payer - Medicare HMO", "1", "1", "1", "1");
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
            AssertSample1FileRowsHaveField("Branch ID", "P", "P", "P", "P");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthVisitType()
        {
            AssertSample1FileRowsHaveField("Home Health Visit Type", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAssessmentReason()
        {
            AssertSample1FileRowsHaveField("Assessment Reason", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDischargeDate()
        {
            AssertSample1FileRowsHaveField("Discharge Date", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNF()
        {
            AssertSample1FileRowsHaveField("Admission Source - NF", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceSNF()
        {
            AssertSample1FileRowsHaveField("Admission Source - SNF", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIPPS()
        {
            AssertSample1FileRowsHaveField("Admission Source - IPP S", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceLTCH()
        {
            AssertSample1FileRowsHaveField("Admission Source - LTCH", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceIRF()
        {
            AssertSample1FileRowsHaveField("Admission Source - IRF", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourcePysch()
        {
            AssertSample1FileRowsHaveField("Admission Source - Pysch", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceOther()
        {
            AssertSample1FileRowsHaveField("Admission Source - Other", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceNACommunity()
        {
            AssertSample1FileRowsHaveField("Admission Source - NA (Community)", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveAdmissionSourceUnknown()
        {
            AssertSample1FileRowsHaveField("Admission Source - Unknown", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHMOIndicator()
        {
            AssertSample1FileRowsHaveField("HMO Indicator", "1", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDuallyeligibleforMedicareandMedicaid()
        {

            AssertSample1FileRowsHaveField("Dually eligible for Medicare and Medicaid?", "0", "0", "0", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePrimaryDiagnosisICD_A2()
        {
            AssertSample1FileRowsHaveField("Primary Diagnosis ICD_A2", "998.83", "345.9", "491.2", "555.9");
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
            AssertSample1FileRowsHaveField("Other diagnosis_B2", "", "", "427.31", "356.9");
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
            AssertSample1FileRowsHaveField("Other diagnosis_C2", "401.9", "401.9", "", "438.89");
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
            AssertSample1FileRowsHaveField("Other diagnosis_D2", "", "", "V46.2", "728.87");
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
            AssertSample1FileRowsHaveField("Other diagnosis_E2", "715.9", "294.1", "V10.43", "276.51");
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
            AssertSample1FileRowsHaveField("Other diagnosis_F2", "443.9", "272.4", "", "V58.81");
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
            AssertSample1FileRowsHaveField("Surgical Discharge", "1", "2", "2", "2");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveEndStageRenalDiseaseESRD()
        {
            AssertSample1FileRowsHaveField("End-Stage Renal Disease (ESRD)", "M", "M", "M", "M");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveDialysisIndicator()
        {
            AssertSample1FileRowsHaveField("Dialysis Indicator", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveReferralSource()
        {
            AssertSample1FileRowsHaveField("Referral Source", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSkilledNursing()
        {
            AssertSample1FileRowsHaveField("Skilled Nursing", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHavePhysicalTherapy()
        {
            AssertSample1FileRowsHaveField("Physical Therapy", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveHomeHealthAide()
        {
            AssertSample1FileRowsHaveField("Home Health Aide", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSocialService()
        {
            AssertSample1FileRowsHaveField("Social Service", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveOccupationalTherapy()
        {
            AssertSample1FileRowsHaveField("Occupational Therapy", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveCompanionHomemaker()
        {
            AssertSample1FileRowsHaveField("Companion/Homemaker", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveSpeechTherapy()
        {
            AssertSample1FileRowsHaveField("Speech Therapy", "", "", "", "");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressUpper()
        {
            AssertSample1FileRowsHaveField("ADL_Dress Upper", "1", "1", "1", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_DressLower()
        {
            AssertSample1FileRowsHaveField("ADL_Dress Lower", "2", "2", "1", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Bathing()
        {
            AssertSample1FileRowsHaveField("ADL_Bathing", "5", "2", "2", "4");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Toileting()
        {
            AssertSample1FileRowsHaveField("ADL_Toileting", "0", "1", "1", "0");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Transferring()
        {
            AssertSample1FileRowsHaveField("ADL_Transferring", "0", "1", "1", "1");
        }

        [TestMethod]
        public void Parse_Sample1File_RowsHaveADL_Feed()
        {
            AssertSample1FileRowsHaveField("ADL_Feed", "M", "M", "M", "M");
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

        #endregion Parse
    }
}
