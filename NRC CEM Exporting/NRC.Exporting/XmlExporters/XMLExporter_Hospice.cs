using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Schema;
using System.IO;
using System.Data;
using NRC.Logging;

namespace CEM.Exporting.XmlExporters
{
    public class XMLExporter_Hospice: BaseXmlExporter
    {

        #region private members

        #endregion

        #region constructors

        public XMLExporter_Hospice(): base()
        {

        }

        #endregion


        public override XmlDocumentEx MakeExportXMLDocument(List<ExportDataSet> ds, ExportTemplate template)
        {

            if (ds.Count > 0)
            {
                Encoding encoding = new UTF8Encoding(false);

                //string xsdString = System.IO.File.ReadAllText(@"C:\gitrepo\Qualisys\NRC CEM.FileMaker Solution\FileMakerServiceTester\XMLSchema1.xsd");
                //XmlSchema schema = XmlSchema.Read(new StringReader(xsdString), null);
                string xsdString = template.XMLSchemaDefinition;
                XmlSchema schema = XmlSchema.Read(new StringReader(xsdString), null);
                schema.Compile(ValidationCallBack);

                // we create an empty xml from the schema definition so we can walk the elements for each node to help us build the final output Xml
                XMLDoc.LoadXml(GenerateEmptyXMLFromSchema(schema));

                //string xmlString = System.IO.File.ReadAllText(@"C:\gitrepo\Qualisys\NRC CEM.FileMaker Solution\FileMakerServiceTester\Hopsice Cahps Empty XML 2.1");
                //XMLDoc.LoadXml(xmlString);

                using (XMLWriter writer = new XMLWriter())
                {

                    writer.WriteCommentstring("CAHPS Hospice Survey XML File Specification Version 1.1");

                    XmlNode node = XMLDoc.GetElementsByTagName("vendordata")[0];

                    if (ds[0].DataTable.Rows.Count > 0)
                    {
                        WriteVendorSection(ds, writer,schema);
                    }
                    else throw new Exception("Vendor level result set is missing");


                    XmlDocumentEx returnXMLdoc = new XmlDocumentEx();
                    returnXMLdoc.Schemas.Add(schema);
                    returnXMLdoc.LoadXml(writer.XmlString);

                    returnXMLdoc.Validate();

                    return returnXMLdoc;
                }

            }
            else return null;
        }

        private void WriteVendorSection(List<ExportDataSet> dsList, XMLWriter writer, XmlSchema schema)
        {
            XmlNode node = XMLDoc.GetElementsByTagName("vendordata")[0];

            writer.StartElement(node.Name);


            ExportDataSet vendorDataSet = dsList[0];
            
            foreach (XmlNode childnode in node.ChildNodes)
            {
                CreateElementString(vendorDataSet.DataTable.Rows[0], string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
            }

            if (dsList[1].DataTable.Rows.Count > 0)
            {
                WriteHopsiceSection(dsList, writer);
            }
            else throw new Exception("Hospice level result set is missing");

            if (dsList[2].DataTable.Rows.Count > 0)
            {
                WriteDecedentLevelSection(dsList, writer);
            }
            else throw new Exception("Decendent level result set is missing");

            

            writer.EndElement();
        }

        private void WriteHopsiceSection(List<ExportDataSet> dsList, XMLWriter writer)
        {

            XmlNode node = XMLDoc.GetElementsByTagName("hospicedata")[0];

            // group by reference-month, reference-yr, and provider-id
            var distinctRows = dsList[1].DataTable.AsEnumerable().GroupBy(x => new { referenceMonth = x.Field<string>("hospicedata.reference-month"), referenceYear = x.Field<string>("hospicedata.reference-yr"), providerId = x.Field<string>("hospicedata.provider-id") }).Select(grp => grp.First());
  
            foreach (object dr in distinctRows)
            {
                writer.StartElement(node.Name);

                foreach (XmlNode childnode in node.ChildNodes)
                {
                    CreateElementString((DataRow)dr, string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
                }

                writer.EndElement();

            }
        }

        private void WriteDecedentLevelSection(List<ExportDataSet> dsList, XMLWriter writer)
        {
            XmlNode node = XMLDoc.GetElementsByTagName("decedentleveldata")[0];

            try
            {
                foreach (DataRow dr in dsList[2].DataTable.Rows)
                {
                    
                    if (AreAllColumnsEmpty(dr) == false) // check the columns of the datarow.  If all of them are NULL or blank, then we do not write the node
                    {
                        writer.StartElement(node.Name);

                        foreach (XmlNode childnode in node.ChildNodes)
                        {
                            CreateElementString(dr, string.Format("{0}.{1}", node.Name, childnode.Name), childnode.Name, writer);
                        }

                        string provider_id = dr["decedentleveldata.provider-id"].ToString();
                        string decedent_id = dr["decedentleveldata.decedent-id"].ToString();

                        string searchExpression = string.Format("[caregiverresponse.provider-id]='{0}' and [caregiverresponse.decedent-id]='{1}'", provider_id, decedent_id);
                        DataRow prRow = dsList[3].DataTable.Select(searchExpression)[0];

                        if (AreAllColumnsEmpty(prRow, new int[] { 0, 1, 2 }) == false)
                        {
                            WriteCareGiverResponseSection(prRow, writer, node.LastChild);
                        }

                        writer.EndElement();
                    }
                }
            }

            catch (Exception ex)
            {
                Logs.Error("Hospice Decedent Error Creating XML file.", ex);
            }

        }

        private void WriteCareGiverResponseSection(DataRow dr, XMLWriter writer, XmlNode node)
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
