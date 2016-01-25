using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

using NRC.Common;
using NRC.Common.Service;
using NRC.Common.Configuration;

using ImportProcessor = HHCAHPSImporter.ImportProcessor;
using Exceptions = HHCAHPSImporter.ImportProcessor.Exceptions;


namespace HHCAHPSImporter.ImportProcessingService
{
    class Program : TimerService
    {
        Settings settings = ConfigManager.Load<Settings>(new ConfigOptions { CreateMissingDirectories = true });
        private static Logger _logger = Logger.GetLogger("HHCAHPSImporter.ImportProcessor");
        private static readonly HashSet<string> extensionsToProcess = new HashSet<string> { ".csv", ".txt" };

        #region TimerService Overrides
        protected override int IntervalSecs
        {
            get { return this.settings.IntervalSecs; }
        }

        protected override void RunOnce()
        {
            try
            {
                HHCAHPSImportProcessor_Info("HHCAHPS Import Service checking for work");

                //// List<FileInfo> files = settings.IncomingDirectory.GetFiles().ToList();
                //// Move all of the files off of the FTP server

                QueueZipFiles();
                QueueFiles();

                List<FileInfo> files = settings.UploadQueueDirectory.GetFiles().ToList();

                if (files.Count > 0)
                {
                    HHCAHPSImportProcessor_Info(string.Format("Found {0} files in the ImportQueue directory", files.Count));
                    UploadAndImportFiles(files);
                    HHCAHPSImportProcessor_Info("HHCAHPS Import Service work completed");
                }
                else
                {
                    // HHCAHPSImportProcessor_Info("Nothing to do");
                }
            }
            catch (Exception ex)
            {
                HHCAHPSImportProcessor_Error(ex.Message, ex);
            }
            finally
            {
                // HHCAHPSImportProcessor_Info("HHCAHPS Import Service work completed");
            }
        }

        public override string InternalName
        {
            get { return "HHCAHPS Import Service"; }
        }
        #endregion

        #region private helper functions

        /// <summary>
        /// Moves all the files in the IncomingDirecotry to the UploadQueue directory.  Each file is tag with the current yyyyMMddhhmmss.
        /// </summary>
        void QueueFiles()
        {
            List<FileInfo> files = settings.IncomingDirectory.GetFiles().Where(file => extensionsToProcess.Contains(file.Extension.ToLower())).ToList();

            if (files.Count() > 0)
            {
                HHCAHPSImportProcessor_Info(string.Format("Found {0} files in {1}.  These will be queued for importing", files.Count, settings.IncomingDirectory.FullName));

                foreach (FileInfo fi in files)
                {
                    try
                    {
                        QueueFile(fi);
                    }
                    catch (Exception ex)
                    {
                        HHCAHPSImportProcessor_Error(string.Format("Could not queue file {0}", fi.Name), ex);
                    }
                }
            }
        }

        void QueueFile(FileInfo file)
        {
            string target = Path.Combine(settings.UploadQueueDirectory.FullName, file.Name);

            if (!File.Exists(target))
            {
                HHCAHPSImportProcessor_Info(string.Format("Moving {0} to {1}", file.Name, settings.UploadQueueDirectory.FullName));
                file.MoveTo(target);
            }
            else
            {
                HHCAHPSImportProcessor_Info( string.Format("A File named {0} is already queued.  Not queuing {1}", target, file.FullName ) );
            }
        }

        void QueueZipFiles()
        {
            List<FileInfo> files = settings.IncomingDirectory.GetFiles("*.zip").ToList();

            if (files.Count() > 0)
            {
                HHCAHPSImportProcessor_Info(string.Format("Found {0} zip in {1}.  These will be queued for importing", files.Count, settings.IncomingDirectory.FullName));

                foreach (FileInfo fi in files)
                {
                    try
                    {
                        // move the zipfile to the UploadQueue directory
                        QueueZipFile(fi);

                        try
                        {
                            using (var z = new Ionic.Zip.ZipFile(fi.FullName))
                            {
                                ZipExtractor.SetFlattenedUniqueFileNames(z);

                                var zfiles = z.Where(t => extensionsToProcess.Contains(Path.GetExtension(t.FileName).ToLower())).ToList();
                                foreach (var zfile in zfiles)
                                {
                                    QueueZipFileEntry(fi, zfile);
                                }
                            }
                        }
                        catch(Exception ex)
                        {
                            throw new Exception("Could not extract zip file contents", ex);
                        }

                        ArchiveZipFile(fi);
                    }
                    catch (Exception ex)
                    {
                        HHCAHPSImportProcessor_Error(string.Format("Could not queue zipfile {0}", fi.Name), ex);
                        FailZipFile(fi);
                    }
                }
            }
        }

        void QueueZipFile(FileInfo file)
        {
            string target = Path.Combine(settings.ZipQueueDirectory.FullName, file.Name);

            if (!File.Exists(target))
            {
                HHCAHPSImportProcessor_Info(string.Format("Moving {0} to {1}", file.Name, settings.ZipQueueDirectory.FullName));
                file.MoveTo(target);
            }
            else
            {
                HHCAHPSImportProcessor_Info(string.Format("A File named {0} is already queued.  Not queuing {1}", target, file.FullName));
            }
        }

        void ArchiveZipFile(FileInfo file)
        {
            string archiveDir = Path.Combine(settings.ZipArchiveDirectory.FullName, DateTime.Now.ToString("yyyyMMdd"));
            string target = Path.Combine(archiveDir, file.Name);

            Directory.CreateDirectory(archiveDir);

            if (!File.Exists(target))
            {
                HHCAHPSImportProcessor_Info(string.Format("Moving {0} to {1}", file.Name, settings.ZipArchiveDirectory.FullName));
                file.MoveTo(target);
            }
            else
            {
                HHCAHPSImportProcessor_Info(string.Format("A File named {0} is already queued.  Not moving {1}", target, file.FullName));
            }
        }

        void FailZipFile(FileInfo file)
        {
            string target = Path.Combine(
                Path.Combine(settings.ZipFailureDirectory.FullName, DateTime.Now.ToString("yyyyMMdd"))
                , file.Name);

            if (!File.Exists(target))
            {
                HHCAHPSImportProcessor_Info(string.Format("Moving {0} to {1}", file.Name, settings.ZipFailureDirectory.FullName));
                file.MoveTo(target);
            }
            else
            {
                HHCAHPSImportProcessor_Info(string.Format("A File named {0} is already queued.  Not moving {1}", target, file.FullName));
            }
        }

        void QueueZipFileEntry(FileInfo zipFile, Ionic.Zip.ZipEntry zipEntry)
        {
            // string target = Path.Combine(settings.UploadQueueDirectory.FullName, zipFile.Directory.Name);
            string target = settings.UploadQueueDirectory.FullName;

            HHCAHPSImportProcessor_Info(string.Format("Extracting {0} from {1} to {2}", zipEntry.FileName, zipFile.Name, target));
            zipEntry.Extract(target, Ionic.Zip.ExtractExistingFileAction.Throw);

        }

        void UploadAndImportFiles(List<FileInfo> files)
        {
            ImportProcessor.UploadManager uploadManager = new ImportProcessor.UploadManager(settings);

            uploadManager.Info += new ImportProcessor.InfoEventHandler(HHCAHPSImportProcessor_Info);
            uploadManager.Error += new ImportProcessor.ErrorEventHandler(HHCAHPSImportProcessor_Error);

            ImportProcessor.ImportProcessor HHCAHPSImportProcessor = new ImportProcessor.ImportProcessor(settings);

            HHCAHPSImportProcessor.Info += new ImportProcessor.InfoEventHandler(HHCAHPSImportProcessor_Info);
            HHCAHPSImportProcessor.Error += new ImportProcessor.ErrorEventHandler(HHCAHPSImportProcessor_Error);

            foreach (FileInfo fi in files)
            {
                ImportProcessor.UploadInfo uploadInfo = null;

                //// make a backup of the file before we do anything
                //BackupFile(fi);

                #region Upload the file
                try
                {
                    HHCAHPSImportProcessor_Info(string.Format("Uploading {0}", fi.FullName));
                    uploadInfo = uploadManager.UploadFile(fi);
                }
                catch (Exceptions.UploadAbandonedException ex)
                {
                    HHCAHPSImportProcessor_Error(string.Format("Upload Abandoned for {0}", fi.FullName), ex);
                    continue;
                }
                catch (Exception ex)
                {
                    HHCAHPSImportProcessor_Error(string.Format("Upload Failed for {0}", fi.FullName), ex);
                    MoveFileToUploadFailureDirectory(fi, ex);
                    continue;
                }
                #endregion

                #region Import the uploaded file
                try
                {
                    // import the file
                    HHCAHPSImportProcessor_Info(string.Format("Importing uploadFileId {0}", fi.Name));

                    int? datafileId = HHCAHPSImportProcessor.ImportFile(uploadInfo.UploadFileId.Value);

                }
                catch (Exception ex)
                {
                    HHCAHPSImportProcessor_Error(string.Format("ImportFile failed for uploadFileId {0}", uploadInfo.UploadFileId), ex);
                }
                #endregion

            }
        }

        //FileInfo BackupFile(FileInfo file)
        //{
        //    string backupdir = Path.Combine(settings.BackupsDirectory.FullName, DateTime.Now.ToString("yyyyMMdd"));

        //    Directory.CreateDirectory(backupdir);

        //    return file.CopyTo(Path.Combine(backupdir, file.Name));
        //}

        void MoveFileToUploadFailureDirectory(FileInfo file, Exception ex)
        {
            string dir = Path.Combine(settings.UploadFailureDirectory.FullName, DateTime.Now.ToString("yyyyMMdd"));

            Directory.CreateDirectory(dir);

            string destFilename = Path.Combine(dir, file.Name);

            if (!File.Exists(destFilename))
            {
                file.MoveTo(destFilename);

                using (var sw = File.CreateText(file.FullName + ".error"))
                {
                    WriteUploadError(sw, ex);
                }
            }
            else
            {
                HHCAHPSImportProcessor_Error(string.Format("file {0} already exists in upload failure directory", destFilename), null);
            }

        }

        void WriteUploadError(StreamWriter sw, Exception ex)
        {
            sw.WriteLine(ex.Message);
            if (ex.InnerException != null)
            {
                WriteUploadError(sw, ex.InnerException);
            }
        }
        #endregion

        #region Event Handlers
        void HHCAHPSImportProcessor_Info(string message)
        {
            _logger.Info(message);

            if (System.Environment.UserInteractive)
            {
                Console.WriteLine(message);
            }
        }

        void HHCAHPSImportProcessor_Error(string message, Exception e)
        {
            if (e != null) _logger.Error(message, e);
            else _logger.Error(message);

            if (System.Environment.UserInteractive)
            {
                Console.WriteLine(message);
                if (e != null)
                {
                    if (!string.IsNullOrEmpty(e.Message) && !e.Message.Equals(message))
                    {
                        Console.WriteLine(e.Message);
                    }
                    Console.WriteLine(e.StackTrace);
                    if (e.InnerException != null)
                    {
                        HHCAHPSImportProcessor_Error(message, e.InnerException);
                    }
                }
            }
        }
        #endregion

        /// If you are writing a service, call ServiceMain() from the main method of the service. 
        /// For ease of development, you may want it to look like:
        static void Main(string[] args)
        {
#if DEBUG
            if (args.Length == 0)
            {
                args = new string[] { "/once" };
            }
#endif
            FancyServiceRunner.ServiceMain(new Program(), args);
        }

    }
}
