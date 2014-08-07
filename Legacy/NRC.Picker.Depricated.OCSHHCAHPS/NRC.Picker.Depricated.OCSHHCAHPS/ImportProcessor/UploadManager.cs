using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.IO;
using System.Text.RegularExpressions;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor
{
    public class UploadManager
    {
        private DAL.QP_DataLoadManager qpDataLoadManager = null;

        private Settings _settings;

        public UploadManager(Settings settings)
        {
            this._settings = settings;
            this.qpDataLoadManager = DAL.QP_DataLoadManager.Create(this._settings.QP_DataLoadConnectionString);
        }

        public event NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.InfoEventHandler Info;
        private void OnInfo(string message)
        {
            if (this.Info != null)
            {
                this.Info(message);
            }
        }

        public event NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.ErrorEventHandler Error;
        private void OnError(string message, Exception ex)
        {
            if (this.Error != null)
            {
                this.Error(message, ex);
            }
        }

        public UploadInfo UploadFile(FileInfo file)
        {
            UploadInfo uploadInfo = new UploadInfo();

            OnInfo(string.Format("Inserting new UploadFile record with {0}", file.FullName));
            uploadInfo.UploadFileId = qpDataLoadManager.InsertUploadFile(file);
            OnInfo(string.Format("uploadFile_id {0} generated for {1}", uploadInfo.UploadFileId.Value, file.FullName));

            try
            {
                OnInfo(string.Format("Moving {0} to {1}", file.Name, _settings.ImportQueueDirectory.FullName));
                MoveToImportQueueDir(uploadInfo.UploadFileId.Value, file);

                // update filename in the uploadFile table to include the uploadId as part of the filename
                OnInfo(string.Format("updating filename in UploadFile table"));
                qpDataLoadManager.UpdateUploadFile(uploadInfo.UploadFileId.Value, file);

                #region Check to see that the uploaded file can be resolved to a cnn and an NRC client
                uploadInfo.CCN = this.qpDataLoadManager.CCNFromFilename(file.Name);
                if (string.IsNullOrEmpty(uploadInfo.CCN))
                {
                    throw new Exceptions.InvalidArgumentException(string.Format("The file {0} has an unrecognized file pattern", file.Name));
                }

                uploadInfo.Client = this.qpDataLoadManager.GetClientDetailFromCCN(uploadInfo.CCN);
                if (uploadInfo.Client == null)
                {
                    throw new Exceptions.InvalidArgumentException(string.Format("Could not find client for CCN {0}", uploadInfo.CCN));
                }

                if (uploadInfo.Client.Languages == null || string.IsNullOrEmpty(uploadInfo.Client.Languages.Trim()))
                {
                    throw new Exceptions.InvalidArgumentException(string.Format("Client {0} does not have any contracted languages", uploadInfo.Client.Client_id));
                }
                #endregion

                // Not needed? 
                // OnInfo(string.Format("Updating UploadFile({0}) state to UploadState.UploadQueued", uploadFileId.Value));
                // qpDataLoadManager.LD_UpdateUploadFileState(uploadFileId.Value, DAL.UploadState.UploadQueued, "UploadQueued"); // Queued(1)

                OnInfo(string.Format("Updating UploadFile({0}) state to UploadState.UploadAwaitingPreProcessing", uploadInfo.UploadFileId.Value));
                qpDataLoadManager.LD_UpdateUploadFileState(uploadInfo.UploadFileId.Value, DAL.UploadState.UploadAwaitingPreProcessing, "UploadAwaitingPreProcessing"); // AwaitingPreProcessing(2)

                return uploadInfo;
            }
            catch (Exception e)
            {
                if (uploadInfo.UploadFileId.HasValue)
                {
                    AbandoneUpload(uploadInfo, file, e.Message);
                    throw new Exceptions.UploadAbandonedException(e.Message);
                }

                throw;
            }
        }

        private void AbandoneUpload(UploadInfo uploadInfo, FileInfo file, string message)
        {
            try
            {
                MoveToAbandonedDir(file);
            }
            catch (Exception ex)
            {
                OnError(string.Format("Error moving file {0} to the Abandoned Directory", file.Name), ex);
            }

            try
            {
                OnInfo(string.Format("Updating UploadFile({0}) state to UploadState.UploadedAbandoned", uploadInfo.UploadFileId.Value));
                qpDataLoadManager.LD_UpdateUploadFileState(uploadInfo.UploadFileId.Value, DAL.UploadState.UploadedAbandoned, string.Format("UploadedAbandoned - {0}", message)); // Abandoned
            }
            catch (Exception ex)
            {
                OnError(ex.Message, ex);
            }
        }

        private void MoveToAbandonedDir(FileInfo file)
        {
            string dir = Path.Combine(this._settings.AbandonedUploadsDirectory.FullName, DateTime.Now.ToString("yyyyMMdd"));
            Directory.CreateDirectory(dir);

            file.MoveTo(Path.Combine(dir, file.Name));
        }

        private void MoveToImportQueueDir(int uploadFileId, FileInfo file)
        {
            string filename = string.Format("{0}_{1}", uploadFileId, file.Name);
            file.MoveTo(Path.Combine(this._settings.ImportQueueDirectory.FullName, filename));
        }

    }
}
