﻿using System;
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
using NLog;



namespace NRC.Exporting
{
    public static class Exporter
    {

        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Creates and saves Export files
        /// </summary>
        public static void  MakeFiles()
        {
            int iCnt = 0; // file counter

            string targetFileLocation = SystemParams.Params.GetParam("FileLocation").StringValue;

            List<ExportQueueFile> queuefiles = ExportQueueFile.Select(new ExportQueueFile(), true);

            foreach (ExportQueueFile queuefile in queuefiles)
            {
                List<ExportQueue> queues = ExportQueue.Select(new ExportQueue { ExportQueueID = queuefile.ExportQueueID });

                foreach (ExportQueue queue in queues)
                {
                    ExportTemplate template = ExportTemplate.Select(new ExportTemplate { ExportTemplateVersionMajor = queue.ExportTemplateVersionMajor, ExportTemplateVersionMinor = queue.ExportTemplateVersionMinor }).First();

                    List<ExportSection> sections = ExportSection.Select(new ExportSection { ExportTemplateID = template.ExportTemplateID });

                    List<ExportDataSet> ds = ExportDataSet.Select(sections,queue.ExportQueueID);

                    if (ds.Count > 0)
                    {
                        // Depending on the file type, we call the appropriate File Maker Methods
                        switch (queuefile.FileMakerType)
                        {
                            case (int)Enums.ExportFileTypes.Xml:
                                
                                if (MakeFile_XML(ds, targetFileLocation, template, queuefile))
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
        private static bool MakeFile_XML(List<ExportDataSet> ds, string fileLocation, ExportTemplate template, ExportQueueFile queuefile)
        {
            bool b = false;
            string filepath = string.Empty;
            try
            {
                string filename = template.DefaultNamingConvention;
                SetFileName(ref filename, ds.Where(x => x.Section.ExportTemplateSectionName == "header").First());

                XmlDocumentEx xmlDoc = new XmlDocumentEx();
                xmlDoc = XMLExporter.MakeExportXMLDocument(ds, template);

                filepath = xmlDoc.IsValid == true ? fileLocation : Path.Combine(fileLocation, "error");

                if (!Directory.Exists(filepath))
                {
                    Directory.CreateDirectory(filepath);
                }

                filepath = Path.Combine(filepath, Path.ChangeExtension(filename,"xml"));

                xmlDoc.Save(filepath);

                if (!xmlDoc.IsValid)
                {
                    foreach (ExportValidationError eve in xmlDoc.ValidationErrorList)
                    {
                        //Logging to the database.  The elements of the message are pipe delimited, with the template name, queueid, queuefileid, the file name, and the validation error description
                        string message = string.Format("{0}|{1}|{2}|{3}|{4}", template.ExportTemplateName, queuefile.ExportQueueID.ToString(), queuefile.ExportQueueFileID.ToString(), Path.GetFileName(filepath), eve.ErrorDescription);
                        LogEventInfo logEvent = new LogEventInfo(LogLevel.Warn, "", message);
                        logEvent.Properties["event-type"] = "Xml validation error";
                        logEvent.Properties["event-source"] = "CEM.FileMaker_Service";
                        logEvent.Properties["event-class"] = "Exporter";
                        logEvent.Properties["event-method"] = "MakeXMLFile";
                        logger.Log(logEvent);
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

        private static void SetFileName(ref string defaultname, ExportDataSet ds)
        {
            int iBracketStart = 0;
            int iBracketEnd = 0;

            if (ds.DataTable.Rows.Count > 0)
            {
                DataRow dr = ds.DataTable.Rows[0];
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
