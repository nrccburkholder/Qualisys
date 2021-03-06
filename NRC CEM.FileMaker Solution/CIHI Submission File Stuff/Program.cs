﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Schema;

using System.IO;
using System.Data;
using cihifilemaker.DataProviders;
using cihifilemaker.Classes;
using System.Configuration;
using NRC.Logging;


/*
 * To use xsd from the Visual Studio Command Prompt
 * xsd C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xsd -language:CS /classes /outputdir:C:\Users\tbutler\Documents 
 * 
 * 
 */

namespace cihifilemaker
{
    class Program
    {

        private static int totalCount = 0;
        private static int fileCounter = 0;


        public enum NestingType
        {

            RussianDoll,
            SeparateComplexTypes

        }

        static void Main(string[] args)
        {
            int top;
            try
            {
                string submissionID;
                string sequenceNumber;
                bool submissionID_Result = false;
                bool sequenceNumber_Result = false;
                int seqNum = 0;
                int subID = 0;

                Console.WriteLine();
                Console.WriteLine(string.Format("Environment: {0}", GetEnvironment()));
                Console.WriteLine();
                Console.WriteLine();
                top = Console.CursorTop;
                Console.WriteLine("Enter SubmissionID:");
                Console.SetCursorPosition(20, top);
                submissionID = Console.ReadLine();

                submissionID_Result = Int32.TryParse(submissionID, out subID);

                if (!submissionID_Result)
                {
                    Console.WriteLine("Attempted conversion of SubmissionID '{0}' failed.", submissionID == null ? "<null>" : submissionID);
                }
                else
                {
                    Console.WriteLine();
                    top = Console.CursorTop;
                    Console.WriteLine("Enter Sequence Number:");
                    Console.SetCursorPosition(23, top);
                    sequenceNumber = Console.ReadLine();

                    sequenceNumber_Result = Int32.TryParse(sequenceNumber, out seqNum);

                    if (!sequenceNumber_Result)
                    {
                        Console.WriteLine("Attempted conversion of SequenceNumber '{0}' failed.", submissionID == null ? "<null>" : submissionID);
                    }
                }

                if (submissionID_Result && sequenceNumber_Result)
                {
                    Console.WriteLine();
                    Console.WriteLine();
                    top = Console.CursorTop;
                    Console.WriteLine("Press <ENTER> to start:");
                    Console.SetCursorPosition(24, top);

                    Console.ReadLine();

                    Start(subID, seqNum);
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine();
                Console.WriteLine(ex.Message);
                Console.WriteLine();   
            }

            top = Console.CursorTop;
            Console.WriteLine("Press <Enter> to exit:");
            Console.SetCursorPosition(23, top);
            Console.ReadLine();
            Console.WriteLine();
            Console.WriteLine("Goodbye!");

        }

        static void Start(int submissionID, int sequenceNumber)
        {
            Logs.Info(string.Format("CIHI FileMaker Begin Work"));
            try
            {
                
                MakeExportXMLDocuments(submissionID, sequenceNumber);
            }
            catch (Exception ex)
            {
                Console.WriteLine();
                Console.WriteLine(ex.Message);
                Console.WriteLine();
                Logs.Error("Error in Start", ex);
            }
            Logs.Info(string.Format("CIHI FileMaker End Work"));
        }

        static XmlSchemaElement GetParentElement(XmlSchemaObject xse)
        {
            XmlSchemaObject xso = xse.Parent;

            if (!xso.GetType().Equals(typeof(XmlSchemaElement)))
            {
                return GetParentElement(xso);
            }
            else
            {
                return (XmlSchemaElement)xse.Parent;
            }
            
        }

        public static void MakeExportXMLDocuments(int id, int seqNum)
        {
            string fiscalYear = ConfigurationManager.AppSettings["FiscalYear"].ToString();
            string submissionSequenceIdentifier = seqNum.ToString().PadLeft(3, '0');
            string submittingOrganizationIdentifier;
            string outputFileLocation = ConfigurationManager.AppSettings["OutputFileLocation"].ToString();

            DataSet ds = new DataSet();

            ds = ExportProvider.SelectSubmissionMetadata(id);

            if (ds.Tables[0].Rows.Count > 0)
            {

                DataTable dt = ds.Tables[0];
                totalCount = dt.Rows.Count;
                fileCounter = 0;
                foreach (DataRow dr in dt.Rows)
                {
                    submittingOrganizationIdentifier = dr["sender.organization.id.value"].ToString().Replace("-","").Replace("*","").PadLeft(5,'0');
                    string outputFileName = $@"{outputFileLocation}CPE{fiscalYear}00{submittingOrganizationIdentifier}1{submissionSequenceIdentifier}.xml";

                    MakeExportXMLDocument(outputFileName, dr, id);
                   
                }

            }
            else throw new Exception($"No Submission Metadata found for SubmissionID {id.ToString()}!");
        }

        public static void MakeExportXMLDocument(string outputFileName, DataRow dr, int id)
        {
            fileCounter++;

            Console.WriteLine();
            Console.WriteLine($"Processing {outputFileName} ({fileCounter.ToString()} of {totalCount.ToString()})...");
            Logs.Info($"MakeExportXMLDocument - Processing {outputFileName} ({fileCounter.ToString()} of {totalCount.ToString()})...");

            Encoding encoding = new UTF8Encoding(false);


                using (XmlReader reader = XmlReader.Create(new StringReader(Properties.Resources.cpesic_submission_v1_0), new XmlReaderSettings(), XmlResolver.BaseUri))
                {
                    XmlSchemaSet xset = RetrieveSchemaSet(reader);
                   // Console.WriteLine(xset.IsCompiled);


                    foreach (XmlSchema schema in xset.Schemas())
                    {
                        //Console.WriteLine(schema.TargetNamespace);


                        XmlDocumentEx xmlDoc = new XmlDocumentEx();

                        xmlDoc.LoadXml(GenerateEmptyXMLFromSchema(schema));

                        using (XMLWriter writer = new XMLWriter())
                        {
                            XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;
                            writer.StartElement(string.Format("{0}:{1}", "cpesic", root.Name));
                            writer.WriteAttribute("xmlns", "cpesic", null, schema.TargetNamespace);
                            writer.WriteAttribute("xmlns", "xsi", null, "http://www.w3.org/2001/XMLSchema-instance");
                            writer.WriteAttribute("xsi", "schemaLocation", null, string.Format("{0} {1},", schema.TargetNamespace, "cpesic-submission_v1.0.xsd"));

                            XmlNode rootNode = xmlDoc.DocumentElement;

                            // DataSubmission section

                            WriteDataSubmissionSection(dr, writer, rootNode, id);


                            writer.EndElement();

                            XmlDocumentEx returnXMLdoc = new XmlDocumentEx();
                            returnXMLdoc.Schemas.Add(schema);
                            returnXMLdoc.LoadXml(writer.XmlString);
                            returnXMLdoc.Save(outputFileName);

                            try
                            {
                                returnXMLdoc.Validate();
                            }
                            catch (Exception ex)
                            {
     
                                returnXMLdoc.ValidationErrorList.Add(new ExportValidationError($"Error in XML.Validate()! {ex.Message}"));
                                Logs.Error("MakeExportXMLDocument - returnXMLdoc.Validate() error", ex);
                            }

                            if (!returnXMLdoc.IsValid)
                            {
                                foreach (ExportValidationError eve in returnXMLdoc.ValidationErrorList)
                                {
                                    //Logging to the database.  The elements of the message are pipe delimited, with the template name, queueid, queuefileid, the file name, and the validation error description
                                    Console.WriteLine($" XML validation error: Name = {eve.ElementName} Value={eve.ElementValue} {eve.ErrorDescription}");
                                    Logs.Info($"MakeExportXMLDocument - XML validation error: Name = {eve.ElementName} Value={eve.ElementValue} {eve.ErrorDescription}");
                            }
                            }
                            else
                            {

                                Console.WriteLine("This XML Validated successfully!");
                                Logs.Info($"MakeExportXMLDocument - XML validated successfully.");
                        }
                            Console.WriteLine();
                        }

                    }
                }

        }

        private static XmlSchemaSet RetrieveSchemaSet(XmlReader reader)
        {
            XmlSchemaSet xset = new XmlSchemaSet() { XmlResolver = new XmlResolver() };
            xset.Add(XmlSchema.Read(reader, null));
            xset.Compile();
            return xset;
        }

        static string GenerateEmptyXMLFromSchema(XmlSchema schema)
        {
            string xmlString = string.Empty;
            XmlDocument xDoc = new XmlDocument();

            using (StringWriter sw = new StringWriter())
            {
                XmlTextWriter writer = new XmlTextWriter(sw);
                writer.WriteStartDocument();

                // Iterate over each XmlSchemaElement in the Values collection 
                // of the Elements property. 
                XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;

                writer.WriteStartElement(root.Name);

                XmlSchemaSequence children = ((XmlSchemaComplexType)root.ElementSchemaType).ContentTypeParticle as XmlSchemaSequence;
                foreach (XmlSchemaObject child in children.Items.OfType<XmlSchemaElement>())
                {
                    WriteOutXMLChildrenFromXSD(child, writer);
                }

                writer.WriteEndElement();
                writer.WriteEndDocument();
                writer.Close();

                xmlString = sw.ToString();
            }

            return xmlString;
        }

        #region xmlwritemethods

        private static void WriteOutXMLChildrenFromXSD(XmlSchemaObject xso, XmlTextWriter writer,string parentName = null)
        {
            if (xso.GetType().Equals(typeof(XmlSchemaElement)))
            {
                // Do something with an element.

                XmlSchemaElement xse = (XmlSchemaElement)xso;

                string fullname;

                if (parentName == null)
                {
                    fullname = xse.Name;

                }
                else
                {
                    fullname = string.Format("{0}.{1}", parentName, xse.Name);
                }

                writer.WriteStartElement(xse.Name);

                // Get the complex type of the element.
                XmlSchemaComplexType complexType = xse.ElementSchemaType as XmlSchemaComplexType;

                if (complexType == null)
                {

                }
                else
                {
                    // If the complex type has any attributes, get an enumerator  
                    // and write each attribute name to the console. 
                    if (complexType.AttributeUses.Count > 0)
                    {
                        IDictionaryEnumerator enumerator = complexType.AttributeUses.GetEnumerator();

                        while (enumerator.MoveNext())
                        {
                            XmlSchemaAttribute attribute = (XmlSchemaAttribute)enumerator.Value;
                            if (attribute.AttributeSchemaType.Datatype != null)
                            {

                                string attributeDataType = attribute.AttributeSchemaType.Datatype.GetType().Name;
                                //if ((attribute.Use !=  XmlSchemaUse.Optional) && (attribute.Name != "nullFlavor"))
                                if  ((attribute.Name != "nullFlavor") && (attribute.Name != "displayName") )
                                {
                                    writer.WriteAttributeString(attribute.Name, "");
                                }
                            }
                        }
                    }

                    // Get the sequence particle of the complex type.
                    XmlSchemaSequence sequence = complexType.ContentTypeParticle as XmlSchemaSequence;

                    if (sequence != null)
                    {
                        // Iterate over each XmlSchemaElement in the Items collection. 
                        foreach (XmlSchemaObject childElement in sequence.Items)
                        {
                            
                            WriteOutXMLChildrenFromXSD(childElement, writer,fullname);
                        }
                    }
                }

                writer.WriteEndElement();
            }
        }

        private static void WriteElementString(DataRow dr, XmlNode parentNode, string nameOfNode, XMLWriter writer)
        {
            try
            {
                XmlNode mNode = parentNode.SelectSingleNode(nameOfNode);
                if (mNode == null) return;

                string fieldName = GetNodePath(mNode);
                if (dr.Table.Columns.Contains(fieldName))
                {
      
                    if (dr[fieldName] != DBNull.Value)
                    {
                        string value = dr[fieldName].ToString().Trim();
                        writer.WriteElementString(nameOfNode, value);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private static void WriteElementWithAttributes(DataRow dr, XMLWriter writer, XmlNode parentNode, string nameOfNode)
        {
            try
            {

                XmlNode node = parentNode.SelectSingleNode(nameOfNode);

                if (node == null) return;

                string nodeName = GetNodePath(node);

                writer.StartElement(node.Name);

                if (node.Attributes != null && node.Attributes.Count > 0)
                {
                    foreach (XmlAttribute attr in node.Attributes)
                    {
                       WriteAttributeString(dr, string.Format("{0}_{1}", nodeName, attr.Name), attr.Name, writer);
                    }
                }
                writer.EndElement();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private static void WriteElementWithAttributes(DataRow dr, XMLWriter writer, XmlNode node)
        {
            try
            {

                string nodeName = GetNodePath(node);

                writer.StartElement(node.Name);
                if (node.Attributes != null && node.Attributes.Count > 0)
                {
                    foreach (XmlAttribute attr in node.Attributes)
                    {
                        WriteAttributeString(dr, string.Format("{0}_{1}", nodeName, attr.Name), attr.Name, writer);
                    }
                }
                writer.EndElement();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private static void WriteAttributeString(DataRow dr, string fieldname, string attributename, XMLWriter writer)
        {

            try
            {
                if (dr.Table.Columns.Contains(fieldname)) { 
                    
                    if (dr[fieldname] != DBNull.Value)
                    {
                        string value = dr[fieldname].ToString().Trim();
                        writer.WriteAttribute(attributename, value);
                    }
                        
                }
            }
            catch (Exception ex) 
            { 
                throw ex; 
            }

        }

        private static Boolean SkipIfNullValue(DataRow dr, XmlNode parentNode, string nameOfNode)
        {
            Boolean skip = false;
            XmlNode mNode = parentNode.SelectSingleNode(nameOfNode);
            if (mNode == null) return true;

            string fieldName = GetNodePath(mNode);
            if (dr.Table.Columns.Contains(fieldName))
            {
                skip = (dr[fieldName] == DBNull.Value);
            }

            return skip;
        }

        #endregion

        #region CIHI xmlsections

        private static void WriteDataSubmissionSection(DataRow dr, XMLWriter writer, XmlNode parentNode, int submissionid)
        {

            string submissionSubject = dr["SubmissionSubject"].ToString();

            WriteCreationTime(dr, writer, parentNode);

            WriteSenderSection(dr, writer, parentNode);

            WriteVersionSection(dr, writer, parentNode);

            WritePurposeSection(dr, writer, parentNode);


            
            int Final_MetadataID = Convert.ToInt32(dr["Final_MetadataID"]);

            if (submissionSubject.ToUpper() == "ORG")
            {
                DataSet dsOrgProfile = ExportProvider.SelectSubmission_OrgProfile(Final_MetadataID);
                WriteOrganizationProfileSection(dsOrgProfile, writer, parentNode);
            }
            else
            {
                int submissionID = Convert.ToInt32(dr["submissionID"]);
                string FacilityNumber = dr["sender.organization.id.value"].ToString();
                DataSet dsQuestionnaireCycle = ExportProvider.SelectSubmission_QuestionnaireCycle(submissionID, FacilityNumber);
                WriteQuestionnaireCycleSection(dsQuestionnaireCycle, writer, parentNode);
            }


        }

        private static void WriteCreationTime(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            WriteElementWithAttributes(dr, writer, parentNode, "creationTime");
        }

        private static void WriteSenderSection(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("sender");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteDevice(dr, writer, node);

            WriteOrganization(dr, writer, node);

            writer.EndElement();
        }

        private static void WriteVersionSection(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            WriteElementWithAttributes(dr, writer, parentNode, "versionCode");
        }

        private static void WritePurposeSection(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            WriteElementWithAttributes(dr, writer, parentNode, "purpose");
        }

        private static void WriteOrganizationProfileSection(DataSet ds, XMLWriter writer, XmlNode parentNode)
        {

            if (ds != null)
            {
                DataTable dt = ds.Tables[0];

                XmlNode node = parentNode.SelectSingleNode("organizationProfile");

                if (node == null) return;

                foreach (DataRow dr in dt.Rows)
                {

                    writer.StartElement(node.Name);

                    WriteOrganization(dr, writer, node, true);

                    DataSet dsRole = ExportProvider.SelectSubmission_Role(Convert.ToInt32(dr["Final_OrgProfileID"]));

                    WriteRoles(dsRole, writer, node);

                    WriteSurveyingFrequency(dr, writer, node);

                    WriteDevice(dr, writer, node);

                    writer.EndElement();
                }
            }
        }

        private static void WriteSurveyingFrequency(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {

            WriteElementWithAttributes(dr, writer, parentNode, "surveyingFrequency");

        }

        private static void WriteRoles(DataSet ds, XMLWriter writer, XmlNode parentNode)
        {

            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        WriteElementWithAttributes(dr, writer, parentNode, "role");
                    }
                }         
            }
         
        }

        private static void WriteOrganization(DataRow dr, XMLWriter writer, XmlNode parentNode, bool includeContact = false)
        {
            XmlNode node = parentNode.SelectSingleNode("organization");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteID(dr, writer, node);

            if (includeContact) 
            {
                int orgProfileID = Convert.ToInt32(dr["Final_OrgProfileID"]);
                DataSet dsContacts = ExportProvider.SelectSubmission_OrgProfile_Contacts(orgProfileID);
                if (dsContacts.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dr1 in dsContacts.Tables[0].Rows)
                    {
                        WriteContact(dr1, writer, node);
                    }        
                }
                   
            }

            writer.EndElement();
        }

        private static void WriteDevice(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {

            XmlNode node = parentNode.SelectSingleNode("device");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteManufacturer(dr, writer, node);

            writer.EndElement();
        }

        private static void WriteManufacturer(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {

            XmlNode node = parentNode.SelectSingleNode("manufacturer");

            if (node == null) return;

            writer.StartElement(node.Name);
        
            WriteID(dr, writer, node);

            writer.EndElement();
        }

        private static void WriteID(DataRow dr, XMLWriter writer, XmlNode parentNode, bool includeIssuer = false)
        {
            XmlNode node = parentNode.SelectSingleNode("id");

            if (node == null) return;

            if (!SkipIfNullValue(dr, node, "value"))
            {
                writer.StartElement(node.Name);

                WriteElementString(dr, node, "value", writer);

                if (includeIssuer) { WriteIssuer(dr, writer, node); }

                writer.EndElement();
            }
         
        }

        private static void WriteIssuer(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("issuer");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementWithAttributes(dr, writer, node, "code");

            writer.EndElement();
        }

        private static void WriteContact(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("contact");

            if (node == null) return;

            writer.StartElement(node.Name);

            string nodeName = GetNodePath(node);

            WriteElementWithAttributes(dr, writer, node, "code");

            WriteElementString(dr, node, "email", writer);

            WriteElementString(dr, node, "name", writer);

            WriteElementWithAttributes(dr, writer, node, "phone");

            writer.EndElement();
        }

        private static void WriteQuestionnaireCycleSection(DataSet ds, XMLWriter writer, XmlNode parentNode)
        {

            if (ds != null)
            {
                DataTable dt = ds.Tables[0];

                XmlNode node = parentNode.SelectSingleNode("questionnaireCycle");

                if (node == null) return;

                foreach (DataRow dr in dt.Rows)
                {

                    writer.StartElement(node.Name);

                    WriteID(dr, writer, node);

                    WriteHealthCareFacility(dr, writer, node);

                    WriteElementWithAttributes(dr, writer, node, "submissionType");

                    WriteElementWithAttributes(dr, writer, node, "proceduresManualVersion");

                    WriteEffectiveTime(dr, writer, node, true);

                    WriteSampleInformation(dr, writer, node);

                    int questionnaireCycleID = Convert.ToInt32(dr["Final_QuestionnaireCycleID"]);
                    DataSet dsQuestionnaire = ExportProvider.SelectSubmission_Questionnaire(questionnaireCycleID);

                    WriteQuestionnaireSection(dsQuestionnaire, writer, node);

                    writer.EndElement();
                }
            }
        }

        private static void WriteHealthCareFacility(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("healthCareFacility");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteID(dr, writer, node);

            writer.EndElement();
        }

        private static void WriteEffectiveTime(DataRow dr, XMLWriter writer, XmlNode parentNode, bool includeLow = false)
        {

            XmlNode node = parentNode.SelectSingleNode("effectiveTime");

            if (node == null) return;

            writer.StartElement(node.Name);

            if (includeLow)
                WriteElementWithAttributes(dr, writer, node, "low");

            WriteElementWithAttributes(dr, writer, node,"high");

            writer.EndElement();
        }
      
        private static void WriteSampleInformation(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {

            XmlNode node = parentNode.SelectSingleNode("sampleInformation");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementWithAttributes(dr,writer,node,"samplingMethod");

            WritePopulationInformation(dr, writer, node);

            writer.EndElement();
        }

        private static void WritePopulationInformation(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("populationInformation");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementString(dr, node, "dischargeCount", writer);

            WriteElementString(dr, node, "sampleSize", writer);

            WriteElementString(dr, node, "nonResponseCount", writer);

            //foreach (XmlNode dischargeInformationNode in node.SelectNodes("dischargeInformation"))
            //{
            //    WriteDischargeInformation(dr, writer, dischargeInformationNode);
            //}


            int Final_QuestionnaireCycleID = Convert.ToInt32(dr["Final_QuestionnaireCycleID"]);
            DataSet ds = ExportProvider.SelectSubmission_Stratum(Final_QuestionnaireCycleID);

            WriteStatumInformation(ds, writer, node);

            writer.EndElement();
        }

        private static void WriteDischargeInformation(DataRow dr, XMLWriter writer, XmlNode node)
        {
            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementWithAttributes(dr, writer, node, "service");

            WriteElementWithAttributes(dr, writer, node, "admissionSource");

            WriteElementWithAttributes(dr, writer, node, "gender");

            WriteElementWithAttributes(dr, writer, node, "ageCategory");

            WriteElementString(dr, node, "dischargeCount", writer);

            writer.EndElement();
        }

        private static void WriteStatumInformation(DataSet ds, XMLWriter writer, XmlNode parentNode)
        {

            if (ds != null)
            {
                DataTable dt = ds.Tables[0];

                XmlNode node = parentNode.SelectSingleNode("stratum");

                if (node == null) return;

                foreach (DataRow dr in dt.Rows)
                {

                    writer.StartElement(node.Name);

                    WriteElementString(dr, node, "stratumCode", writer);

                    WriteElementString(dr, node, "stratumDescription", writer);

                    WriteElementString(dr, node, "dischargeCount", writer);

                    WriteElementString(dr, node, "sampleSize", writer);

                    WriteElementString(dr, node, "nonResponseCount", writer);

                    writer.EndElement();
                }
            }
        }

        private static void WriteQuestionnaireSection(DataSet ds, XMLWriter writer, XmlNode parentNode)
        {
            if (ds != null)
            {

                DataTable dt = ds.Tables[0];

                XmlNode node = parentNode.SelectSingleNode("questionnaire");

                if (node == null) return;

                foreach (DataRow dr in dt.Rows)
                {
                    writer.StartElement(node.Name);

                    WriteID(dr, writer, node);

                    WriteSubjectSection(dr, writer, node);

                    WriteEncompassingEncounter(dr, writer, node);

                    WriteElementWithAttributes(dr, writer, node, "authorMode");

                    WriteElementWithAttributes(dr, writer, node, "language");

                    WriteElementString(dr, node, "stratumCode", writer);

                    WriteQuestionsSection(dr, writer, node);

                    writer.EndElement();
                }
            }
        }

        private static void WriteSubjectSection(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("subject");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteID(dr, writer, node, true);

            WriteOtherID(dr, writer, node);

            WritePersonInformation(dr, writer, node);

            writer.EndElement();
        }

        private static void WriteOtherID(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("otherId");

            if (node == null) return;

            if (!SkipIfNullValue(dr, node, "value"))
            {
                writer.StartElement(node.Name);

                WriteElementString(dr, node, "value", writer);

                WriteElementWithAttributes(dr, writer, node, "code");

                writer.EndElement();
            }
        }

        private static void WritePersonInformation(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("personInformation");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementWithAttributes(dr, writer, node, "birthTime");

            WriteElementWithAttributes(dr, writer, node, "estimatedBirthTimeInd");

            WriteElementWithAttributes(dr, writer, node, "gender");

            writer.EndElement();
        }

        private static void WriteEncompassingEncounter(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("encompassingEncounter");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteEffectiveTime(dr, writer, node);

            WriteElementWithAttributes(dr, writer, node, "service");

            writer.EndElement();
        }

        private static void WriteQuestionsSection(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("questions");

            if (node == null) return;

            writer.StartElement(node.Name);

             int questionnaireID = Convert.ToInt32(dr["Final_QuestionnaireID"]);
             DataSet dsQuestions = ExportProvider.SelectSubmission_Questions(questionnaireID);

             foreach (DataRow dr1 in dsQuestions.Tables[0].Rows)
             {
                WriteQuestion(dr1, writer, node);
             }

            writer.EndElement();
        }

        private static void WriteQuestion(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("question");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementWithAttributes(dr, writer, node, "code");

            WriteElementWithAttributes(dr, writer, node, "answer");

            writer.EndElement();
        }

        //private static void WriteSpecialProjectDataSection(DataTable dt, XMLWriter writer, XmlNode parentNode)
        //{
        //    XmlNode node = parentNode.SelectSingleNode("specialProjectData");

        //    if (node == null) return;

        //    writer.StartElement(node.Name);

        //    WriteQuestionnaireCycleSection(dt, writer, node);

        //    writer.EndElement();
        //}

        private static void WriteSpecialProject(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {
            XmlNode node = parentNode.SelectSingleNode("specialProject");

            if (node == null) return;

            writer.StartElement(node.Name);

            WriteElementString(dr, node, "code", writer);

            WriteElementString(dr, node, "data", writer);

            writer.EndElement();
        }

        private static string GetNodePath(XmlNode node)
        {
            XmlNode sourceNode = node;
            string nodePath = node.Name;
            while (sourceNode.ParentNode != null) 
            {
                if (sourceNode.ParentNode.Name.Equals("cpesicDataSubmission")) break;

                    nodePath = string.Format("{0}.{1}", sourceNode.ParentNode.Name, nodePath);
                    sourceNode = sourceNode.ParentNode;
            }

            return nodePath;
        }

        static string GetEnvironment()
        {
            string connStr = ConfigurationManager.ConnectionStrings["QPPRODConnection"].ConnectionString.ToUpper();

            if (connStr.Contains("PRIME")) return "US TEST";
            else if (connStr.Contains("GATOR")) return "US STAGE";
            else if (connStr.Contains("NRC10")) return "US PROD";
            else if (connStr.Contains("MHM0SQUALSQL02")) return "CA STAGE";
            else if (connStr.Contains("MHM0PQUALSQL02")) return "CA PROD";
            else throw new Exception( "INVALID ENVIRONMENT");

        }

        #endregion

    }


    internal class XMLWriter : IDisposable
    {

        #region properties

        private XmlTextWriter writer;

        private StringWriter mStringWriter;

        private XmlTextWriter Writer { get { return writer; } }

        public string XmlString
        {
            get
            {
                StringBuilder sb = new StringBuilder();
                sb = mStringWriter.GetStringBuilder();
                writer.Close();
                return sb.ToString();
            }
        }

        #endregion

        #region public methods

        public void StartElement(string name)
        {
            writer.WriteStartElement(name);
        }

        public void EndElement()
        {
            writer.WriteEndElement();
        }

        public void WriteAttribute(string name, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    writer.WriteAttributeString(name, value);
                }
            }
        }

        public void WriteAttribute(string prefix, string name, string ns, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    writer.WriteAttributeString(prefix, name, ns, value);
                }
            }
        }

        public void WriteElementString(string name, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    writer.WriteElementString(name, SanitizeElement(value));
                }
            }
        }

        private string SanitizeElement(string s)
        {
            string temp = s;

            temp = temp.Replace("&", "&amp;");
            temp = temp.Replace("<", "&lt;");
            temp = temp.Replace(">", "&gt;");
            temp = temp.Replace("'", "&apos;");
            temp = temp.Replace(@"""", "&quot;");
            temp = temp.Replace("\a", "");

            return temp;
        }

        public void Flush()
        {
            writer.Flush();
        }

        public void Close()
        {
            writer.Close();
        }

        #endregion

        #region constructors

        public XMLWriter()
        {
            mStringWriter = new StringWriter();
            writer = new XmlTextWriter(mStringWriter);
            writer.Formatting = Formatting.Indented;
            writer.WriteRaw(@"<?xml version=""1.0"" encoding=""UTF-8""?>");
        }

        public XMLWriter(StreamWriter stream)
        {
            writer = new XmlTextWriter(stream);
            writer.Formatting = Formatting.Indented;
            writer.WriteRaw(@"<?xml version=""1.0"" encoding=""UTF-8""?>");
        }

        public XMLWriter(StreamWriter stream, string stylesheet)
        {
            writer = new XmlTextWriter(stream);
            writer.Formatting = Formatting.Indented;
            writer.WriteProcessingInstruction("xml-stylesheet", string.Format(" type='text/xsl' href='{0}'", stylesheet));
        }

        #endregion

        #region destructors

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }


        public virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                writer.Dispose();
            }
        }
        #endregion

    }

    class XmlResolver : XmlUrlResolver
    {
        internal const string BaseUri = "schema://";

        public override object GetEntity(Uri absoluteUri, string role, Type ofObjectToReturn)
        {
            if (absoluteUri.Scheme == "schema")
            {
                switch (absoluteUri.LocalPath)
                {
                    case "/cpesic_v1.0.xsd":
                        return new MemoryStream(Encoding.UTF8.GetBytes(Properties.Resources.cpesic_v1_0));
                    case "/cdssb-bc_v1.1.xsd":
                        return new MemoryStream(Encoding.UTF8.GetBytes(Properties.Resources.cdssb_bc_v1_1));
                    case "/cdssb-bt_v1.1.xsd":
                        return new MemoryStream(Encoding.UTF8.GetBytes(Properties.Resources.cdssb_bt_v1_1));
                }
            }
            return base.GetEntity(absoluteUri, role, ofObjectToReturn);
        }
    }

}
