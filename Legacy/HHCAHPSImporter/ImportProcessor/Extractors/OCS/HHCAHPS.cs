using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.IO;
using System.Text.RegularExpressions;

// using LumenWorks.Framework.IO.Csv;
using FileHelpers;

using HHCAHPSImporter.ImportProcessor.DAL;
using System.Xml.Serialization;


namespace HHCAHPSImporter.ImportProcessor.Extractors.OCS
{
    [DelimitedRecord(",")]
    public class NRCBody
    {
        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient ID")]
        public string Patient_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Medical Record Number")]
        public string MedicalRecordNumber;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient First Name")]
        public string First_Name;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Middle Initial")]
        public string Middle_Initial;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Last Name")]
        public string Last_Name;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Mailing Address 1")]
        public string Address1;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Mailing Address 2")]
        public string Address2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Address City")]
        public string City;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Address State")]
        public string State;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Address Zip Code")]
        public string ZipCode;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Telephone Number including area code")]
        public string Telephone;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Gender")]
        public string Gender;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Patient Date of Birth")]
        public string DOB;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Language")]
        public string Language;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Start of Care Date")]
        public string SOC_Date;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Number of skilled visits")]
        public global::System.Nullable<int> CurrentMonth_Skilled_Visits;


        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Lookback Period Visits")]
        public global::System.Nullable<int> Lookback_Skilled_Visits;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - None")]
        public string Payer_None;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Medicare FFS")]
        public string Payer_MedicareFFS;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Medicare HMO")]
        public string Payer_MedicareHMO;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Medicaid FFS")]
        public string Payer_MedicaidFFS;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Medicaid HMO")]
        public string Payer_MedicaidHMO;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Workers Comp")]
        public string Payer_WkersComp;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Title programs")]
        public string Payer_Title;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Other Government")]
        public string Payer_OtherGov;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Private Ins")]
        public string Payer_Private;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Private HMO")]
        public string Payer_PrivateHMO;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Self-pay")]
        public string Payer_Self;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Other")]
        public string Payer_Other;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Payer - Unknown")]
        public string Payer_UK;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Deceased Indicator")]
        public string Deceased_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Hospice Indicator")]
        public string Hospice_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Maternity Care Only Indicator")]
        public string Maternity_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Branch ID")]
        public string Branch_ID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Home Health Visit Type")]
        public string HH_Visit_Type;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Assessment Reason")]
        public string Assessment_Reason;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Discharge Date")]
        public string Discharge_Date;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - NF")]
        public string Admission_NF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - SNF")]
        public string Admission_SNF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - IPP S")]
        public string Admission_IPPS;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - LTCH")]
        public string Admission_LTCH;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - IRF")]
        public string Admission_IRF;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - Pysch")]
        public string Admission_Pysch;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - Other")]
        public string Admission_Other;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - NA (Community)")]
        public string Admission_NA;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Admission Source - Unknown")]
        public string Admission_UK;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("HMO Indicator")]
        public string HMO_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Dually eligible for Medicare and Medicaid?")]
        public string Dual_eligible;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Primary Diagnosis ICD_A2")]
        public string ICD_A2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Primary Payment Diagnosis ICD_A3")]
        public string ICD_A3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Primary Payment Diagnosis ICD_A4")]
        public string ICD_A4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other diagnosis_B2")]
        public string ICD_B2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis  ICD_B3")]
        public string ICD_B3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis ICD_B4")]
        public string ICD_B4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other diagnosis_C2")]
        public string ICD_C2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis  ICD_C3")]
        public string ICD_C3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis ICD_C4")]
        public string ICD_C4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other diagnosis_D2")]
        public string ICD_D2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis  ICD_D3")]
        public string ICD_D3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis ICD_D4")]
        public string ICD_D4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other diagnosis_E2")]
        public string ICD_E2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis  ICD_E3")]
        public string ICD_E3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis ICD_E4")]
        public string ICD_E4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other diagnosis_F2")]
        public string ICD_F2;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis  ICD_F3")]
        public string ICD_F3;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Other Payment Diagnosis ICD_F4")]
        public string ICD_F4;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Surgical Discharge")]
        public string Surgical_Discharge;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("End-Stage Renal Disease (ESRD)")]
        public string ESRD;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Dialysis Indicator")]
        public string Dialysis_Indicator;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Referral Source")]
        public string Referral_Source;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Skilled Nursing")]
        public string SN;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Physical Therapy")]
        public string PT;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Home Health Aide")]
        public string HHA;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Social Service")]
        public string Social_Service;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Occupational Therapy")]
        public string OT;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Companion/Homemaker")]
        public string Comp_Hmkr;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("Speech Therapy")]
        public string ST;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("ADL_Dress Upper")]
        public string ADL_Upper;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("ADL_Dress Lower")]
        public string ADL_Lower;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("ADL_Bathing")]
        public string ADL_Bath;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("ADL_Toileting")]
        public string ADL_Toilet;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("ADL_Transferring")]
        public string ADL_Transfer;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("ADL_Feed")]
        public string ADL_Feed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string[] ExtraColumns;
    }

    [DelimitedRecord(",")]
    public class NRCHeader
    {
        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("MONTH")]
        public int SampleMonth;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("YEAR")]
        public int SampleYear;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("PROVIDER ID")]
        public string ProviderID;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("PROVIDER NAME")]
        public string ProviderName;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        public string NPI;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("TOTAL NUMBER OF PATIENT SERVED")]
        public int TotalNumberOfPatientsServed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("NUMBER OF BRANCHES")]
        public global::System.Nullable<int> NumberOfBranchesServed;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [XmlAttribute("VERSION NUMBER")]
        public string VersionNumber;

        [FieldQuoted('"', QuoteMode.OptionalForBoth)]
        [FieldTrim(TrimMode.Both)]
        [FieldOptional]
        public string[] ExtraColumns;
    }

    public class HHCAHPS : CSVToXMLBase, IExtract
    {
        #region ITransform Members

        public XDocument Extract(DAL.Generated.ClientDetail client, string file)
        {
            FileHelperEngine header = new FileHelperEngine(typeof(NRCHeader));
            FileHelperEngine body = new FileHelperEngine(typeof(NRCBody));

            int headerCount = 0;
            using( var fs = File.OpenText(file) )
            {
                string s = fs.ReadLine();
                if (!s.Contains(@"MedicalRecordNumber") || s.Contains(@"Medical Record Number"))
                {
                    headerCount++;

                    while (!fs.EndOfStream)
                    {
                        s = fs.ReadLine();
                        if (s.Contains(@"MedicalRecordNumber") || s.Contains(@"Medical Record Number"))
                        {
                            break;
                        }
                        headerCount++;
                    }
                }
            }

            header.Options.IgnoreFirstLines = 1;
            var h = header.ReadFile(file, headerCount-1).ToList<object>();

            if (h == null || h.Count == 0)
            {
                throw new Exception("Header section missing");
            }
            if (h.Count > 1)
            {
                throw new Exception("Multiple records found in header section");
            }

            XElement xMetaData = this.CsvToXML(typeof(NRCHeader), h, "metadata");

            body.Options.IgnoreFirstLines = 3;
            var b = body.ReadFile(file).ToList<object>();

            XElement xRows = this.CsvToXML(typeof(NRCBody), b, "rows");

            XElement xroot = new XElement("root",
                new XAttribute("sourcefile", file),
                new XAttribute("client_id", client.Client_id),
                new XAttribute("study_id", client.Study_id),
                new XAttribute("survey_id", client.Survey_id),
                new XAttribute("ContractedLanguages", client.Languages));

            xroot.Add(xMetaData);
            xroot.Add(xRows);

            XDocument xdoc = new XDocument();
            xdoc.Add(xroot);

            return xdoc;
        }

        #region original version using generic csv parser
        //public XDocument Extract(DAL.Generated.ClientDetail client, string file)
        //{
        //    using (TextReader tr = new StreamReader(file))
        //    {
        //        XElement xroot = new XElement("root", 
        //            new XAttribute("sourcefile", file),
        //            new XAttribute("client_id", client.Client_id),
        //            new XAttribute("study_id", client.Study_id),
        //            new XAttribute("survey_id", client.Survey_id),
        //            new XAttribute("ContractedLanguages", client.Languages) );

        //        string text = tr.ReadToEnd();

        //        List<string> lines = text.Split(new char[] { '\r', '\n' })
        //            .Where(t => !string.IsNullOrEmpty(t))
        //            .ToList<string>();

        //        XElement xMetaData = null;
        //        XElement xRows = null;

        //        #region MetaData Rows (ocs files, this is the first two rows)
        //        StringReader str1 = new StringReader(lines[0] + "\r\n" + lines[1]);
        //        using (CsvReader csv = new CsvReader(str1, true))
        //        {
        //            xMetaData = CsvToXML(client, csv, "metadata");
        //        }
        //        #endregion

        //        #region Data Rows
        //        StringBuilder s = new StringBuilder(text.Length);
        //        foreach (string rawLine in lines.Skip(2))
        //        {
        //            string line = rawLine;
                    
        //            // Some very basic record cleanup
        //            // string line = rawLine.Replace(@","",", ",\",");

        //            try
        //            {
        //                CsvReader lineTest = new CsvReader(new StringReader(line), false);
        //                while (lineTest.ReadNextRecord())
        //                {
        //                    lineTest.ReadNextRecord();
        //                    var v = lineTest[0];
        //                }
        //                s.AppendLine(line);
        //            }
        //            catch (Exception e)
        //            {
        //                // TODO: Bad record???
        //                throw;
        //            }
        //        }

        //        StringReader str2 = new StringReader(s.ToString());
        //        using (CsvReader csv2 = new CsvReader(str2, true))
        //        {
        //            xRows = CsvToXML(client, csv2, "rows");
        //        }
        //        #endregion

        //        xroot.Add(xMetaData);
        //        xroot.Add(xRows);

        //        XDocument xdoc = new XDocument();
        //        xdoc.Add(xroot);
        //        return xdoc;
        //    }
        //}
        #endregion


        #endregion
    }
}
