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
//using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace CEM.Exporting.XmlExporters
{

    public class XMLExporter_ICH: BaseXmlExporter
    {

        #region constructors

        public XMLExporter_ICH(): base()
        {

        }

        #endregion

        public override XmlDocumentEx MakeExportXMLDocument(List<ExportDataSet> ds, ExportTemplate template)
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

                        if (ds[0].DataTable.Rows.Count > 0)
                        {
                            WriteHeaderSection(ds[0].DataTable, writer, headerNode);

                            if (ds.Count < 2)
                            {
                                throw new Exception("Patient level result set is missing.");
                            }

                            recordCount = WritePatientLevelSection(ds, writer, patientLevelNode);
                        }
                        else throw new Exception("Header level result set is missing");

                        writer.EndElement();

                        XmlDocumentEx returnXMLdoc = new XmlDocumentEx();
                        returnXMLdoc.Schemas.Add(schema);
                        returnXMLdoc.LoadXml(writer.XmlString);

                        returnXMLdoc.Validate();

                        return returnXMLdoc;
                    }

            } else return null;
        }

        private void WriteHeaderSection(DataTable dt, XMLWriter writer, XmlNode node)
        {

            writer.StartElement(node.Name);

            foreach (XmlNode childnode in node.ChildNodes)
            {
                CreateElementString(dt.Rows[0], string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            writer.EndElement();
        }

        private int WritePatientLevelSection(List<ExportDataSet> ds, XMLWriter writer, XmlNode node)
        {
            int count = 0;

            foreach (DataRow dr in ds[1].DataTable.Rows)
            {
                writer.StartElement(node.Name);

                WriteAdminSection(dr, writer, node.FirstChild);

                string searchExpression = string.Format("SamplePopulationID={0}",dr["SamplePopulationID"].ToString());
                DataRow prRow = ds[2].DataTable.Select(searchExpression)[0];

                if (!AreAllColumnsEmpty(prRow, new int[]{0}))
                {
                    WritePatientResponseSection(prRow, writer, node.LastChild);
                }
         
                writer.EndElement();

                count += 1;
            }

            return count;
        }

        private void WriteAdminSection(DataRow dr, XMLWriter writer, XmlNode node)
        {
            writer.StartElement(node.Name);

            foreach (XmlNode childnode in node.ChildNodes)
            {
                CreateElementString(dr, string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            writer.EndElement();
        }

        private void WritePatientResponseSection(DataRow dr, XMLWriter writer, XmlNode node)
        {
            writer.StartElement(node.Name);

            foreach (XmlNode childnode in node.ChildNodes)
            {
                CreateElementString(dr, string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            writer.EndElement();
        }


    }


}
