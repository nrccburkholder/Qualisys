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
using NRC.Exporting.Configuration;



namespace NRC.Exporting
{
    public static class Exporter
    {

        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();


        /// <summary>
        /// Creates and saves files
        /// </summary>
        public static void  MakeFiles()
        {
            int iCnt = 0; // file counter

            //TODO:  read targetFileLocation from Params table.
            //string targetFileLocation = ConfigurationManager.AppSettings["FileLocation"].ToString();

            string targetFileLocation = SystemParams.Params.GetParam("FileLocation").StringValue;

            //List<ExportQueueFile> queuefiles = ExportQueueFileProvider.Select(new ExportQueueFile()); // this would return ALL ExportQueueFiles regardless of their status.  We only want those that haven't been processed yet.
            //foreach (ExportQueueFile queuefile in queuefiles.Where(x => x.FileMakerDate == null))
            foreach (ExportQueueFile queuefile in ExportQueueFileProvider.SelectPendingQueueFiles())
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

                        switch (queuefile.FileMakerType)
	                    {
                            case (int)Enums.ExportFileTypes.Xml:
                                if (MakeXMLFile(ds, filename, targetFileLocation, template, queuefile))
                                {
                                    iCnt += 1;
                                }
                                break;

		                    default:
                                break;
	                    }
                    }
                }
            }

            logger.Info(string.Format("{0} file(s) processed.", iCnt.ToString()));
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
            try
            {
                XmlDocumentEx xmlDoc = new XmlDocumentEx();
                xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);

                filepath = xmlDoc.IsValid == true ? fileLocation : Path.Combine(fileLocation, "error");

                if (!Directory.Exists(filepath))
                {
                    Directory.CreateDirectory(filepath);
                }

                filepath = Path.Combine(filepath, filename + ".xml");

                xmlDoc.Save(filepath);

                int iCounter = 0;

                if (!xmlDoc.IsValid)
                {
                    foreach (ExportValidationError eve in xmlDoc.ValidationErrorList)
                    {
                        iCounter += 1;
                        //TODO:  what do we want to do with the validation messages?  Database?
                        logger.Info("{0}. {1}: {2} {3}", iCounter.ToString(), template.ExportTemplateName, filepath, eve.ErrorDescription);
                    }

                    logger.Info(string.Format("{0} created with validation errors.", filepath));
                }
                else
                {
                    logger.Info(string.Format("{0} created successfully.", filepath));
                }

                // Update the ExportQueueFile record to mark is a complete.
                queuefile.FileMakerName = filepath;
                queuefile.FileMakerDate = DateTime.Now;
                queuefile.Template = template;
                queuefile.Save();

                b = true;
            }
            catch (Exception ex)
            {
                logger.Error("Error Creating XML file.", ex);
            }

            return b;
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
