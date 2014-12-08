using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting.DataProviders;
using System.Data;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;
using System.Configuration;
using ServiceLogging;

namespace NRC.Exporting
{
    public static class Exporter
    {

        public static void  MakeFiles()
        {
            string fileLocation = ConfigurationManager.AppSettings["FileLocation"].ToString();
            List<ExportQueueFile> queuefiles = ExportQueueFileProvider.Select(new ExportQueueFile());

            foreach (ExportQueueFile queuefile in queuefiles.Where(x => x.FileMakerDate == null))
            {
                List<ExportQueue> queues = ExportQueueProvider.Select(new ExportQueue { ExportQueueID = queuefile.ExportQueueID });

                foreach (ExportQueue queue in queues)
                {
                    ExportTemplate template = ExportTemplateProvider.Select(new ExportTemplate { ExportTemplateVersionMajor = queue.ExportTemplateVersionMajor, ExportTemplateVersionMinor = queue.ExportTemplateVersionMinor }).First();

                    DataSet ds = ExportDataProvider.Select(queue.ExportQueueID, template.ExportTemplateID);

                    if (ds.Tables.Count > 0)
                    {
                        //TODO:  will need to check the expected filetype and create the file based on that.  For now, just handling XML.

                        string filename = template.DefaultNamingConvention;
                        XMLExporter.SetFileName(ref filename, ds.Tables[0]);

                        string filepath = Path.Combine(fileLocation, filename + ".xml");

                        XmlDocument xmlDoc = new XmlDocument();
                        xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);
                        xmlDoc.Save(filepath);

                        if (ValidateXML(xmlDoc, template.XMLSchemaDefinition))
                        {
                            
                            //Update ExportQueueFile with FileName and FileMakerDate
                            queuefile.FileMakerName = filepath;
                            queuefile.FileMakerDate = DateTime.Now;
                            queuefile.Save();
                        }

                    }
                }

            }

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xmlDoc"></param>
        /// <param name="xsd"></param>
        /// <returns></returns>
        private static bool ValidateXML(XmlDocument xmlDoc, string xsd)
        {
            bool isValid = true;

            XmlSchema schema = XmlSchema.Read(new StringReader(xsd), null);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns, XmlReader.Create(new StringReader(xsd)));

            XDocument xDoc = XDocument.Parse(xmlDoc.OuterXml);

            xDoc.Validate(schemas, (o, e) =>
            {
                //TODO:  Log validations errors
                Console.WriteLine("\tValidation error: {0}", e.Message);
                isValid = false;
            });

            return isValid;
        }


    }
}
