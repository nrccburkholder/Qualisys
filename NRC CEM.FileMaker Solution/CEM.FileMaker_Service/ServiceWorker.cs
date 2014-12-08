using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting;
using NRC.Exporting.DataProviders;
using System.Data;
using System.IO;
using System.Xml.Linq;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;
using System.Configuration;
using ServiceLogging;

namespace CEM.FileMaker
{
    public static class ServiceWorker
    {

        public  static void MakeFiles()
        {
            //TODO:  change the location where fileLocation is stored from the appconfig to a param table
            string fileLocation = ConfigurationManager.AppSettings["FileLocation"].ToString();

            List<ExportQueueFile> queuefiles = ExportQueueFileProvider.Select(new ExportQueueFile());  // retrieves all queuefiles.  TODO: extend Select so that it returns only records where FileMakerDate is null

            foreach (ExportQueueFile queuefile in queuefiles.Where(x => x.FileMakerDate == null))  // will get only records of files not yet processed
            {
                List<ExportQueue> queues = ExportQueueProvider.Select(new ExportQueue { ExportQueueID = queuefile.ExportQueueID });

                foreach (ExportQueue queue in queues)
                {
                    // currently, the only way to retrieve a template based on the queue info is to use Major and Minor version, but I think we might need another key, such as template name.
                    ExportTemplate template = ExportTemplateProvider.Select(new ExportTemplate { ExportTemplateVersionMajor = queue.ExportTemplateVersionMajor, ExportTemplateVersionMinor = queue.ExportTemplateVersionMinor }).First();

                    DataSet ds = ExportDataProvider.Select(queue.ExportQueueID, template.ExportTemplateID);

                    if (ds.Tables.Count > 0)
                    {
                        string filename = template.DefaultNamingConvention;
                        XMLExporter.SetFileName(ref filename, ds.Tables[0]); // We get the subsitution info from the "header" record

                        string filepath = Path.Combine(fileLocation, filename + ".xml");

                        XmlDocument xmlDoc = new XmlDocument();
                        xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);

                        //TODO:  decide if we save the file even if it doesn't validate.
                        xmlDoc.Save(filepath);

                        Logs.Info("FileMakerService Tester Begin Work");

                        if (ValidateXML(xmlDoc, template.XMLSchemaDefinition))
                        {

                            //Update ExportQueueFile with FileName and FileMakerDate
                            queuefile.FileMakerName = filepath;
                            queuefile.FileMakerDate = DateTime.Now;
                            queuefile.Save();
                        }
                        else
                        {
                            Console.WriteLine("Validation errors encountered!");
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
                //TODO:  log validation errors
                Console.WriteLine("\tValidation error: {0}", e.Message);
                isValid = false;
            });

            return isValid;
        }





    }

}
