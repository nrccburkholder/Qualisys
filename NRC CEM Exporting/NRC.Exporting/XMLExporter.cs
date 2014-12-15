using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.IO;
using System.Data;
using System.Xml.Schema;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace NRC.Exporting
{
    internal static class XMLExporter
    {

        public static XmlDocumentEx MakeExportXMLDocument(List<ExportDataSet> ds, ExportTemplate template)
        {
            int recordCount = 0;

            if (ds.Count > 0)
            {               
                Encoding encoding = new UTF8Encoding(false);

                XmlSchema schema = XmlSchema.Read(new StringReader(template.XMLSchemaDefinition), null);
                schema.Compile(ValidationCallBack);

                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(GenerateEmptyXMLFromSchema(schema));

                XmlNode headerNode = xmlDoc.GetElementsByTagName("header")[0];
                XmlNode patientLevelNode = xmlDoc.GetElementsByTagName("patientleveldata")[0];

                    using (XMLWriter writer = new XMLWriter())
                    {
                        XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;
                        writer.StartElement(root.Name);
                        writer.WriteAttribute("xmlns", schema.TargetNamespace);
                        writer.WriteAttribute("xmlns:xs", "http://www.w3.org/2001/XMLSchema-instance");

                        WriteHeaderSection(ds[0].DataTable, writer, headerNode);

                        if (ds.Count < 2)
                        {
                            throw new Exception("Patient level result set is missing.");
                        }

                        recordCount = WritePatientLevelSection(ds, writer, patientLevelNode);

                        writer.EndElement();

                        XmlDocumentEx returnXMLdoc = new XmlDocumentEx();
                        returnXMLdoc.Schemas.Add(schema);
                        returnXMLdoc.LoadXml(writer.XmlString);

                        returnXMLdoc.Validate();

                        return returnXMLdoc;
                    }

            } else return null;
        }

        private static void WriteHeaderSection(DataTable dt, XMLWriter writer, XmlNode node)
        {

            writer.StartElement(node.Name);

            foreach (XmlNode childnode in node.ChildNodes)
            {
                WriteElementString(dt.Rows[0], string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            writer.EndElement();
        }

        private static int WritePatientLevelSection(List<ExportDataSet> ds, XMLWriter writer, XmlNode node)
        {
            int count = 0;

            foreach (DataRow dr in ds[1].DataTable.Rows)
            {
                writer.StartElement(node.Name);

                WriteAdminSection(dr, writer, node.FirstChild);

                string searchExpression = string.Format("SamplePopulationID={0}",dr["SamplePopulationID"].ToString());
                DataRow prRow = ds[2].DataTable.Select(searchExpression)[0];

                if (!AreAllColumnsEmpty(prRow))
                {
                    WritePatientResponseSection(prRow, writer, node.LastChild);
                }
         
                writer.EndElement();

                count += 1;
            }

            return count;
        }

        private static void WriteAdminSection(DataRow dr, XMLWriter writer, XmlNode node)
        {
            writer.StartElement(node.Name);

            foreach (XmlNode childnode in node.ChildNodes)
            {
                WriteElementString(dr, string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            writer.EndElement();
        }

        private static void WritePatientResponseSection(DataRow dr, XMLWriter writer, XmlNode node)
        {
            writer.StartElement(node.Name);

            foreach (XmlNode childnode in node.ChildNodes)
            {
                WriteElementString(dr, string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            writer.EndElement();
        }

        private static void WriteElementString(DataRow dr, string fieldname, string nodename, XMLWriter writer)
        {
            try
            {
                string value = dr[fieldname].ToString();
                writer.WriteElementString(nodename, dr[fieldname] == DBNull.Value ? "M" : value);
            }
            catch { }

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

        private static void WriteOutXMLChildrenFromXSD(XmlSchemaObject xso, XmlTextWriter writer)
        {
            if (xso.GetType().Equals(typeof(XmlSchemaElement)))
            {
                // Do something with an element.

                XmlSchemaElement xse = (XmlSchemaElement)xso;

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
                        }
                    }

                    // Get the sequence particle of the complex type.
                    XmlSchemaSequence sequence = complexType.ContentTypeParticle as XmlSchemaSequence;

                    if (sequence != null)
                    {
                        // Iterate over each XmlSchemaElement in the Items collection. 
                        foreach (XmlSchemaObject childElement in sequence.Items)
                        {
                            WriteOutXMLChildrenFromXSD(childElement, writer);
                        }
                    }
                }

                writer.WriteEndElement();
            }
        }

        private static void ValidationCallBack(object sender, ValidationEventArgs args)
        {
            //Console.WriteLine("\tValidation error: {0}", args.Message);

            XmlDocumentEx xmlDoc = (XmlDocumentEx)sender;

            xmlDoc.ValidationErrorList.Add(new ExportValidationError(args.Message));
        }

        private static bool AreAllColumnsEmpty(DataRow row)
        {           
            // start with second column because first column is SamplePopulationID
            for (int i = 1; i < row.Table.Columns.Count; i++)
            {
                if (row[i].ToString().Trim().Length > 0)
                    return false;
            }
           return true;
        }
    }


    internal class XMLWriter: IDisposable
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
