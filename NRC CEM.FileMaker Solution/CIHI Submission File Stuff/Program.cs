using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;
using GenerateSchema;
using System.CodeDom;
using Microsoft.CSharp;
using System.IO;
using System.Xml.Linq;
using System.Data;
using ConsoleApplication1.DataProviders;
using ConsoleApplication1.Classes;


/*
 * To use xsd from the Visual Studio Command Prompt
 * xsd C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xsd -language:CS /classes /outputdir:C:\Users\tbutler\Documents 
 * 
 * 
 */

namespace ConsoleApplication1
{
    class Program
    {
        private static bool isValid = true;      // If a validation error occurs,
                                         // set this flag to false in the
                                         // validation event handler. 
        static int ErrorsCount;
        static XmlTextWriter XMLOutWriter;
        static List<string> MissingColumns;
        static List<string> FoundColumns;


        public enum NestingType
        {

            RussianDoll,

            SeparateComplexTypes

        }

        static void Main(string[] args)
        {
            Console.WriteLine("Press return to start");
            Console.ReadLine();

            Start();

            Console.WriteLine("Press return to exit");
            Console.ReadLine();

        }

        static void Start()
        {

           // string xmlstring =  GenerateXMLFromXSD();


            string xmlOutputFile = @"C:\TEMP\CIHI_submission_file_test.xml";
            string xsd = @"C:\Users\tbutler\Documents\cpesic-submission_v1.0.xsd";
            //string xsd = @"C:\Users\tbutler\Documents\CPES-IC-non-stratified-sample (October 2014)2.xsd";
            //string xsd = @"C:\Users\tbutler\Documents\ICH_Data_Submission_Standard_20141219.xsd";

            //CreateEmptyXMLFromXSD(xmlOutputFile, xsd);
            string xmlOutputFile1 = @"C:\TEMP\CIHI_submission_file.xml";
            string xmlOutputFile2 = @"C:\TEMP\CIHI_submission_file_update.xml";
            string xmlOutputFile3 = @"C:\TEMP\CIHI_submission_file_delete.xml";

            MakeExportXMLDocument(xmlOutputFile1, xsd, 1);
            MakeExportXMLDocument(xmlOutputFile2, xsd, 2);
            MakeExportXMLDocument(xmlOutputFile3, xsd, 3);

            //XmlDocumentEx xmlDoc = new XmlDocumentEx();

            //xmlDoc.Load(@"\\lnk0pusers01\users\tbutler\My Documents\CPES-IC-non-stratified-sample (December 2014).xml");

            //xmlDoc.l

            //xmlDoc.Validate();

            //if (!xmlDoc.IsValid)
            //{
            //    foreach (ExportValidationError eve in xmlDoc.ValidationErrorList)
            //    {
            //        //Logging to the database.  The elements of the message are pipe delimited, with the template name, queueid, queuefileid, the file name, and the validation error description
            //        Console.WriteLine(eve.ErrorDescription);


            //    }
            //}

            //Console.WriteLine(xmlstring);
            
            //ValidateXML();
            //ParseXSD();
            //WalkXSD();

            //exportTemplate = ExportTemplateProvider.Select(new ExportTemplate { ExportTemplateID = 1 }).First();

            //XmlSerializer x = new System.Xml.Serialization.XmlSerializer(exportTemplate.GetType());

            //x.Serialize(Console.Out, exportTemplate);

            //Console.WriteLine();

            //List<ExportTemplate> list = ExportTemplateProvider.Select(new ExportTemplate{ExportTemplateID = 1},true);

            //List<ExportTemplate> list = ExportTemplateProvider.Select(new ExportTemplate(), false);

            //exportTemplate = list[0];


            // Create XML from data
            //List<ExportQueueFile> queuefiles = ExportQueueFileProvider.Select(new ExportQueueFile());

            //foreach (ExportQueueFile queuefile in queuefiles.Where(x => x.FileMakerDate == null))
            //{
            //    List<ExportQueue> queues = ExportQueueProvider.Select(new ExportQueue { ExportQueueID = queuefile.ExportQueueID });

            //    foreach (ExportQueue queue in queues)
            //    {
            //        ExportTemplate template = ExportTemplateProvider.Select(new ExportTemplate { ExportTemplateVersionMajor = queue.ExportTemplateVersionMajor, ExportTemplateVersionMinor = queue.ExportTemplateVersionMinor }).First();

            //        DataSet ds = ExportDataProvider.Select(queue.ExportQueueID, template.ExportTemplateID);

            //        if (ds.Tables.Count > 0) 
            //        {
            //            string filename = template.DefaultNamingConvention;
            //            XMLExporter.SetFileName(ref filename, ds.Tables[0]);

            //            string filepath = Path.Combine(@"C:\Users\tbutler\Documents\", filename + ".xml");

            //            XmlDocument xmlDoc = new XmlDocument();
            //            xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);

            //            if (ValidateXML(xmlDoc, template.XMLSchemaDefinition))
            //            {
            //                xmlDoc.Save(filepath);
            //                //Update ExportQueueFile with FileName and FileMakerDate
            //                queuefile.FileMakerName = filepath;
            //                queuefile.FileMakerDate = DateTime.Now;
            //                queuefile.Save();
            //            }
            //            else Console.WriteLine("Validation errors encountered! File NOT created.");
 
            //        }
            //    }

            //}

            //List<ExportQueue> queues = ExportQueueProvider.Select(new ExportQueue());

            //string filepath =  @"C:\Users\tbutler\Documents\test.xml";

            //XMLExporter.CreateExportXMLFile(ExportDataProvider.Select(1), filepath, exportTemplate.XMLSchemaDefinition);

           //ValidateXML(filepath);

            //LoadXSDasXML();

            //if (!exportTemplate.ValidateAgainstXSD())
            //{
            //    foreach (string item in exportTemplate.MissingColumns)
            //    {
            //        Console.WriteLine(item);
            //    }
            //}
            //else { Console.WriteLine("ExportTemplate validated successfully with XSD."); }

            //Console.WriteLine("MISSING");
            //foreach (string item in MissingColumns)
            //{
            //    Console.WriteLine(item);
            //}
            //Console.WriteLine("----------------------");
            //Console.WriteLine("FOUND");
            //foreach (string item in FoundColumns)
            //{
            //    Console.WriteLine(item);
            //}



            //SchemaBuilder sb = new SchemaBuilder();

            //string xml = @"C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xml";
            //xml = @"C:\Users\tbutler\Documents\XMLFile1.xml";


            //string schema = sb.BuildSchema(xml, GenerateSchema.NestingType.RussianDoll);

            //Console.WriteLine(schema);

            //File.WriteAllText(@"C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xsd", schema);


            //sb.MakeObject(schema);

        }

       

        static bool ValidateXML()
        {

            string xsd = @"C:\Users\tbutler\Documents\ICH_Data_Submission_Standard.xsd";
            XmlSchema schema = new XmlSchema();
            schema = GetXSDFileAsXMLSchema(xsd);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns,xsd);

            XmlReaderSettings schemaSettings = new XmlReaderSettings();
            schemaSettings.ValidationType = ValidationType.Schema;
            schemaSettings.ValidationFlags |= XmlSchemaValidationFlags.ReportValidationWarnings;
            schemaSettings.ValidationEventHandler += new ValidationEventHandler(ValidationCallBack);
            schemaSettings.Schemas.Add(null, xsd);

            //string xml = @"C:\Users\tbutler\Documents\XMLFile1.xml";
            string xml = @"C:\Users\tbutler\Documents\_HHCAHPS_XML_Sample_File.xml";
            //string xml = @"C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xml";

            using (XmlReader xmlreader = XmlReader.Create(xml, schemaSettings))
            {
                while (xmlreader.Read()) { }
            }

            // Check whether the document is valid or invalid.
            if (isValid)
                Console.WriteLine("Document is valid");
            else
                Console.WriteLine("Document is invalid");

            return isValid;
        }

        static bool ValidateXML(string filepath)
        {
            //string xsd = @"C:\Users\tbutler\Documents\HHCAHPS_XML_Sample_File.xsd";
            string xsd = @"C:\Users\tbutler\Documents\ICH_Data_Submission_Standard_20140814.xsd";
            XmlSchema schema = new XmlSchema();
            schema = GetXSDFileAsXMLSchema(xsd);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns, xsd);

            XmlReaderSettings schemaSettings = new XmlReaderSettings();
            schemaSettings.ValidationType = ValidationType.Schema;
            schemaSettings.ValidationFlags |= XmlSchemaValidationFlags.ReportValidationWarnings;
            schemaSettings.ValidationEventHandler += new ValidationEventHandler(ValidationCallBack);
            schemaSettings.Schemas.Add(null, xsd);

            using (XmlReader xmlreader = XmlReader.Create(filepath, schemaSettings))
            {
                while (xmlreader.Read()) { }
            }

            // Check whether the document is valid or invalid.
            if (isValid)
                Console.WriteLine("Document is valid");
            else
                Console.WriteLine("Document is invalid");

            return isValid;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="xmlDoc"></param>
        /// <param name="xsd"></param>
        /// <returns></returns>
        static bool ValidateXML(XmlDocument xmlDoc, string xsd)
        {
            bool isValid = true;

            //XmlSchema schema = XmlSchema.Read(new StringReader(xsd), new ValidationEventHandler(ValidationCallBack));

            //XmlSchema schema = XmlSchema.Read(new StringReader(xsd), null);
            //string ns = schema.TargetNamespace;

            XmlSchema schema = new XmlSchema();
            schema = GetXSDFileAsXMLSchema(xsd);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns, xsd);
            //schemas.Add(ns, XmlReader.Create(new StringReader(xsd)));

            XDocument xDoc = XDocument.Parse(xmlDoc.OuterXml);

            xDoc.Validate(schemas, (o, e) =>
            {
                Console.WriteLine("\tValidation error: {0}", e.Message);
                isValid = false;
            });

            return isValid;
        }

        static bool ValidateXML(string xsd, string xml)
        {

            XmlSchema schema = new XmlSchema();
            schema = GetXSDFileAsXMLSchema(xsd);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns, xsd);

            XmlReaderSettings schemaSettings = new XmlReaderSettings();
            schemaSettings.ValidationType = ValidationType.Schema;
            schemaSettings.ValidationFlags |= XmlSchemaValidationFlags.ReportValidationWarnings;
            schemaSettings.ValidationEventHandler += new ValidationEventHandler(ValidationCallBack);
            schemaSettings.Schemas.Add(null, xsd);

            using (XmlReader xmlreader = XmlReader.Create(xml, schemaSettings))
            {
                while (xmlreader.Read()) { }
            }

            // Check whether the document is valid or invalid.
            if (isValid)
                Console.WriteLine("Document is valid");
            else
                Console.WriteLine("Document is invalid");

            return isValid;
        }

        static void ParseXSD()
        {

            string xmlOutputFile = @"C:\Users\tbutler\Documents\Test_ICH_Data_Submission_Standard.xml";
            XMLOutWriter = new XmlTextWriter(xmlOutputFile, System.Text.Encoding.UTF8);
            XMLOutWriter.WriteStartDocument();
            

            string xsd = @"C:\Users\tbutler\Documents\ICH_Data_Submission_Standard.xsd";

            XmlSchema schema = new XmlSchema();
            schema = GetXSDFileAsXMLSchema(xsd);
            string ns = schema.TargetNamespace;
            // Iterate over each XmlSchemaElement in the Values collection 
            // of the Elements property. 
            XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;

            XMLOutWriter.WriteStartElement(root.Name);
            XMLOutWriter.WriteAttributeString("xmlns", ns);

            XmlSchemaSequence children = ((XmlSchemaComplexType)root.ElementSchemaType).ContentTypeParticle as XmlSchemaSequence;
            foreach (XmlSchemaObject child in children.Items.OfType<XmlSchemaElement>())
            {
                ParseXSDChildren(child, root.Name);      
            }

            XMLOutWriter.WriteEndElement();
            XMLOutWriter.WriteEndDocument();
            XMLOutWriter.Close();

            ValidateXML(xsd, xmlOutputFile);

        }

        static void ParseXSDChildren(XmlSchemaObject xso, string parentName)
        {
            
            if (xso.GetType().Equals(typeof(XmlSchemaElement)))
            {
                // Do something with an element.
          
                XmlSchemaElement xse = (XmlSchemaElement)xso;
                //Console.WriteLine("Parent: {0}   Element: {1}", parentName, xse.Name);

                XMLOutWriter.WriteStartElement(xse.Name);

                // Get the complex type of the element.
                XmlSchemaComplexType complexType = xse.ElementSchemaType as XmlSchemaComplexType;
            
                if (complexType == null )
                {
                    // it's a simple type, so no sub elements
                    //Console.WriteLine("simpletype");


                    //XmlSchemaSimpleType simpleType = xse.ElementSchemaType as XmlSchemaSimpleType;
                    //XmlSchemaSimpleTypeRestriction restriction = simpleType.Content as XmlSchemaSimpleTypeRestriction;

                    //Console.WriteLine("type: {0}", restriction.BaseTypeName.Name);
                    //var facets = restriction.Facets;

                    //foreach (var facet in facets)
                    //{
                    //    if (facet.GetType().Equals(typeof(XmlSchemaLengthFacet)))
                    //    {
                    //        Console.WriteLine("length: {0}", (facet as XmlSchemaLengthFacet).Value);
                    //    }
                    //    if (facet.GetType().Equals(typeof(XmlSchemaMinLengthFacet)))
                    //    {
                    //        Console.WriteLine("Minlength: {0}", (facet as XmlSchemaMinLengthFacet).Value);
                    //    }
                    //    if (facet.GetType().Equals(typeof(XmlSchemaMaxLengthFacet)))
                    //    {
                    //        Console.WriteLine("MaXlength: {0}", (facet as XmlSchemaMaxLengthFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaPatternFacet)))
                    //    {
                    //        Console.WriteLine("pattern: {0}", (facet as XmlSchemaPatternFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaNumericFacet)))
                    //    {
                    //        Console.WriteLine("number: {0}", (facet as XmlSchemaNumericFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaMinInclusiveFacet)))
                    //    {
                    //        Console.WriteLine("MinInclusive: {0}", (facet as XmlSchemaMinInclusiveFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaMinExclusiveFacet)))
                    //    {
                    //        Console.WriteLine("MinExclusive: {0}", (facet as XmlSchemaMinExclusiveFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaMaxInclusiveFacet)))
                    //    {
                    //        Console.WriteLine("MaxInclusive: {0}", (facet as XmlSchemaMaxInclusiveFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaMaxExclusiveFacet)))
                    //    {
                    //        Console.WriteLine("MaxExclusive: {0}", (facet as XmlSchemaMaxExclusiveFacet).Value);
                    //    }
                    //    else if (facet.GetType().Equals(typeof(XmlSchemaEnumerationFacet)))
                    //    {
                    //        Console.WriteLine("enumeration: {0}", (facet as XmlSchemaEnumerationFacet).Value);
                    //    }
                    //}

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

                            //Console.WriteLine("Attribute: {0}", attribute.Name);
                        }
                    }


                    // Get the sequence particle of the complex type.
                    XmlSchemaSequence sequence = complexType.ContentTypeParticle as XmlSchemaSequence;

                    if (sequence != null)
                    {
                        // Iterate over each XmlSchemaElement in the Items collection. 
                        foreach (XmlSchemaObject childElement in sequence.Items)
                        {
                            //Console.WriteLine("Child Element: {0}", childElement.Name);
                            ParseXSDChildren(childElement, xse.Name);
                        }
                    }
                }

                XMLOutWriter.WriteEndElement();
            }
            
        }


        static string GenerateXMLFromXSD()
        {

            string xmlString = string.Empty;
            XmlDocument xDoc = new XmlDocument();

            using (StringWriter sw = new StringWriter())
            {

                XMLOutWriter = new XmlTextWriter(sw);
                XMLOutWriter.WriteStartDocument();

                string xsd = @"C:\Users\tbutler\Documents\ICH_Data_Submission_Standard_20141219.xsd";
                
               // XmlSchema schema = XmlSchema.Read(new StringReader(xsd), new ValidationEventHandler(ValidationCallBack));

                XmlSchema schema = new XmlSchema();
                schema = GetXSDFileAsXMLSchema(xsd);

                schema.Compile(ValidationCallBack);
                string ns = schema.TargetNamespace;
                // Iterate over each XmlSchemaElement in the Values collection 
                // of the Elements property. 
                XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;

                XMLOutWriter.WriteStartElement(root.Name);
                XMLOutWriter.WriteAttributeString("xmlns", ns);

                XmlSchemaSequence children = ((XmlSchemaComplexType)root.ElementSchemaType).ContentTypeParticle as XmlSchemaSequence;
                foreach (XmlSchemaObject child in children.Items.OfType<XmlSchemaElement>())
                {
                    WriteOutXMLChildrenFromXSD(child);
                }

                XMLOutWriter.WriteEndElement();
                XMLOutWriter.WriteEndDocument();
                XMLOutWriter.Close();

                xmlString = sw.ToString();
            }

            return xmlString;
        }


        static void CreateEmptyXMLFromXSD(string xmlOutputFile, string xsd)
        {
            
            XMLOutWriter = new XmlTextWriter(xmlOutputFile, System.Text.Encoding.UTF8);
            XMLOutWriter.WriteStartDocument();


            XmlSchema schema = new XmlSchema();
            schema = GetXSDFileAsXMLSchema(xsd);
            string ns = schema.TargetNamespace;
            // Iterate over each XmlSchemaElement in the Values collection 
            // of the Elements property. 
            XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;

            XMLOutWriter.WriteStartElement(root.Name);
            XMLOutWriter.WriteAttributeString("xmlns", ns);

            XmlSchemaSequence children = ((XmlSchemaComplexType)root.ElementSchemaType).ContentTypeParticle as XmlSchemaSequence;
            foreach (XmlSchemaObject child in children.Items.OfType<XmlSchemaElement>())
            {
                WriteOutXMLChildrenFromXSD(child);
            }

            XMLOutWriter.WriteEndElement();
            XMLOutWriter.WriteEndDocument();
            XMLOutWriter.Close();

            ValidateXML(xsd, xmlOutputFile);
        }

        static void WriteOutXMLChildrenFromXSD(XmlSchemaObject xso, string parentName = null)
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

                
                XMLOutWriter.WriteStartElement(xse.Name);

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
                            //if (attribute.Use !=  XmlSchemaUse.Optional){

                                if (attribute.AttributeSchemaType.Datatype != null)
                                {

                                    string attributeDataType = attribute.AttributeSchemaType.Datatype.GetType().Name;

                                    //string attrValue = string.Empty;
                                    //if (attributeDataType.Contains("string"))
                                    //{
                                    //    attrValue = "y";
                                    //}
                                    //else if (attributeDataType.Contains("integer"))
                                    //{
                                    //    attrValue = "1";
                                    //}

                                    XMLOutWriter.WriteAttributeString(attribute.Name, "");
                                }

                                
                            //}                            
                        }
                    }

                    // Get the sequence particle of the complex type.
                    XmlSchemaSequence sequence = complexType.ContentTypeParticle as XmlSchemaSequence;

                    if (sequence != null)
                    {
                        // Iterate over each XmlSchemaElement in the Items collection. 
                        foreach (XmlSchemaObject childElement in sequence.Items)
                        {
                            WriteOutXMLChildrenFromXSD(childElement, fullname);
                        }
                    }
                }

               //if (xse.ElementSchemaType.Datatype != null)
               //{ 
               //     string elementDataType = xse.ElementSchemaType.Datatype.GetType().Name;

               //     string elementValue = GetDataValue(fullname, elementDataType);

               //     XMLOutWriter.WriteString(elementValue);
               // }
               

                XMLOutWriter.WriteEndElement();
            }
        }

        static XmlSchema GetXSDFileAsXMLSchema(string xsd)
        {

            FileStream fs = new FileStream(xsd, FileMode.Open);
            XmlSchema schema = XmlSchema.Read(fs, new ValidationEventHandler(ValidationCallBack));
            fs.Close();
            schema.Compile(ValidationCallBack);
            return schema;
        }

        //static void ValidationCallBack(object sender, ValidationEventArgs args)
        //{   
        //    Console.WriteLine("\tValidation error: {0}", args.Message);
        //    isValid = false;
        //}

        private static void ValidationCallBack(object sender, ValidationEventArgs args)
        {
            //Console.WriteLine("\tValidation error: {0}", args.Message);

            XmlDocumentEx xmlDoc = (XmlDocumentEx)sender;

            xmlDoc.ValidationErrorList.Add(new ExportValidationError(args.Message));
        }


        //static ExportTemplate GetTemplate(int id)
        //{

        //    Exporter exp = new Exporter();

        //    ExportTemplate template = exp.GetExportTemplates().First(x => x.ExportTemplateID == 1);
        //    return template;
        //}


        //static List<ExportTemplate> GetTemplates()
        //{
        //    Exporter exp = new Exporter();

        //    List<ExportTemplate> templates = new List<ExportTemplate>();

        //    templates = exp.GetExportTemplates();

        //    return templates;
        //}

        //static void WalkXSD()
        //{
        //    MissingColumns = new List<string>();
        //    FoundColumns = new List<string>();
        //    exportTemplate = GetTemplate(1);

        //    string xsd = exportTemplate.XMLSchemaDefinition; // @"C:\Users\tbutler\Documents\ICH_Data_Submission_Standard_20140814.xsd";

        //    XmlSchema schema = XmlSchema.Read(new StringReader(xsd), new ValidationEventHandler(ValidationCallBack));
        //    schema.Compile(ValidationCallBack);
        //    string ns = schema.TargetNamespace;
        //    // Iterate over each XmlSchemaElement in the Values collection 
        //    // of the Elements property. 
        //    XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;


        //    XmlSchemaSequence children = ((XmlSchemaComplexType)root.ElementSchemaType).ContentTypeParticle as XmlSchemaSequence;
        //    foreach (XmlSchemaObject child in children.Items.OfType<XmlSchemaElement>())
        //    {
        //        WalkXSDChildren(child, root.Name);
        //    }

        //}

        //static void WalkXSDChildren(XmlSchemaObject xso, string parentName)
        //{

        //    if (xso.GetType().Equals(typeof(XmlSchemaElement)))
        //    {
        //        XmlSchemaElement xse = (XmlSchemaElement)xso;

        //        // Get the complex type of the element.
        //        XmlSchemaComplexType complexType = xse.ElementSchemaType as XmlSchemaComplexType;

        //        if (complexType == null)
        //        {
        //            // it's a simple type, so no sub elements
        //            XmlSchemaElement parent = GetParentElement(xse);

        //            bool HasMatchingColumn = exportTemplate.IsExist(xse.Name);

        //            if (HasMatchingColumn)
        //            { FoundColumns.Add(parent.Name + ":" + xse.Name); }
        //            else
        //            { MissingColumns.Add(parent.Name + ":" + xse.Name); }

        //        }
        //        else
        //        {
        //            // If the complex type has any attributes, get an enumerator  
        //            // and write each attribute name to the console. 
        //            if (complexType.AttributeUses.Count > 0)
        //            {
        //                IDictionaryEnumerator enumerator = complexType.AttributeUses.GetEnumerator();

        //                while (enumerator.MoveNext())
        //                {
        //                    XmlSchemaAttribute attribute = (XmlSchemaAttribute)enumerator.Value;
        //                }
        //            }

        //            // Get the sequence particle of the complex type.
        //            XmlSchemaSequence sequence = complexType.ContentTypeParticle as XmlSchemaSequence;
        //            if (sequence != null)
        //            {
        //                // Iterate over each XmlSchemaElement in the Items collection. 
        //                foreach (XmlSchemaObject childElement in sequence.Items)
        //                {
        //                    //Console.WriteLine("Child Element: {0}", childElement.Name);
        //                    WalkXSDChildren(childElement, xse.Name);
        //                }
        //            }
        //        }
        //    }
        //}

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

        static void LoadXSDasXML()
        {
            XmlDocument xDoc = new XmlDocument();
            xDoc.LoadXml(GenerateXMLFromXSD());

            XmlNodeList patientLevelNodeList = xDoc.GetElementsByTagName("patientleveldata");
            XmlNode headerNode = xDoc.GetElementsByTagName("header")[0];

            foreach (XmlNode node in headerNode.ChildNodes)
            {

                Console.WriteLine(string.Format("{0}.{1}", headerNode.Name, node.Name));

            }


            foreach (XmlNode node in patientLevelNodeList)
            {

                XmlNode adminNode = node.FirstChild;
                XmlNode responseNode = node.LastChild;
                foreach (XmlNode subnode in adminNode.ChildNodes)
                {
                    

                    Console.WriteLine(string.Format("{0}.{1}", subnode.ParentNode.Name, subnode.Name));

                }

                foreach (XmlNode subnode in responseNode.ChildNodes)
                {


                    Console.WriteLine(string.Format("{0}.{1}", subnode.ParentNode.Name, subnode.Name));

                }

            }        
        }

        static string GetDataValue(string elementname, string dataType)
        {

            string value = string.Empty;
            if (dataType.Contains("string"))
            {
                value = "x";
            }
            else if (dataType.Contains("integer"))
            {
                value = "1";
            }

            return value;

        }

        public static void MakeExportXMLDocument(string outputFileName, string xsd, int id = 1)
        {

            DataSet ds = new DataSet();

            ds = ExportProvider.SelectSubmissionMetadata(id);


            if (ds.Tables[0].Rows.Count > 0)
            {
                Encoding encoding = new UTF8Encoding(false);

                XmlSchema schema = new XmlSchema();
                schema = GetXSDFileAsXMLSchema(xsd);
                string ns = schema.TargetNamespace;
                schema.Compile(ValidationCallBack);

                XmlDocumentEx xmlDoc = new XmlDocumentEx();

                xmlDoc.LoadXml(GenerateEmptyXMLFromSchema(schema));

                using (XMLWriter writer = new XMLWriter())
                {
                    XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;
                    writer.StartElement(string.Format("{0}:{1}","cpesic",root.Name));
                    //writer.WriteAttribute("xmlns",schema.TargetNamespace);
                    writer.WriteAttribute("xmlns", "cpesic", null, schema.TargetNamespace);
                    writer.WriteAttribute("xmlns","xsi", null, "http://www.w3.org/2001/XMLSchema-instance");
                    writer.WriteAttribute("xsi", "schemaLocation", null, string.Format("{0} {1},", schema.TargetNamespace,"cpesic-submission_v1.0.xsd"));

                    XmlNode rootNode = xmlDoc.DocumentElement;

                    // DataSubmission section
                    WriteDataSubmissionSection(ds.Tables[0].Rows[0], writer, rootNode);

                    writer.EndElement();

                    XmlDocumentEx returnXMLdoc = new XmlDocumentEx();
                    returnXMLdoc.Schemas.Add(schema);
                    returnXMLdoc.LoadXml(writer.XmlString);
                    returnXMLdoc.Save(outputFileName);

                    returnXMLdoc.Validate();

                    if (!returnXMLdoc.IsValid)
                    {
                        foreach (ExportValidationError eve in returnXMLdoc.ValidationErrorList)
                        {
                            //Logging to the database.  The elements of the message are pipe delimited, with the template name, queueid, queuefileid, the file name, and the validation error description
                            Console.WriteLine(eve.ErrorDescription);
                        }
                    }
                    else 
                    {
                        
                        Console.WriteLine("This XML Validated successfully!");                      
                    }
                    Console.WriteLine();
                }
            }
            else throw new Exception("No SubmissionMetadata found!");
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

                    string value = dr[fieldName].ToString();
                    writer.WriteElementString(nameOfNode, dr[fieldName] == DBNull.Value ? "NULL" : value);
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
                    string value = dr[fieldname].ToString();
                    writer.WriteAttribute(attributename, dr[fieldname] == DBNull.Value ? "NULL" : value);
                }
            }
            catch (Exception ex) 
            { 
                throw ex; 
            }

        }

        #endregion

        #region CIHI xmlsections

        private static void WriteDataSubmissionSection(DataRow dr, XMLWriter writer, XmlNode parentNode)
        {


            WriteCreationTime(dr, writer, parentNode);

            WriteSenderSection(dr, writer, parentNode);

            WriteVersionSection(dr, writer, parentNode);

            WritePurposeSection(dr, writer, parentNode);


            int SubmissionFileID = Convert.ToInt32(dr["submissionFileID"]);

            DataSet dsOrgProfile = ExportProvider.SelectSubmission_OrgProfile(SubmissionFileID);

            WriteOrganizationProfileSection(dsOrgProfile, writer, parentNode);

            DataSet dsQuestionnaireCycle = ExportProvider.SelectSubmission_QuestionnaireCycle(SubmissionFileID);

            WriteQuestionnaireCycleSection(dsQuestionnaireCycle, writer, parentNode);


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

                    DataSet dsRole = ExportProvider.SelectSubmission_Role(Convert.ToInt32(dr["orgProfileID"]));

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
                int orgProfileID = Convert.ToInt32(dr["orgProfileID"]);
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

            writer.StartElement(node.Name);

            WriteElementString(dr, node, "value", writer);

            if (includeIssuer) {WriteIssuer(dr, writer, node);}

            writer.EndElement();

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

                    int questionnaireCycleID = Convert.ToInt32(dr["questionnaireCycleID"]);
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

            writer.StartElement(node.Name);

            WriteElementString(dr, node, "value", writer);

            WriteElementWithAttributes(dr, writer, node, "code");

            writer.EndElement();
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

             int questionnaireID = Convert.ToInt32(dr["questionnaireID"]);
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
}
