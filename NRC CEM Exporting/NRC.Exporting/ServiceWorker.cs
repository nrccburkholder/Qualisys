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

namespace NRC.Exporting
{
    public static class ServiceWorker
    {

        public static void Run()
        {
            MakeFiles();
        }


        private static void  MakeFiles()
        {
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
                        string filename = template.DefaultNamingConvention;
                        XMLExporter.SetFileName(ref filename, ds.Tables[0]);

                        string filepath = Path.Combine(@"C:\Users\tbutler\Documents\", filename + ".xml");

                        XmlDocument xmlDoc = new XmlDocument();
                        xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);

                        if (ValidateXML(xmlDoc, template.XMLSchemaDefinition))
                        {
                            xmlDoc.Save(filepath);
                            //Update ExportQueueFile with FileName and FileMakerDate
                            queuefile.FileMakerName = filepath;
                            queuefile.FileMakerDate = DateTime.Now;
                            queuefile.Save();
                        }
                        else Console.WriteLine("Validation errors encountered! File NOT created.");

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
                Console.WriteLine("\tValidation error: {0}", e.Message);
                isValid = false;
            });

            return isValid;
        }


    }
}
