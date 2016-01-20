using FileHelpers;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class ExtractHelper
    {
        #region Constants

        public const string MonthField = "MONTH";
        public const string YearField = "YEAR";
        public const string ProviderIdField = "PROVIDER ID";
        public const string ProviderNameField = "PROVIDER NAME";
        public const string NpiField = "NPI";
        public const string TotalPatientsServedField = "TOTAL NUMBER OF PATIENT SERVED";
        public const string NumberOfBranchesField = "NUMBER OF BRANCHES";
        public const string VersionNumberField = "VERSION NUMBER";

        public const string PatientIDField = "Patient ID";
        public const string MedicalRecordNumberField = "Medical Record Number";
        public const string PatientFirstNameField = "Patient First Name";
        public const string PatientMiddleInitialField = "Patient Middle Initial";
        public const string PatientLastNameField = "Patient Last Name";
        public const string PatientMailingAddress1Field = "Patient Mailing Address 1";
        public const string PatientMailingAddress2Field = "Patient Mailing Address 2";
        public const string PatientAddressCityField = "Patient Address City";
        public const string PatientAddressStateField = "Patient Address State";
        public const string PatientAddressZipCodeField = "Patient Address Zip Code";
        public const string TelephoneNumberincludingareacodeField = "Telephone Number including area code";
        public const string GenderField = "Gender";
        public const string PatientDateofBirthField = "Patient Date of Birth";
        public const string LanguageField = "Language";
        public const string StartofCareDateField = "Start of Care Date";
        public const string NumberofskilledvisitsField = "Number of skilled visits";
        public const string LookbackPeriodVisitsField = "Lookback Period Visits";
        public const string PayerNoneField = "Payer - None";
        public const string PayerMedicareFFSField = "Payer - Medicare FFS";
        public const string PayerMedicareHMOField = "Payer - Medicare HMO";
        public const string PayerMedicaidFFSField = "Payer - Medicaid FFS";
        public const string PayerMedicaidHMOField = "Payer - Medicaid HMO";
        public const string PayerWorkersCompField = "Payer - Workers Comp";
        public const string PayerTitleprogramsField = "Payer - Title programs";
        public const string PayerOtherGovernmentField = "Payer - Other Government";
        public const string PayerPrivateInsField = "Payer - Private Ins";
        public const string PayerPrivateHMOField = "Payer - Private HMO";
        public const string PayerSelfpayField = "Payer - Self-pay";
        public const string PayerOtherField = "Payer - Other";
        public const string PayerUnknownField = "Payer - Unknown";
        public const string DeceasedIndicatorField = "Deceased Indicator";
        public const string HospiceIndicatorField = "Hospice Indicator";
        public const string MaternityCareOnlyIndicatorField = "Maternity Care Only Indicator";
        public const string BranchIDField = "Branch ID";
        public const string HomeHealthVisitTypeField = "Home Health Visit Type";
        public const string AssessmentReasonField = "Assessment Reason";
        public const string DischargeDateField = "Discharge Date";
        public const string AdmissionSourceNFField = "Admission Source - NF";
        public const string AdmissionSourceSNFField = "Admission Source - SNF";
        public const string AdmissionSourceIPPSField = "Admission Source - IPP S";
        public const string AdmissionSourceLTCHField = "Admission Source - LTCH";
        public const string AdmissionSourceIRFField = "Admission Source - IRF";
        public const string AdmissionSourcePyschField = "Admission Source - Pysch";
        public const string AdmissionSourceOtherField = "Admission Source - Other";
        public const string AdmissionSourceNACommunityField = "Admission Source - NA (Community)";
        public const string AdmissionSourceUnknownField = "Admission Source - Unknown";
        public const string HMOIndicatorField = "HMO Indicator";
        public const string DuallyeligibleforMedicareandMedicaidField = "Dually eligible for Medicare and Medicaid?";
        public const string PrimaryDiagnosisICD_A2Field = "Primary Diagnosis ICD_A2";
        public const string PrimaryPaymentDiagnosisICD_A3Field = "Primary Payment Diagnosis ICD_A3";
        public const string PrimaryPaymentDiagnosisICD_A4Field = "Primary Payment Diagnosis ICD_A4";
        public const string Otherdiagnosis_B2Field = "Other diagnosis_B2";
        public const string OtherPaymentDiagnosisICD_B3Field = "Other Payment Diagnosis  ICD_B3";
        public const string OtherPaymentDiagnosisICD_B4Field = "Other Payment Diagnosis ICD_B4";
        public const string Otherdiagnosis_C2Field = "Other diagnosis_C2";
        public const string OtherPaymentDiagnosisICD_C3Field = "Other Payment Diagnosis  ICD_C3";
        public const string OtherPaymentDiagnosisICD_C4Field = "Other Payment Diagnosis ICD_C4";
        public const string Otherdiagnosis_D2Field = "Other diagnosis_D2";
        public const string OtherPaymentDiagnosisICD_D3Field = "Other Payment Diagnosis  ICD_D3";
        public const string OtherPaymentDiagnosisICD_D4Field = "Other Payment Diagnosis ICD_D4";
        public const string Otherdiagnosis_E2Field = "Other diagnosis_E2";
        public const string OtherPaymentDiagnosisICD_E3Field = "Other Payment Diagnosis  ICD_E3";
        public const string OtherPaymentDiagnosisICD_E4Field = "Other Payment Diagnosis ICD_E4";
        public const string Otherdiagnosis_F2Field = "Other diagnosis_F2";
        public const string OtherPaymentDiagnosisICD_F3Field = "Other Payment Diagnosis  ICD_F3";
        public const string OtherPaymentDiagnosisICD_F4Field = "Other Payment Diagnosis ICD_F4";
        public const string SurgicalDischargeField = "Surgical Discharge";
        public const string EndStageRenalDiseaseESRDField = "End-Stage Renal Disease (ESRD)";
        public const string DialysisIndicatorField = "Dialysis Indicator";
        public const string ReferralSourceField = "Referral Source";
        public const string SkilledNursingField = "Skilled Nursing";
        public const string PhysicalTherapyField = "Physical Therapy";
        public const string HomeHealthAideField = "Home Health Aide";
        public const string SocialServiceField = "Social Service";
        public const string OccupationalTherapyField = "Occupational Therapy";
        public const string CompanionHomemakerField = "Companion/Homemaker";
        public const string SpeechTherapyField = "Speech Therapy";
        public const string ADL_DressUpperField = "ADL_Dress Upper";
        public const string ADL_DressLowerField = "ADL_Dress Lower";
        public const string ADL_BathingField = "ADL_Bathing";
        public const string ADL_ToiletingField = "ADL_Toileting";
        public const string ADL_TransferringField = "ADL_Transferring";
        public const string ADL_FeedField = "ADL_Feed";

        public const string SourceFileAttributeName = "sourcefile";
        public const string ClientIdAttributeName = "client_id";
        public const string StudyIdAttributeName = "study_id";
        public const string SurveyIdAttributeName = "survey_id";
        public const string ContractedLanguagesAttributeName = "ContractedLanguages";

        public const string RootElementName = "root";
        public const string MetadataElementName = "metadata";
        public const string RowsElementName = "rows";
        public const string RowElementName = "r";
        public const string IdAttributeName = "id";
        public const string FieldElementName = "nv";
        public const string FieldAttributeName = "n";

        #endregion Constants

        public static XDocument CreateEmptyDocument()
        {
            return new XDocument(
                new XElement(RootElementName,
                    new XElement(MetadataElementName),
                    new XElement(RowsElementName)));
        }

        public static IEnumerable<XAttribute> CreateRootAttributes(ClientDetail client, string fileName)
        {
            if (client == null) throw new ArgumentNullException(nameof(client));
            if (fileName == null) throw new ArgumentNullException(nameof(fileName));

            return new List<XAttribute>
            {
                new XAttribute(SourceFileAttributeName, fileName),
                new XAttribute(ClientIdAttributeName, client.Client_id),
                new XAttribute(StudyIdAttributeName, client.Study_id),
                new XAttribute(SurveyIdAttributeName, client.Survey_id),
                new XAttribute(ContractedLanguagesAttributeName, client.Languages ?? "")
            };
        }

        public static XElement CreateTransformRow(int rowNumber, params XElement[] fields)
        {
            return
                new XElement(RowElementName,
                    new XAttribute(IdAttributeName, rowNumber),
                    fields
                );
        }

        public static XElement CreateFieldElement(string field, object value)
        {
            return new XElement(FieldElementName, new XAttribute(FieldAttributeName, field), value);
        }

        public static XElement GetMetadataElement(XDocument xml)
        {
            return xml.Element(RootElementName).Element(MetadataElementName);
        }

        public static XElement GetRowsElement(XDocument xml)
        {
            return xml.Element(RootElementName).Element(RowsElementName);
        }

        public static T Parse<T>(string line) where T : class
        {
            var engine = new FileHelperAsyncEngine<T>();
            using (engine.BeginReadString(line))
            {
                return engine.ReadNext();
            }
        }

        public static IEnumerable<string> GetLinesForFixedWidthFile(string fileContents)
        {
            return fileContents.Split('\n').Select(line => line.Replace("\r", ""));
        }

        public static string AddTrailingCommas(string fileContents)
        {
            return string.Join("\n", fileContents.Split('\n').Select(line => line.Replace("\r", "") + ","));
        }

        private static DateTime? GetDateTimeFromString(string value)
        {
            if (value == null) return null;
            value = value.Trim();
            
            string format;
            if (value.Contains("/"))
            {
                format = "M/d/yyyy";
            }
            else
            {
                const int GreatestPossibleMonthDay = 1231;

                if (value.Length < 7) return null;
                if (value.Length == 7) value = "0" + value;
                format = int.Parse(value.Substring(0, 4)) <= GreatestPossibleMonthDay ? "MMddyyyy" : "yyyyMMdd";
            }

            DateTime d;
            if (DateTime.TryParseExact(value, format, CultureInfo.CurrentCulture, DateTimeStyles.None, out d))
            {
                return d;
            }
            else
            {
                return null;
            }
        }

        public static string ToString(this DateTime? date, string format)
        {
            if (date == null) return "";
            return date.Value.ToString(format);
        }

        public static string ConvertDateFormat(string value)
        {
            return GetDateTimeFromString(value).ToString("MMddyyyy");
        }

        private static Regex _phoneNumberRegex = new Regex(@"^(\(?\d{3}\)?)?\s*[\.\-]*\s*\d{3}\s*[\.\-]*\s*\d{4}$", RegexOptions.Compiled);

        public static bool IsPhoneNumber(string candidateString)
        {
            return _phoneNumberRegex.IsMatch(candidateString.Trim());
        }

        public static int ColumnsWithData(string record)
        {
            return SplitIntoCells(record).Where(value => !string.IsNullOrWhiteSpace(value)).Count();
        }

        private static IEnumerable<string> SplitIntoCells(string contents)
        {
            var cell = new StringBuilder();
            var previous = ' ';
            var inQuotes = false;
            foreach (var current in contents)
            {
                switch (current)
                {
                    case '"':
                        inQuotes = !inQuotes;
                        if (previous == '"')
                        {
                            cell.Append('"');
                            previous = ' ';
                        }
                        else
                        {
                            previous = current;
                        }
                        break;
                    case ',':
                        if (inQuotes)
                        {
                            cell.Append(current);
                        }
                        else
                        {
                            yield return cell.ToString();
                            cell.Clear();
                        }
                        previous = current;
                        break;
                    case '\n':
                        if (inQuotes)
                        {
                            cell.Append(current);
                        }
                        else
                        {
                            yield return cell.ToString();
                            yield return null;
                            cell.Clear();
                        }
                        previous = current;
                        break;
                    case '\r':
                        break;
                    default:
                        cell.Append(current);
                        previous = current;
                        break;
                }
            }

            if (cell.ToString() != "") yield return cell.ToString();
        }

        public static bool IsBlankCsvLine(string line)
        {
            if (string.IsNullOrWhiteSpace(line)) return true;
            else if (ColumnsWithData(line) == 0) return true;
            return false;
        }

        public static bool IsFieldNamesLine(string line)
        {
            line = line.ToLower();

            if (line.Contains("version")) return true;
            if (line.Contains("provider id")) return true;
            if (line.Contains("npi")) return true;
            if (line.Contains("icd")) return true;
            if (line.Contains("deceased")) return true;
            if (line.Contains("zip")) return true;
            if (line.Contains("address")) return true;

            return false;
        }

        private static string GetMetadataFieldValue(XDocument xml, string field)
        {
            return GetMetadataElement(xml)
                .Elements(RowElementName)
                .First()
                .Elements(FieldElementName)
                .FirstOrDefault(nv => nv.Attribute(FieldAttributeName).Value == field)
                .Value;
        }

        public static int GetSampleMonth(XDocument xml)
        {
            return int.Parse(GetMetadataFieldValue(xml, MonthField));
        }

        public static int GetSampleYear(XDocument xml)
        {
            return int.Parse(GetMetadataFieldValue(xml, YearField));
        }
    }
}
