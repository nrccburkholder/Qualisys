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


        /// <summary>
        /// Creates and saves files
        /// </summary>
        public static void  MakeFiles()
        {
            int iCnt = 0; // file counter

            //TODO:  read targetFileLocation from Params table.
            string targetFileLocation = ConfigurationManager.AppSettings["FileLocation"].ToString();

            List<ExportQueueFile> queuefiles = ExportQueueFileProvider.SelectPendingQueueFiles();
            //foreach (ExportQueueFile queuefile in queuefiles.Where(x => x.FileMakerDate == null))
            foreach (ExportQueueFile queuefile in queuefiles)
            {
                List<ExportQueue> queues = ExportQueueProvider.Select(new ExportQueue { ExportQueueID = queuefile.ExportQueueID });

                foreach (ExportQueue queue in queues)
                {
                    ExportTemplate template = ExportTemplateProvider.Select(new ExportTemplate { ExportTemplateVersionMajor = queue.ExportTemplateVersionMajor, ExportTemplateVersionMinor = queue.ExportTemplateVersionMinor }).First();

                    DataSet ds = ExportDataProvider.Select(queue.ExportQueueID, template.ExportTemplateID);

                    if (ds.Tables.Count > 0)
                    {                       
                        string filename = template.DefaultNamingConvention;
                        SetFileName(ref filename, ds.Tables[0]);
                        
                        //TODO:  will need to check the expected filetype and create the file based on that.  For now, just handling XML.
                       
                        if (MakeXMLFile(ds, filename, targetFileLocation, template, queuefile))
                        {
                            int iCounter = 0;

                            if (!queuefile.IsValid) 
                            { 
                                foreach (ExportValidationError eve in queuefile.ValidationErrorList)
                                {
                                    iCounter += 1;
                                    //TODO:  what do we want to do with the validation messages?
                                    Console.WriteLine("{0}. {1}: {2}", iCounter.ToString(), eve.FileName, eve.ErrorDescription);
                                }

                                Logs.Info(string.Format("{0} created with validation errors.", queuefile.FileMakerName));
                            }
                            else 
                            {
                                Logs.Info(string.Format("{0} created successfully.", queuefile.FileMakerName));
                            }
                        }

                    }
                }
            }

            Logs.Info(string.Format("Export.MakeFiles: {0} files processed.", iCnt.ToString()));

        } 
           

        /// <summary>
        /// Creates an XML file from the ExportDataSet.  Returns boolean indicating if the file was created successfully or not.
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="filename"></param>
        /// <param name="fileLocation"></param>
        /// <param name="template"></param>
        /// <param name="queuefile"></param>
        /// <returns>Boolean indicating if the file was created successfully or not.</returns>
        private static bool MakeXMLFile(DataSet ds, string filename, string fileLocation, ExportTemplate template, ExportQueueFile queuefile)
        {
            bool b = false;
            string filepath = string.Empty;
           // ValidationErrorList.Clear();

            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);

                if (ValidateXML(xmlDoc, template, filename, queuefile))
                {
                    filepath = fileLocation;
                }
                else
                {
                    // xml did not validate.  set filepath so the file gets written to the error folder
                    filepath = Path.Combine(fileLocation, "error");
                }

                if (!Directory.Exists(filepath))
                {
                    Directory.CreateDirectory(filepath);
                }

                filepath = Path.Combine(filepath, filename + ".xml");

                xmlDoc.Save(filepath);

                queuefile.FileMakerName = filepath;
                queuefile.FileMakerDate = DateTime.Now;
                queuefile.Save();

                b = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return b;
        }

        /// <summary>
        /// Validates the XML against the template's xsd.
        /// </summary>
        /// <param name="xmlDoc"></param>
        /// <param name="template"></param>
        /// <param name="filename"></param>
        /// <param name="queuefile"></param>
        /// <returns></returns>
        private static bool ValidateXML(XmlDocument xmlDoc, ExportTemplate template, string filename, ExportQueueFile queuefile)
        {
            bool isValid = true;
            string xsd = template.XMLSchemaDefinition;

            XmlSchema schema = XmlSchema.Read(new StringReader(xsd), null);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns, XmlReader.Create(new StringReader(xsd)));

            XDocument xDoc = XDocument.Parse(xmlDoc.OuterXml);

            xDoc.Validate(schemas, (o, e) =>
            {
                //TODO:  Log validations errors
                //Console.WriteLine("\tValidation error: {0}", e.Message);
                queuefile.ValidationErrorList.Add(new ExportValidationError(filename, e.Message, template));
                isValid = false;
            });

            return isValid;
        }

        /// <summary>
        /// Sets the filename using the template's defaultnamingconvention and replaces the placeholders
        /// with the data values from the header record.
        /// </summary>
        /// <param name="defaultname"></param>
        /// <param name="dt"></param>
        private static void SetFileName(ref string defaultname, DataTable dt)
        {
            int iBracketStart = 0;
            int iBracketEnd = 0;

            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                if (defaultname.Contains("{"))
                {
                    iBracketStart = defaultname.IndexOf("{");

                    while (iBracketStart != -1)
                    {
                        iBracketEnd = defaultname.IndexOf("}", iBracketStart);

                        int iPlaceHolderLength = (iBracketEnd - iBracketStart) + 1;

                        string fieldname = defaultname.Substring(iBracketStart + 1, (iBracketEnd - iBracketStart) - 1);

                        string replacementValue = dr[fieldname].ToString();

                        defaultname = defaultname.Replace(defaultname.Substring(iBracketStart, iPlaceHolderLength), replacementValue);

                        iBracketStart = defaultname.IndexOf("{");

                    }
                }
            }
        }

    }

}
