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
using System.Xml.Linq;
using CEM.Exporting;

namespace CEM.Exporting.XmlExporters
{
    abstract public class BaseXmlExporter
    {



        #region public members

        public XmlDocument XMLDoc;

        #endregion

        #region constructors

        public BaseXmlExporter()
        {
            XMLDoc = new XmlDocument();
        }

        #endregion


        abstract public XmlDocumentEx MakeExportXMLDocument(List<ExportDataSet> ds, ExportTemplate template);

        protected void CreateElementString(DataRow dr, string fieldname, string nodename, XMLWriter writer)
        {
            try
            {
                string value = dr[fieldname].ToString().Trim();
                writer.WriteElementString(nodename, dr[fieldname] == DBNull.Value ? "NULL" : value);
            }
            catch { }

        }

        protected string GenerateEmptyXMLFromSchema(XmlSchema schema)
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

        protected void WriteOutXMLChildrenFromXSD(XmlSchemaObject xso, XmlTextWriter writer)
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

        protected void ValidationCallBack(object sender, ValidationEventArgs args)
        {
            //Console.WriteLine("\tValidation error: {0}", args.Message);

            XmlDocumentEx xmlDoc = (XmlDocumentEx)sender;

            xmlDoc.ValidationErrorList.Add(new ExportValidationError(args.Message));
        }

        protected bool AreAllColumnsEmpty(DataRow row, int[] ignoreColumns)
        {
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {
                if (ignoreColumns.Contains(i) == false)
                {
                    if (string.IsNullOrWhiteSpace(row[i].ToString())== false)
                        return false;
                }       
            }
            return true;
        }

        protected bool AreAllColumnsEmpty(DataRow row)
        {
            for (int i = 0; i < row.Table.Columns.Count; i++)
            {

                if (string.IsNullOrWhiteSpace(row[i].ToString()) == false)
                    return false;

            }
            return true;
        }


    }



}
