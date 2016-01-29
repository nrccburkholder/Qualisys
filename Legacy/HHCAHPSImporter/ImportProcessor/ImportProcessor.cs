using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.IO;
using System.Text.RegularExpressions;
using System.Diagnostics;
using HHCAHPSImporter.ImportProcessor.Extractors;

namespace HHCAHPSImporter.ImportProcessor
{
    public class ImportProcessor
    {
        private DAL.QP_DataLoadManager qpDataLoadManager = null;

        private Settings _settings = null;
        private string dataFilesDir;
        private string uploadFilesDir;
        private string abandonedDir;
        private string loadLogsDir;

        private TextWriter _logger = null;

        #region event delegates
        public event HHCAHPSImporter.ImportProcessor.InfoEventHandler Info;
        private void OnInfo(string message)
        {
            if( this._logger != null ) _logger.LogLine(message);
            if (this.Info != null) this.Info(message);
        }

        public event HHCAHPSImporter.ImportProcessor.ErrorEventHandler Error;
        private void OnError(string message, Exception ex)
        {
            if (this._logger != null) _logger.LogError(message, ex);
            if (this.Error != null) this.Error(message, ex);
        }
        #endregion

        public ImportProcessor(Settings settings)
        {
            this._settings = settings;

            this.qpDataLoadManager = DAL.QP_DataLoadManager.Create(_settings.QP_DataLoadConnectionString);
        }

        public int? ImportFile(int uploadFileId)
        {
            DAL.Generated.ClientDetail client = null;
            int? dataFileId = null;

            DAL.Generated.UploadFile uploadFile = qpDataLoadManager.GetUploadFile(uploadFileId);
            if (uploadFile == null)
            {
                throw new Exception(string.Format("Could not find record for uploadFileId {0}", uploadFileId));
            }

            // we are only storing the filename is the database.  Following pattern on old system.... seems like FQN would be better.
            // the uploadFileInfo is a static reference to the original filename.  May not really need this.
            FileInfo uploadFileInfo = new FileInfo(Path.Combine(this._settings.ImportQueueDirectory.FullName,uploadFile.File_Nm));

            // this 'file' will morph into the data file.  it starts as the upload file and is renamed to just the datafileid.extension
            FileInfo file = new FileInfo(Path.Combine(this._settings.ImportQueueDirectory.FullName, uploadFile.File_Nm));

            #region Check to see that the uploaded file can be resolved to a cnn and an NRC client
            string ccn = FileNameParser.GetCCN(file.Name);
            if (string.IsNullOrEmpty(ccn))
            {
                throw new Exceptions.InvalidArgumentException(string.Format("Unrecognized file pattern for file {0}", file.Name));
            }

            client = this.qpDataLoadManager.GetClientDetailFromCCN(ccn);
            if( client == null )
            {
                throw new Exceptions.InvalidArgumentException(string.Format("Could not find client for CCN '{0}'", ccn));
            }
            #endregion

            CreateCSSDirectories(client);

            uploadFileInfo.CopyTo( Path.Combine(this.uploadFilesDir, uploadFileInfo.Name ) );

            using (TextWriter logger = File.CreateText(Path.Combine(this.loadLogsDir, string.Format("{0}.log", file.Name))))
            {
                try
                {
                    _logger = logger;

                    // this will show all the sql that was executed.  good for debuging...
                    // this.qpDataLoadManager.Log = logger;

                    this.OnInfo(string.Format("Importing file {0} with uploadFileId={1}", file.FullName, uploadFileId));
                    string s = string.Format("Client Details:");
                    s += string.Format("Name:{0}", client.ClientName);
                    s += string.Format(", ClientId:{0}", client.Client_id);
                    s += string.Format(", StudyId:{0}", client.Study_id);
                    s += string.Format(", SurveyId:{0}", client.Survey_id);
                    s += string.Format(", Languages:{0}", client.Languages);
                    this.OnInfo(s);

                    string origName = file.FullName;
                    string dataFileName = file.Name;

                    // get the transform process for the client
                    Transforms.ITransform transformProcessor = Transforms.Factory.GetTransformProcessor(client);
                    // get the transform for the client
                    XDocument xtrans = qpDataLoadManager.GetTransforms(client);
                    string transfromName = xtrans.Root.Attribute("transformname").Value;

                    #region Process the upload file into a DataFile.  This encompasses the ETL Process
                    this.OnInfo(string.Format("Creating DataFile record for {0}", file.FullName));
                    dataFileId = qpDataLoadManager.InsertDataFile(client, 
                        transfromName,
                        this.dataFilesDir, 
                        string.Format("_{0}{1}", client.Survey_id, file.Extension), (int)file.Length);
                    this.OnInfo(string.Format("DataFile_Id {0} created for {1}", dataFileId, file.Name));

                    // now go back and rename the datafile to only be {dataFileId}_{surveyId}.extension
                    this.OnInfo(string.Format("Renaming DataFile {3} to {0}_{1}{2}", dataFileId.Value, client.Survey_id, file.Extension, file.Name));
                    file.MoveTo( Path.Combine(this.dataFilesDir, string.Format("{0}_{1}{2}", dataFileId.Value, client.Survey_id, file.Extension) ));
                    qpDataLoadManager.UpdateDataFile( dataFileId.Value, file, null, DateTime.Now, null );

                    this.OnInfo(string.Format("linking uploadfile_id = {0} to datafile_id = {1}", uploadFileId, dataFileId));
                    qpDataLoadManager.InsertUploadFilesToDataFiles(uploadFileId, dataFileId.Value);

                    // NOTE NOTE NOTE THIS DOES NOT SEEM TO FIT HERE....
                    // TODO: This does not seem to fit here.
                    // why is the uploadfile state set to uploaded here, the file has already been uploaded.  It is now being processed.
                    this.OnInfo(string.Format("Updating UploadFile({0}) state to UploadState.Uploaded", uploadFileId));
                    qpDataLoadManager.LD_UpdateUploadFileState(uploadFileId, DAL.UploadState.Uploaded, "Uploaded");
                    // NOTE NOTE NOTE THIS DOES NOT SEEM TO FIT HERE....

                    #region Extract, Transform and Load

                    this.OnInfo(string.Format("LD_UpdateDataFileStateChange({0}) to DataFileState.FileQueued", dataFileId));
                    qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, DAL.DataFileState.FileQueued, "FileQueued");

                    #region *** extract ***
                    this.OnInfo(string.Format("Extracting {0}", uploadFileInfo.Name));
                    Extractors.IExtract extractProcessor = Extractors.Factory.GetExtractor(client, uploadFileInfo.Name, qpDataLoadManager);
                    XDocument extractedData = extractProcessor.Extract(client, file.FullName);

                    var sampleMonth = ExtractHelper.GetSampleMonth(extractedData);
                    var sampleYear = ExtractHelper.GetSampleYear(extractedData);
                    var isUpdateFile = qpDataLoadManager.StudyHasAppliedData(client.Study_id, sampleMonth, sampleYear);
                    if (isUpdateFile)
                    {
                        if(CutoffDateHelper.IsPastCutoff(
                            qpDataLoadManager.GetUpdateFileQ1Cutoff(),
                            qpDataLoadManager.GetUpdateFileQ2Cutoff(),
                            qpDataLoadManager.GetUpdateFileQ3Cutoff(),
                            qpDataLoadManager.GetUpdateFileQ4Cutoff(),
                            sampleMonth,
                            sampleYear,
                            DateTime.Now))
                        {
                            throw new InvalidOperationException("Update file received after cutoff date");
                        }

                        UpdateRecordMerger.Merge(sampleYear, sampleMonth, ccn, extractedData, qpDataLoadManager);
                    }
                    UpdateRecordMerger.UpdateMergeRecords(sampleYear, sampleMonth, ccn, extractedData, qpDataLoadManager);

                    #region Add externally generated values to the metadata
                    extractedData.Root.Add(new XAttribute("uploadfile_id", uploadFileId));
                    extractedData.Root.Add(new XAttribute("datafile_id", dataFileId));
                        
                    XElement xUploadId = new XElement("nv", new XAttribute("n", "UPLOADFILE_ID"));
                    xUploadId.Value = uploadFileId.ToString();
                    XElement xDataFileId = new XElement("nv", new XAttribute("n", "DATAFILE_ID"));
                    xDataFileId.Value = dataFileId.ToString();

                    extractedData.Root.Descendants("metadata").Elements("r").First().Add(xUploadId);
                    extractedData.Root.Descendants("metadata").Elements("r").First().Add(xDataFileId);
                    #endregion

                    // Save the extracted data as an xml document.  this is the data that the transform will be applied to
                    // this include the original data + any meta data, in a standard xml format.
                    if (_settings.SaveXMLFiles)
                    {
                        extractedData.Save(Path.Combine(this.uploadFilesDir, string.Format("{0}.xml", uploadFileInfo.Name)));
                    }
                    #endregion

                    #region *** transform ***
                    this.OnInfo(string.Format("Transforming {0} to {1}", uploadFileInfo.Name, file.Name));

                    XDocument xdoc = transformProcessor.Transform(client, xtrans, extractedData);

                    // save the transformed file to the DataFiles directory
                    string transformedDataFileName = Path.Combine(dataFilesDir, string.Format("{0}.xml", file.Name));
                    this.OnInfo(string.Format("Saving transformed file to {0}", transformedDataFileName));
                    if (_settings.SaveXMLFiles)
                    {
                        xdoc.Save(transformedDataFileName);
                    }
                    #endregion

                    #region *** Load ***
                    this.OnInfo(string.Format("LD_UpdateDataFileStateChange({0}) to DataFileState.FileLoading", dataFileId));
                    qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, DAL.DataFileState.FileLoading, "FileLoading");

                    this.OnInfo(string.Format("Loading datafile({0}) into study owned tables", dataFileId));
                    qpDataLoadManager.LoadStudyOwnedTables(client, xdoc);

                    this.OnInfo(string.Format("LD_UpdateDataFilePostLoad(dataFileId={0})", dataFileId));
                    qpDataLoadManager.LD_UpdateDataFilePostLoad(dataFileId.Value, transfromName);

                    this.OnInfo(string.Format("LD_PostDTS(dataFileId={0})", dataFileId));
                    qpDataLoadManager.LD_PostDTS(dataFileId.Value);

                    // update the endDate
                    this.OnInfo(string.Format("Updating endate for dataFileId {0}", dataFileId));
                    qpDataLoadManager.UpdateDataFile(dataFileId.Value, file, null, null, DateTime.Now);
                    #endregion

                    #endregion

                    #endregion

                    if (isUpdateFile)
                    {
                        this.OnInfo(string.Format("LD_UpdateDataFileStateChange({0}) to DataFileState.AwaitingHHCAHPSUpdate", dataFileId));
                        qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, DAL.DataFileState.AwaitingHHCAHPSUpdate, "AwaitingHHCAHPSUpdate");

                        this.OnInfo(string.Format("calling UpdateOCSEncounterData({0})", dataFileId));
                        qpDataLoadManager.UpdateOCSEncounterData(dataFileId.Value);
                        // EXEC UpdateOCSEncounterData " & dataFileID 

                        this.OnInfo(string.Format("LD_UpdateDataFileStateChange({0}) to DataFileState.HHCAHPSUpdateApplied", dataFileId));
                        qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, DAL.DataFileState.HHCAHPSUpdateApplied, "HHCAHPSUpdateApplied");
                    }
                    else
                    {
                        this.OnInfo(string.Format("LD_UpdateDataFileStateChange({0}) to DataFileState.AwaitingAddressClean", dataFileId));
                        qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, DAL.DataFileState.AwaitingAddressClean, "AwaitingAddressClean");

                        this.OnInfo(string.Format("Calling AddressCleaning for dataFileId({0})", dataFileId));
                        AddressCleaning(dataFileId.Value);
                    }

                    this.OnInfo(string.Format("Completed file import for {0}, dataFileId={1}", file.FullName, dataFileId.Value));

                    return dataFileId;
                }
                catch (Exception e)
                {
                    this.OnError(e.Message, e);
                    AbandonFile(uploadFileId, dataFileId, file, e);
                }
                finally
                {
                    this.qpDataLoadManager.Log = null;
                    this._logger = null;
                }
            }

            // something went wrong.
            return null;
        }

        public void AddressCleaning(int dataFileId)
        {
            //this.OnInfo("******** ADDRESS CLEANING SKIPPED **********");
            //return;

            // string command = @"C:\Program Files (x86)\QualiSys\Address Cleaner\AddressCleaner.exe";
            
            string commandParameters = string.Format("{0} QP_DATALOAD", dataFileId);
            this.OnInfo(string.Format("{0} {1}", _settings.AddressCleanerPath, commandParameters));
            System.Diagnostics.Process p = Process.Start(_settings.AddressCleanerPath, commandParameters);
            p.WaitForExit();

        }

        #region Private Functions
        void CreateCSSDirectories(DAL.Generated.ClientDetail clientDetails)
        {
            string cssDirectory = Path.Combine(this._settings.ClientsDirectory.FullName,
                                                string.Format(@"{0}\{1}", clientDetails.Client_id, clientDetails.Study_id));

            uploadFilesDir = Path.Combine(cssDirectory, "UploadFiles");
            dataFilesDir = Path.Combine(cssDirectory, "DataFiles");
            abandonedDir = Path.Combine(cssDirectory, "Abandoned");
            loadLogsDir = Path.Combine(cssDirectory, "LoadLogs");

            Directory.CreateDirectory(cssDirectory);

            Directory.CreateDirectory(uploadFilesDir);
            Directory.CreateDirectory(dataFilesDir);
            Directory.CreateDirectory(abandonedDir);
            Directory.CreateDirectory(loadLogsDir);
        }

        void AbandonFile(int uploadFileId, int? dataFileId, FileInfo file)
        {
            AbandonFile(uploadFileId, dataFileId, file, null);
        }

        void AbandonFile(int uploadFileId, int? dataFileId, FileInfo file, Exception ex)
        {
            try
            {
                #region Abandon the upload file when the import failes?
                //// TODO: This does not really make sense.  
                //// The upload was successful, the import is being abandoned.  Why abaondon the upload when an import failes????
                //this.OnInfo(string.Format("Abandoning UploadFile({0})", uploadFileId));
                //if (ex != null)
                //{
                //    qpDataLoadManager.LD_UpdateUploadFileState(uploadFileId, DAL.UploadState.UploadedAbandoned, string.Format("UploadedAbandoned - {0}", ex.Message));
                //}
                //else
                //{
                //    qpDataLoadManager.LD_UpdateUploadFileState(uploadFileId, DAL.UploadState.UploadedAbandoned, "UploadedAbandoned");
                //}
                #endregion

                if (dataFileId.HasValue)
                {
                    this.OnInfo(string.Format("Abandoning DataFile({0})", dataFileId.Value));
                    if (ex != null)
                    {
                        qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, HHCAHPSImporter.ImportProcessor.DAL.DataFileState.Abandoned, string.Format("Abandoned - {0}", ex.Message));
                    }
                    else
                    {
                        qpDataLoadManager.LD_UpdateDataFileStateChange(dataFileId.Value, HHCAHPSImporter.ImportProcessor.DAL.DataFileState.Abandoned, "Abandoned");
                    }
                }
            }
            catch (Exception exDbUpdate)
            {
                OnError("Could not update datafile status to abandoned",exDbUpdate);
            }

            string dir = Path.Combine(abandonedDir, DateTime.Now.ToString("yyyyMMdd"));
            try
            {
                Directory.CreateDirectory(dir);

                this.OnInfo(string.Format("Abandoning {0} - moving to {1}", file.Name, dir));
                file.MoveTo(Path.Combine(dir, file.Name));

                if (File.Exists(Path.Combine(dir, file.Name + ".xml")))
                {
                    file.MoveTo(Path.Combine(dir, file.Name + ".xml"));
                }

                try
                {
                    using (StreamWriter sw = File.CreateText(file.FullName + ".error"))
                    {
                        LogAbandonReason(sw, ex);
                    }
                }
                catch (Exception exErrorLog)
                {
                    OnError(string.Format("Could not log abandoned reason"), exErrorLog);
                }
            }
            catch (Exception moveEx)
            {
                OnError(string.Format("Could not move {0} to {1}", file.Name, dir), moveEx);
            }

        }

        void LogAbandonReason(StreamWriter sw, Exception ex)
        {
            if (ex != null)
            {
                sw.WriteLine(ex.Message);
                sw.WriteLine(ex.StackTrace);
                if (ex.InnerException != null)
                {
                    LogAbandonReason(sw, ex.InnerException);
                }
            }
        }
        #endregion
    }
}
