using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Nrc.Framework.BusinessLogic.Configuration;
using Nrc.Framework.Notification;
using ServiceLogging;
using System.Xml;
using System.Net;
using System.IO;
using System.Diagnostics;
using Ionic.Zip;
using USPS_ACS_Library.Enums;
using USPS_ACS_Library.Objects;
using System.Data;


namespace USPS_ACS_Library
{
    public static class ServiceWorker
    {
        /*
            ACCOUNT NUMBER  : 103450

            ACCOUNT NAME: NATIONAL RESEARCH CORP

            username: kanstine@nationalresearch.com
            PASSWORD: NatlRes1245
         */

        private static List<USPS_ACS_Error> errorList = new List<USPS_ACS_Error>();
        private static string[] versionList;
        private static List<USPS_ACS_Notification> downloadList = new List<USPS_ACS_Notification>();
        private static List<USPS_ACS_Notification> extractList = new List<USPS_ACS_Notification>();

        #region constants


        #endregion

        public static void DoDownloadWork()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();
            errorList.Clear();
            downloadList.Clear();

            try
            {
                // We have the option to turn off the downloads from the USPS ACS service
                bool doDownload = AppConfig.Params["USPS_ACS_DoDownload"].IntegerValue == 1;

                if (doDownload)
                {
                    DownloadZips();
                }
                else Logs.Info("USPS ACS Download job is turned off.");
              
                if (errorList.Count > 0)
                {
                    throw new USPS_ACS_Exception(String.Format("{0} error(s) occurred during processing.", errorList.Count.ToString()), errorList);
                }
            }
            catch (Exception ex)
            {
                Logs.Info("USPS Exception Encountered While Attempting to Process Files! " + ex.Message);
                SendErrorNotification("USPS_ACS_Service", "Exception Encountered While Attempting to Process Files!", ex);
            }
            finally
            {
                stopwatch.Stop();
                Logs.Info(String.Format("USPS ACS Processing Elapsed Time: {0} seconds.", (stopwatch.ElapsedMilliseconds / 1000).ToString() ));
                SendStatusNotification("USPS_ACS_Service.DownloadFile", downloadList, NotificationType.Download);
            }
        }

        public static void DoExtractWork()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();
            errorList.Clear();
            extractList.Clear();

            try
            {                
                ExtractFiles();
                ProcessFiles();
                SendPartialMatchReport("USPS_ACS_Service");

                if (errorList.Count > 0)
                {
                    throw new USPS_ACS_Exception(String.Format("{0} error(s) occurred during processing.", errorList.Count.ToString()), errorList);
                }
            }
            catch (Exception ex)
            {
                Logs.Info("USPS Exception Encountered While Attempting to Process Files! " + ex.Message);
                SendErrorNotification("USPS_ACS_Service", "Exception Encountered While Attempting to Process Files!", ex);
            }
            finally
            {
                stopwatch.Stop();
                Logs.Info(String.Format("USPS ACS Processing Elapsed Time: {0} seconds.", (stopwatch.ElapsedMilliseconds / 1000).ToString()));
                SendStatusNotification("USPS_ACS_Service.ExtractFile", extractList, NotificationType.Extract);
            }

        }

        #region Download Zip files

        private static void DownloadZips()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();
            try
            {
                string username = AppConfig.Params["USPS_ACS_Webservice_username"].StringValue;
                string pword = AppConfig.Params["USPS_ACS_Webservice_password"].StringValue;

                gov.usps.epf.filedownload fdl = new gov.usps.epf.filedownload();

                string authToken = fdl.login(username, pword);
                string EpfVersion = fdl.getEpfVersion();

                string fileList = fdl.getList(authToken, "NEW");

                XmlDocument xdoc = new XmlDocument();
                xdoc.LoadXml(fileList);

                if (xdoc.GetElementsByTagName("product").Count > 0)
                {
                    Logs.Info(String.Format("{0} files to process.",xdoc.GetElementsByTagName("product").Count.ToString()));

                    int fileCount = 0;
                   
                    foreach (XmlNode productNode in xdoc.GetElementsByTagName("product"))
                    {
                        fileCount += 1;

                        // here we get the file name and download it 
                        XmlNodeList productNodeList = productNode.ChildNodes;

                        string key = productNode.SelectSingleNode("key").InnerText;
                        string fileId = productNode.SelectSingleNode("fileid").InnerText;
                        string fileName = productNode.SelectSingleNode("filename").InnerText;
                        string status = productNode.SelectSingleNode("status").InnerText;
                        string size = productNode.SelectSingleNode("size").InnerText;
                        string code = productNode.SelectSingleNode("code").InnerText;
                        string name = productNode.SelectSingleNode("name").InnerText;
                        string fulfilled = productNode.SelectSingleNode("fulfilled").InnerText;
                        string modified = productNode.SelectSingleNode("modified").InnerText;

                        string fileURL = fdl.getFile(authToken, key, fileId);

                        // write to the USPS_ACS_DowloadLog
                        int downloadLog_id = USPS_ACS_DataProvider.InsertDownloadLog(key, fileId, fileName, size, code, name, fulfilled, modified, fileURL, Enum.GetName(typeof(DownloadStatus), DownloadStatus.New));

                        string downloadStatus;
                        string fstatus;
                        if (DownloadFile(fileURL, fileName))
                        {
                            // Set the status of the file. By default when a file URL is retrieved from the webservice by calling getFile(),
                            // the status is set to ‘S’. Acceptable values are N=New, S=Started, C=Completed, or X=Canceled. Any other
                            // values passed are defaulted to C. 
                            downloadStatus = "C"; // completed
                            fstatus = "Completed";
                        }
                        else
                        {
                            downloadStatus = "N";  // mark as canceled
                            fstatus = "New";
                        }

                        fdl.setStatus(authToken, key, downloadStatus, fileId);
                        Logs.Info(String.Format("DownloadFile: {0} -- status {1}", fileName , downloadStatus));
                        USPS_ACS_DataProvider.UpdateDownloadLogStatus(fileName,fstatus);
                        downloadList.Add(new USPS_ACS_Notification{ ZipFileFile = fileName, FileType=NotificationType.Download});
                    }

                    stopwatch.Stop();
                    Logs.Info(String.Format("Download files processed: {0}",fileCount.ToString()));
                    
                }
                else Logs.Info("No files to process.");

                fdl.Dispose();
            }
            catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Download, ex.Message));
                Logs.LogException("DownloadZips Error", ex);
            }
            finally
            {
                stopwatch.Stop();
                Logs.Info(String.Format("DownloadZips Elapsed Time: {0} seconds", (stopwatch.ElapsedMilliseconds / 1000).ToString()));
            }
        }

        private static bool DownloadFile(string fileUrl, string fileName)
        {
            string path = AppConfig.Params["USPS_ACS_ResultFiles_Path"].StringValue;

            string destPath = Path.Combine(@path, fileName);
            try
            {
                using (WebClient Client = new WebClient())
                {
                    Client.DownloadFile(fileUrl, destPath);
                    return true;
                }
            }
            catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Download,fileName, string.Empty, ex.Message));
                Logs.LogException("DownloadFile Error", ex);
                return false;
            }
        }

        #endregion

        #region Extract Files from Zip
        private static void ExtractFiles()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            string path = AppConfig.Params["USPS_ACS_ResultFiles_Path"].StringValue;
            versionList = AppConfig.Params["USPS_ACS_VersionList"].StringValue.Split(',');

            if (Directory.Exists(path))
            {
                string[] extensions = new string[2] { ".zip",".ZIP" };
                FileSearch searcher = new FileSearch(false);
                searcher.SearchExtensions.AddRange(extensions);
                FileInfo[] files = searcher.Search(path);
                foreach (FileInfo file in files)
                {
                    ExtractFromZip(file.FullName); //extract each file in the zip
                }
            }

            stopwatch.Stop();
            Logs.Info(String.Format("Extract Files Elapsed Time: {0} seconds.", (stopwatch.ElapsedMilliseconds / 1000).ToString()));

        }

        private static void ExtractFromZip(string zipFile)
        {

            string extractToPath = AppConfig.Params["USPS_ACS_FileExtractionPath"].StringValue;

            try
            {
                int extractCount = 0;
                int extractErrorCount = 0;
                using (Ionic.Zip.ZipFile zip1 = ZipFile.Read(zipFile))
                {
                    // Here, we extract conditionally based on entry name.  
                    // We are not extracting the files whose filenames end with 'SN' and 'SD' because those are just billing statements.
                    foreach (ZipEntry e in zip1.Where(x => (!Path.GetFileNameWithoutExtension(x.FileName).EndsWith("SN") && !Path.GetFileNameWithoutExtension(x.FileName).EndsWith("SD")))) 
                    {
                        string Password = AppConfig.Params["USPS_ACS_FileExtractionPassword"].StringValue; 
                        e.ExtractWithPassword(extractToPath, ExtractExistingFileAction.OverwriteSilently, Password);
        
                        string path = Path.Combine(extractToPath, e.FileName);
                        // We retrive information from the file's header.
                        ExtractLog exLog = ReadFileHeader(path, Path.GetFileName(zipFile));

                        // Add the record to the USPS_ACS_ExtractFileLog table
                        extractErrorCount += InsertExtractFileLog(exLog);

                        extractCount += 1;

                        extractList.Add(new USPS_ACS_Notification { ZipFileFile = exLog.ZipFileName,  ExtractFileName = e.FileName, FileType = NotificationType.Extract, RecordCount = Convert.ToInt32(exLog.RecordCount), Status = exLog.Status });

                        // if the file extracted is anything other than New, go ahead and move it, otherwise it will just sit around in the Extracted folder
                        if (exLog.Status != "New")
                        {
                            ExtractFileStatus thisStatus = (ExtractFileStatus)Enum.Parse(typeof(ExtractFileStatus), exLog.Status);
                            MoveExtractFile(exLog.FilePath, thisStatus);
                        }
                    }
                }

                DownloadStatus status;

                if (extractErrorCount > 0)
                {
                    errorList.Add(new USPS_ACS_Error(ErrorType.Extract, Path.GetFileName(zipFile), string.Empty, "Extracted with Log Errors"));
                    status = DownloadStatus.Completed_w_Errors;
                }
                else status = DownloadStatus.Completed;

                USPS_ACS_DataProvider.UpdateDownloadLogStatus(Path.GetFileName(zipFile), status.ToString());

                Logs.Info(String.Format("{0} File(s) extracted from {1}",extractCount.ToString(),Path.GetFileName(zipFile)));

                MoveZipFile(zipFile, status);

            }
            catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, Path.GetFileName(zipFile), string.Empty, ex.Message));
                Logs.LogException("ProcessZip Error", ex);
            }
        }

        private static ExtractLog ReadFileHeader(string path, string zipfilename)
        {
            string FileName = Path.GetFileName(path);
            ExtractLog exlog = new ExtractLog();
            try
            {
                // Open the stream and read it back. 
                using (StreamReader sr = File.OpenText(path))
                {
                    string s = string.Empty;
                    
                    if (!sr.EndOfStream)
                    {
                        s = sr.ReadLine(); // read the first line
                        string recordType = s.Substring(0, 1);
                        if (recordType == "H") // check to see if the record is a header record
                        {
                            
                            string version = s.Substring(1, 2);
                            if (!versionList.Contains(version))  // if the version is not in the version list then it's the old version, which we are indicating by "00"
                            {
                                version = "00";
                            }

                            Schema schema = GetSchema(recordType, version);

                            string CustomerID = GetFieldValue(schema, s, "CustomerID");
                            string RecordCount = GetFieldValue(schema, s, "TotalACSRecordCount");
                            string CreatedDate = GetFieldValue(schema, s, "CreateDate"); 

                            exlog.FileName =FileName;
                            exlog.FilePath = path;
                            exlog.Version = version;
                            exlog.DetailRecordIndicator = schema.DetailRecordIndicator; 
                            exlog.CustomerID = CustomerID;
                            exlog.RecordCount = RecordCount;
                            exlog.CreatedDate = CreatedDate;
                            exlog.HeaderText = s;
                            exlog.ZipFileName = zipfilename;
                            exlog.Status = Enum.GetName(typeof(ExtractFileStatus),ExtractFileStatus.New);
                            return exlog;

                        }
                        else 
                        { 
                            // first line is not a header
                            exlog.FileName = FileName;
                            exlog.FilePath = path;
                            exlog.ZipFileName = zipfilename;
                            exlog.Status = Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.No_Header_Record);
                            return exlog; 
                        }
                    }
                    else 
                    {
                        exlog.FileName = FileName;
                        exlog.FilePath = path;
                        exlog.ZipFileName = zipfilename;
                        exlog.Status = Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.Empty_File);
                        return exlog; 
                    }                
                }
            }
            catch (Exception ex)
            {

                exlog.FileName = FileName;
                exlog.FilePath = path;
                exlog.ZipFileName = zipfilename;
                exlog.Status = Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.Processing_Error);
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, zipfilename, FileName, ex.Message));
                return exlog; 
            }
            finally
            {

            }
        }


        private static int InsertExtractFileLog(ExtractLog exLog)
        {
            try
            {
                USPS_ACS_DataProvider.InsertExtractFileLog(exLog.FileName, exLog.FilePath, exLog.Version, exLog.DetailRecordIndicator, exLog.CustomerID, exLog.RecordCount, exLog.CreatedDate, exLog.HeaderText, exLog.ZipFileName, exLog.Status);
                return 0;
            }
            catch (Exception ex)
            {
                Logs.LogException("ProcessZip Error - InsertExtractFileLog", ex);
                return 1;
            }
        }

        private static void MoveZipFile(string currentFile, DownloadStatus status)
        {
            string folderPath = Path.Combine(Path.GetDirectoryName(currentFile), status.ToString(), Path.GetFileName(currentFile));
            try 
            {
                MoveFile(currentFile, folderPath,1);
                Logs.Info(String.Format("{0} moved to {1}", Path.GetFileName(currentFile), Path.GetDirectoryName(folderPath)));
             } 
            catch(Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, Path.GetFileName(currentFile), string.Empty, ex.Message));
                Logs.LogException(String.Format("ProcessFiles -- ArchiveZipFile: {0} failed", Path.GetFileName(currentFile)),ex);
            }
        }

        #endregion

        #region Process Extracted Files

        private static void ProcessFiles()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            int fileCount = 0;
            try
            {
                DataTable dt = USPS_ACS_DataProvider.SelectExtractFilesByStatus(ExtractFileStatus.New.ToString(),ExtractFileStatus.Extracted.ToString());
                
                foreach (DataRow dr in dt.Rows)
                {
                    int USPS_ACS_ExtractFileLog_ID = Convert.ToInt32(dr["USPS_ACS_ExtractFileLog_ID"]);
                    string filename = dr["FileName"].ToString();
                    string zipfilename = dr["ZipFileName"].ToString();
                    string filepath = dr["FilePath"].ToString();
                    string version = dr["Version"].ToString();
                    int recordCount = Convert.ToInt32(dr["RecordCount"]);  // this is coming from the header
                    string detailRecordIndicator = dr["DetailRecordIndicator"].ToString();
                    ExtractFileStatus currentStatus = (ExtractFileStatus)Enum.Parse(typeof(ExtractFileStatus), dr["Status"].ToString());

                    // if new status, open the file and extract the data, otherwise this file was extracted but the data was not successfully updated
                    if (currentStatus == ExtractFileStatus.New)
                    {
                        ExtractFileStatus status = ExtractRecords(USPS_ACS_ExtractFileLog_ID, filename, filepath, version, recordCount, detailRecordIndicator, zipfilename);

                        USPS_ACS_DataProvider.UpdateExtractFileLogStatus(USPS_ACS_ExtractFileLog_ID, status);

                        Logs.Info(String.Format("{0} processed as {1}", Path.GetFileName(filepath), status));

                        MoveExtractFile(filepath, status);
                    }


                    if (UpdateAddresses(USPS_ACS_ExtractFileLog_ID)) 
                    {
                        USPS_ACS_DataProvider.UpdateExtractFileLogStatus(USPS_ACS_ExtractFileLog_ID, ExtractFileStatus.Completed);
                    }
                    else 
                    { 
                        // the call to UpdateAddresses failed
                        Logs.Info(String.Format("UpdateAddresses failed for {0} - ExtractFileLog_ID: {1}", Path.GetFileName(filepath),USPS_ACS_ExtractFileLog_ID.ToString()));
                        errorList.Add(new USPS_ACS_Error(ErrorType.Update, "", Path.GetFileName(filepath), String.Format("UpdateAddresses failed for ExtractFileLog_ID: {0}", USPS_ACS_ExtractFileLog_ID.ToString())));
                    }


                    fileCount += 1;
                }
            }
            finally
            {
                stopwatch.Stop();
                Logs.Info(String.Format("{0} Files(s) processed.", fileCount.ToString()));
                Logs.Info(String.Format("Process Extracted Files Elapsed Time: {0} seconds.", (stopwatch.ElapsedMilliseconds / 1000).ToString()));
            }
        }

        private static bool UpdateAddresses(int extractFileLog_id)
        {
            bool result = false;
            try
            {
                USPS_ACS_DataProvider.UpdateAddress(extractFileLog_id);
                result = true;
            }
            catch (Exception ex)
            {
                Logs.LogException("ProcessFiles - UpdateAddresses() Error", ex);
                //errorList.Add(new USPS_ACS_Error(ErrorType.Update,"" ,"" , ex.Message, ex.StackTrace));
            }

            return result;

        }


        private static ExtractFileStatus ExtractRecords(int extractFileLog_id, string filename, string filepath, string version, int recordcount, string detailRecordIndicator, string zipfilename)
        {
            try
            {        
                string status = Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.Archived);
                if (recordcount > 0) // i
                {
                    int rCount = 0;
                    int fCount = 0;
                    // Open the stream and read it back. 
                    using (StreamReader sr = File.OpenText(filepath))
                    {
                        string s = string.Empty;
                        do
                        {
                            s = sr.ReadLine();
                            if (s.Length > 1) // this is here to protect against a last line that may or may not only have a CRLF
                            {
                                if (s.Substring(0, 1) == detailRecordIndicator) // only process detail records
                                {
                                    try 
                                    { 
                                        InsertExtractFileRecord(extractFileLog_id, filename, detailRecordIndicator, version, s);
                                        rCount += 1; 
                                    }
                                    catch (Exception ex)
                                    {
                                        errorList.Add(new USPS_ACS_Error(ErrorType.Extract, zipfilename, filename, "Failed to write ExtractFile record."));
                                        Logs.LogException("ProcessFiles - OpenFile() Error: Failed to write ExtractFile record.",ex);
                                        fCount += 1;
                                    }                
                                }
                            }
                        } while (sr.Peek() != -1);
                    }

                    Logs.Info(String.Format("{0} Record(s) extracted from {1}. {2} records failed.", rCount.ToString(), Path.GetFileName(filepath), fCount.ToString()));

                    if (fCount > 0)
                        return ExtractFileStatus.Extracted_w_Errors;
                    else
                        return ExtractFileStatus.Extracted;    
                } 
                else
                {
                    return ExtractFileStatus.Empty_File;   
                }
            }
            catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, zipfilename, filename, ex.Message));
                Logs.LogException("ProcessFiles - ExtractRecords() Error", ex);
                return ExtractFileStatus.Processing_Error;
            }

        }

        private static void InsertExtractFileRecord(int extractFileLog_id, string filename, string recordtype, string version, string recordText)
        {
                Schema schema = GetSchema(recordtype, version);

                string LastName = GetFieldValue(schema, recordText, "LastName");
                string FirstName_MI = GetFieldValue(schema, recordText, "FirstName-MiddleName-INITIALS");

                int spaceIdx = FirstName_MI.IndexOf(" ");

                string FirstName;
                string MiddleName;

                if (spaceIdx > 0) { 
                    FirstName = FirstName_MI.Substring(0, spaceIdx);
                    MiddleName = FirstName_MI.Substring(spaceIdx).Trim();
                } else
                {
                    FirstName = FirstName_MI;
                    MiddleName = string.Empty; 
                }

                string PrimaryNumberOld = GetFieldValue(schema, recordText, "PrimaryNumberOld");
                string PreDirectionalOld = GetFieldValue(schema, recordText, "PreDirectionalOld");
                string StreetNameOld = GetFieldValue(schema, recordText, "StreetNameOld");
                string StreetSuffixOld = GetFieldValue(schema, recordText, "StreetSuffixOld");
                string PostDirectionalOld = GetFieldValue(schema, recordText, "PostDirectionalOld");
                string UnitDesignatorOld = GetFieldValue(schema, recordText, "UnitDesignatorOld");
                string SecondaryNumberOld = GetFieldValue(schema, recordText, "SecondaryNumberOld");
                string CityOld = GetFieldValue(schema, recordText, "CityOld");
                string StateOld = GetFieldValue(schema, recordText, "StateOld");
                string FiveDigitZipCodeOld = GetFieldValue(schema, recordText, "FiveDigitZipCodeOld");


                string PrimaryNumberNew = GetFieldValue(schema, recordText, "PrimaryNumberNew");
                string PreDirectionalNew = GetFieldValue(schema, recordText, "PreDirectionalNew");
                string StreetNameNew = GetFieldValue(schema, recordText, "StreetNameNew");
                string StreetSuffixNew = GetFieldValue(schema, recordText, "StreetSuffixNew");
                string PostDirectionalNew = GetFieldValue(schema, recordText, "PostDirectionalNew");
                string CityNew = GetFieldValue(schema, recordText, "CityNew");
                string StateNew = GetFieldValue(schema, recordText, "StateNew");
                string FiveDigitZipCodeNew = GetFieldValue(schema, recordText, "FiveDigitZipCodeNew");
                string Plus4CodeNew = GetFieldValue(schema, recordText, "Plus4CodeNew");
                string UnitDesignatorNew = GetFieldValue(schema, recordText, "UnitDesignatorNew");
                string SecondaryNumberNew = GetFieldValue(schema, recordText, "SecondaryNumberNew");

                string AddressNew = string.Empty;

                if (PrimaryNumberNew.Length > 0) AddressNew = AddressNew + PrimaryNumberNew + " ";
                if (PreDirectionalNew.Length > 0) AddressNew = AddressNew + PreDirectionalNew + " ";
                if (StreetNameNew.Length > 0) AddressNew = AddressNew + StreetNameNew + " ";
                if (StreetSuffixNew.Length > 0) AddressNew = AddressNew + StreetSuffixNew + " ";
                if (PostDirectionalNew.Length > 0) AddressNew = AddressNew + PostDirectionalNew;

                string Address2New = string.Empty;

                if (UnitDesignatorNew.Length > 0) Address2New = Address2New + UnitDesignatorNew + " ";
                if (SecondaryNumberNew.Length > 0) Address2New = Address2New + SecondaryNumberNew;

                string MoveType = GetFieldValue(schema, recordText, "MoveType");

                USPS_ACS_DataProvider.InsertExtractFileRecord(
                               extractFileLog_id
                               , recordText
                               , FirstName
                               , LastName
                               , PrimaryNumberOld
                               , PreDirectionalOld
                               , StreetNameOld
                               , StreetSuffixOld
                               , PostDirectionalOld
                               , UnitDesignatorOld
                               , SecondaryNumberOld
                               , CityOld
                               , StateOld
                               , FiveDigitZipCodeOld
                               , PrimaryNumberNew
                               , PreDirectionalNew
                               , StreetNameNew
                               , StreetSuffixNew
                               , PostDirectionalNew
                               , UnitDesignatorNew
                               , SecondaryNumberNew
                               , CityNew
                               , StateNew
                               , FiveDigitZipCodeNew
                               , Plus4CodeNew
                               , AddressNew
                               , Address2New
                               , MoveType);

        }

        private static void MoveExtractFile(string currentFile, ExtractFileStatus status)
        {

            string folderPath = Path.Combine(Path.GetDirectoryName(currentFile), status.ToString(), Path.GetFileName(currentFile));

            try
            {
                MoveFile(currentFile, folderPath,1);
                Logs.Info(String.Format("{0} moved to {1}", Path.GetFileName(currentFile), Path.GetDirectoryName(folderPath)));
               
            } catch(Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, string.Empty, Path.GetFileName(currentFile), ex.Message));
                Logs.LogException(String.Format("ProcessFiles -- MoveExtractFile failed: {0}", Path.GetFileName(currentFile)),ex);
            }
        }

        #endregion

        private static string GetFieldValue(Schema schema, string recordText, string fieldName)
        {
            return recordText.Substring(schema.SchemaMappingList.First(x => x.ColumnName.Equals(fieldName, StringComparison.OrdinalIgnoreCase)).ColumnStart - 1, schema.SchemaMappingList.First(x => x.ColumnName.Equals(fieldName, StringComparison.OrdinalIgnoreCase)).ColumnWidth).Trim();
        }

        private static Schema GetSchema(string recordtype, string version)
        {
            DataSet schemaTable = USPS_ACS_DataProvider.SelectSchema(recordtype, version);
            return new Schema(schemaTable);
        }

        private static bool MoveFile(string currentLocation, string copyToLocation, int maxAttempts = 10)
        {
            return CopyFile(currentLocation, copyToLocation, true, maxAttempts);
        }

        private static bool CopyFile(string currentLocation, string copyToLocation, bool IsMove = false, int maxAttempts = 10)
        {
            bool result = false;
            FileInfo CurrentFileInfo = new FileInfo(currentLocation);
            FileInfo CopyToFileInfo;
            try
            {
                for (int i = 0; i < maxAttempts; i += 1)
                {
                    try
                    {
                        // if a file of the same already exists in the copytolocation, delete it.
                        if (File.Exists(copyToLocation))
                        {
                            File.Delete(copyToLocation);
                        }

                        // now copy or move the file to the new location
                        if (IsMove)
                        {
                            // move it

                            if (!Directory.Exists(Path.GetDirectoryName(copyToLocation)))
                            {
                                Directory.CreateDirectory(Path.GetDirectoryName(copyToLocation));
                            }

                            CurrentFileInfo.MoveTo(copyToLocation);
                            // now validate that it move was successful
                            if (!VerifyFileMove(copyToLocation))
                            {
                                throw new Exception("File failed to move successfully");
                            }
                            result = true;
                        }
                        else
                        {
                            // copy it
                            CurrentFileInfo.CopyTo(copyToLocation, true);
                            CopyToFileInfo = new FileInfo(copyToLocation);
                            // now validate that it copy was successful
                            if (!VerifyFileMove(copyToLocation))
                            {
                                // Copy was not successful
                                // Delete whatever was copied because it isn't right.
                                try
                                {
                                    if (CopyToFileInfo.Exists)
                                    {
                                        CopyToFileInfo.Delete();
                                    }
                                }
                                catch
                                {
                                }

                                throw new Exception("File failed to copy successfully");
                            }
                            result = true;
                        }

                        // everything went ok, so break out of the loop
                        if (result) break;

                    }
                    catch (Exception ex)
                    {
                        Exception newException = new Exception("Error Copying File From [" + currentLocation + "] To [" + copyToLocation + "] after " + i + " Attempts.", ex);
                        System.Threading.Thread.Sleep(1000);
                        throw newException;
                    }

                } // end of loop
                return result;
            }
            catch (Exception ex1)
            {
                Exception newException = new Exception("Error Copying File From [" + currentLocation + "] To [" + copyToLocation + "].", ex1);
                System.Threading.Thread.Sleep(1000);
                throw newException;
            }
            finally
            {
                CurrentFileInfo = null;
            }

        }

        private static bool VerifyFileMove(string filename)
        {
            FileInfo finfo = new FileInfo(filename);
            try
            {
                double size = finfo.Length / 1024;
                return true;
            }
            catch
            {
                return false;
            }
            finally
            {
                finfo = null;
            }
        }

        private static void SendErrorNotification(string serviceName, string errorMessage, Exception ex)
        {
            List<string> toList = new List<string>();
            List<string> ccList = new List<string>();
            List<string> bccList = new List<string>();
            string recipientNoteText = string.Empty;
            string recipientNoteHtml = string.Empty;
            string environmentName = string.Empty;
            string sqlCommand = string.Empty;
            string exceptionText = string.Empty;
            string exceptionHtml = string.Empty;
            string stackHtml = string.Empty;
            string stackText = string.Empty;
            string innerStackHtml = string.Empty;
            string innerStackText = string.Empty;
            string bodyText = string.Empty;
            string fileName = string.Empty;

            try
            {

                string sendTo = AppConfig.Params["USPS_ACS_SendErrorNotificationTo"].StringValue;
                string sendBcc = AppConfig.Params["USPS_ACS_SendErrorNotificationBcc"].StringValue;

                toList.Add(sendTo);
                bccList.Add(sendBcc);

                if (AppConfig.EnvironmentType != EnvironmentTypes.Production)
                {
                    // not in production
                    recipientNoteText = String.Format("{0}{0}Production To:{0}", System.Environment.NewLine);
                    foreach (string email in toList)
                    {
                        recipientNoteText += email;
                    }

                    recipientNoteText += String.Format("{0}Production CC:{0}", System.Environment.NewLine);
                    foreach (string email in ccList)
                    {
                        recipientNoteText += email;
                    }

                    recipientNoteText += String.Format("{0}Production BCC:{0}", System.Environment.NewLine);
                    foreach (string email in bccList)
                    {
                        recipientNoteText += email;
                    }
                    recipientNoteHtml = recipientNoteText.Replace(System.Environment.NewLine, "<BR>");

                    toList.Clear();
                    ccList.Clear();
                    bccList.Clear();

                    toList.Add(sendBcc);
                    environmentName = String.Format("({0})", AppConfig.EnvironmentName);
                }


                if (ex.GetType() == typeof(USPS_ACS_Exception))
                {
                    USPS_ACS_Exception uspsEx = (USPS_ACS_Exception)ex;
                    exceptionText = uspsEx.Message + USPS_ACS_Error.GetErrorTableText(uspsEx.ErrorList);
                    exceptionHtml = uspsEx.Message.Replace(System.Environment.NewLine, "<BR>") + USPS_ACS_Error.GetErrorTableHtml(uspsEx.ErrorList);
                }
                else
                {
                    exceptionText = ex.Message;
                    exceptionHtml = ex.Message.Replace(System.Environment.NewLine, "<BR>");
                }

                if (ex.StackTrace != null)
                {
                    stackText = ex.StackTrace;

                    stackHtml = ex.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at");
                    if (stackHtml.StartsWith("<BR>&nbsp;&nbsp;at"))
                    {
                        stackHtml = stackHtml.Substring("<BR>".Length);
                    }
                }
                else
                {
                    stackText = "N/A";
                    stackHtml = "N/A";
                }

                if (ex.InnerException != null)
                {
                    Exception innerEx = ex.InnerException;
                    while (innerEx != null)
                    {
                        if (innerStackText.Length > 0)
                        {
                            innerStackText += System.Environment.NewLine;
                            innerStackHtml += "<BR>";
                        }

                        if (innerEx.Message != null || innerEx.StackTrace != null)
                        {
                            innerStackText += "--------Inner Exception--------" + System.Environment.NewLine;
                            innerStackHtml += "--------Inner Exception--------<BR>";

                            if (innerEx.Message != null)
                            {
                                innerStackText += innerEx.Message + System.Environment.NewLine;
                                innerStackHtml += innerEx.Message.Replace(System.Environment.NewLine, "<BR>") + "<BR>";
                            }

                            if (innerEx.StackTrace != null)
                            {
                                innerStackText += innerEx.StackTrace + System.Environment.NewLine;
                                innerStackHtml += innerEx.StackTrace.Replace("   at", "<BR>&nbsp;&nbsp;at") + "<BR>";
                            }
                        }

                        innerEx = innerEx.InnerException;
                    }
                }
                else
                {
                    innerStackText = "N/A";
                    innerStackHtml = "--------Inner Exception--------<BR>N/A<BR>-------------------------------";
                }

                string smtpServer = AppConfig.SMTPServer;
                Message mailMessage = new Message("USPS_ACS_ServiceException", AppConfig.SMTPServer);


                foreach (string email in toList)
                {
                    mailMessage.To.Add(email);
                }

                foreach (string email in ccList)
                {
                    mailMessage.Cc.Add(email);
                }

                foreach (string email in bccList)
                {
                    mailMessage.Bcc.Add(email);
                }

                mailMessage.ReplacementValues.Add("ServiceName", serviceName);
                mailMessage.ReplacementValues.Add("Environment", environmentName);
                mailMessage.ReplacementValues.Add("Message", errorMessage);
                mailMessage.ReplacementValues.Add("DateOccurred", DateTime.Now.ToString());
                mailMessage.ReplacementValues.Add("MachineName", Environment.MachineName);
                mailMessage.ReplacementValues.Add("ExceptionText", exceptionText);
                mailMessage.ReplacementValues.Add("ExceptionHtml", exceptionHtml);
                mailMessage.ReplacementValues.Add("Source", ex.Source);
                mailMessage.ReplacementValues.Add("SQLCommand", sqlCommand);
                mailMessage.ReplacementValues.Add("StackTraceHtml", stackHtml);
                mailMessage.ReplacementValues.Add("StackTraceText", stackText);
                mailMessage.ReplacementValues.Add("InnerExceptionHtml", innerStackHtml + recipientNoteHtml);
                mailMessage.ReplacementValues.Add("InnerExceptionText", innerStackText + recipientNoteText);
                mailMessage.ReplacementValues.Add("FileName", fileName);

                //Merge the template
                mailMessage.MergeTemplate();

                bodyText = mailMessage.BodyText;

                mailMessage.Send();
            }
            catch (Exception ex1)
            {
                throw ex1;
            }
        }

        private static void SendStatusNotification(string serviceName, List<USPS_ACS_Notification> notifications, NotificationType ntype)
        {

            List<string> toList = new List<string>();
            List<string> ccList = new List<string>();
            List<string> bccList = new List<string>();
            string recipientNoteText = string.Empty;
            string recipientNoteHtml = string.Empty;
            string environmentName = string.Empty;

            string bodyText = string.Empty;
            string message = string.Empty;

            try
            {
                string sendTo = AppConfig.Params["USPS_ACS_SendStatusNotificationTo"].StringValue;
                string sendBcc = AppConfig.Params["USPS_ACS_SendStatusNotificationBcc"].StringValue;

                message += USPS_ACS_Notification.GetNotificationTableHtml(notifications, ntype);

                toList.Add(sendTo);
                bccList.Add(sendBcc);

                if (AppConfig.EnvironmentType != EnvironmentTypes.Production)
                {
                    // not in production
                    recipientNoteText = String.Format("{0}{0}Production To:{0}", System.Environment.NewLine);
                    foreach (string email in toList)
                    {
                        recipientNoteText += email;
                    }

                    recipientNoteText += String.Format("{0}Production CC:{0}", System.Environment.NewLine);
                    foreach (string email in ccList)
                    {
                        recipientNoteText += email;
                    }

                    recipientNoteText += String.Format("{0}Production BCC:{0}", System.Environment.NewLine);
                    foreach (string email in bccList)
                    {
                        recipientNoteText += email;
                    }
                    recipientNoteHtml = recipientNoteText.Replace(System.Environment.NewLine, "<BR>");

                    toList.Clear();
                    ccList.Clear();
                    bccList.Clear();

                    toList.Add(sendBcc);
                    environmentName = String.Format("({0})", AppConfig.EnvironmentName);
                }

                string smtpServer = AppConfig.SMTPServer;
                Message mailMessage = new Message("USPS_ACS_StatusNotification", AppConfig.SMTPServer);


                foreach (string email in toList)
                {
                    mailMessage.To.Add(email);
                }

                foreach (string email in ccList)
                {
                    mailMessage.Cc.Add(email);
                }

                foreach (string email in bccList)
                {
                    mailMessage.Bcc.Add(email);
                }

                mailMessage.ReplacementValues.Add("ServiceName", serviceName);
                mailMessage.ReplacementValues.Add("Environment", environmentName); ;               
                mailMessage.ReplacementValues.Add("DateOccurred", DateTime.Now.ToString());
                mailMessage.ReplacementValues.Add("MachineName", Environment.MachineName);
                mailMessage.ReplacementValues.Add("Message", message);

                //Merge the template
                mailMessage.MergeTemplate();

                bodyText = mailMessage.BodyText;

                mailMessage.Send();

            }catch (Exception ex)
            {
                throw ex;
            }

        }

        private static void SendPartialMatchReport(string serviceName)
        {

            List<string> toList = new List<string>();
            List<string> ccList = new List<string>();
            List<string> bccList = new List<string>();
            string recipientNoteText = string.Empty;
            string recipientNoteHtml = string.Empty;
            string environmentName = string.Empty;

            string bodyText = string.Empty;
            string partialMatchMessage = string.Empty;

            // Retrieve unprocessed partial match rows
            try
            {

                DataTable dt = USPS_ACS_DataProvider.SelectPendingPartialMatches(true);

                if (dt.Rows.Count > 0) {

                    partialMatchMessage += "<span><P>Partial and Multiple match summary<BR><BR>";

                    IEnumerable<DataRow> partialMatches = from myRow in dt.AsEnumerable() where myRow.Field<string>("Status") == "PartialMatch" select myRow;
                    IEnumerable<DataRow> multipleMatches = from myRow in dt.AsEnumerable() where myRow.Field<string>("Status") == "MultipleMatches" select myRow;

                    partialMatchMessage += "<table border='1' width='700px'>";
                    partialMatchMessage += "<tr><th>&nbsp</th><th colspan='6'>Days Since Received</tr>";
                    partialMatchMessage += "<tr><th width='18%'>Match Type</th><th width='12%'>0 - 7</th><th width='12%'>8 - 14</th><th width='12%'>15 - 21</th><th width='12%'>22 - 28</th><th width='12%'>29 - 56</th><th width='12%'>57+</th></tr>";

                    // Add Partial Match header and detail lines
                    if (partialMatches.ToList().Count > 0)
                    {
                        string sPM0 = string.Format("<td align='center'>{0}</td>",partialMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 0).Count().ToString());
                        string sPM1 = string.Format("<td align='center'>{0}</td>",partialMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 1).Count().ToString());
                        string sPM2 = string.Format("<td align='center'>{0}</td>",partialMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 2).Count().ToString());
                        string sPM3 = string.Format("<td align='center'>{0}</td>",partialMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 3).Count().ToString());
                        string sPM4 = string.Format("<td align='center'>{0}</td>",partialMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 4).Count().ToString());
                        string sPM5 = string.Format("<td align='center'>{0}</td>",partialMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 5).Count().ToString());

                        partialMatchMessage += string.Format("<tr><td>Partial Matches</td>{0}{1}{2}{3}{4}{5}</tr>", sPM0, sPM1, sPM2, sPM3, sPM4, sPM5);
                    }

                    // Add Multiple Match header and detail lines                    
                    if (multipleMatches.ToList().Count > 0) 
                    {
                        string sMM0 = string.Format("<td align='center'>{0}</td>", multipleMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 0).Count().ToString());
                        string sMM1 = string.Format("<td align='center'>{0}</td>", multipleMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 1).Count().ToString());
                        string sMM2 = string.Format("<td align='center'>{0}</td>", multipleMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 2).Count().ToString());
                        string sMM3 = string.Format("<td align='center'>{0}</td>", multipleMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 3).Count().ToString());
                        string sMM4 = string.Format("<td align='center'>{0}</td>", multipleMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 4).Count().ToString());
                        string sMM5 = string.Format("<td align='center'>{0}</td>", multipleMatches.ToList().Where(x => x.Field<int>("AgeAlert") == 5).Count().ToString());

                        partialMatchMessage += string.Format("<tr><td>Multiple Matches</td>{0}{1}{2}{3}{4}{5}</td></tr>", sMM0, sMM1, sMM2, sMM3, sMM4, sMM5);
                    }


                    partialMatchMessage += "</table></P><BR><BR></span>";

                    string sendTo = AppConfig.Params["USPS_ACS_SendStatusNotificationTo"].StringValue;
                    string sendBcc = AppConfig.Params["USPS_ACS_SendStatusNotificationBcc"].StringValue;


                    toList.Add(sendTo);
                    bccList.Add(sendBcc);

                    if (AppConfig.EnvironmentType != EnvironmentTypes.Production)
                    {
                        // not in production
                        recipientNoteText = String.Format("{0}{0}Production To:{0}", System.Environment.NewLine);
                        foreach (string email in toList)
                        {
                            recipientNoteText += email;
                        }

                        recipientNoteText += String.Format("{0}Production CC:{0}", System.Environment.NewLine);
                        foreach (string email in ccList)
                        {
                            recipientNoteText += email;
                        }

                        recipientNoteText += String.Format("{0}Production BCC:{0}", System.Environment.NewLine);
                        foreach (string email in bccList)
                        {
                            recipientNoteText += email;
                        }
                        recipientNoteHtml = recipientNoteText.Replace(System.Environment.NewLine, "<BR>");

                        toList.Clear();
                        ccList.Clear();
                        bccList.Clear();

                        toList.Add(sendBcc);
                        environmentName = String.Format("({0})", AppConfig.EnvironmentName);
                    }

                    string smtpServer = AppConfig.SMTPServer;
                    Message mailMessage = new Message("USPS_ACS_PartialMatchReport", AppConfig.SMTPServer);


                    foreach (string email in toList)
                    {
                        mailMessage.To.Add(email);
                    }

                    foreach (string email in ccList)
                    {
                        mailMessage.Cc.Add(email);
                    }

                    foreach (string email in bccList)
                    {
                        mailMessage.Bcc.Add(email);
                    }

                    mailMessage.ReplacementValues.Add("ServiceName", serviceName);
                    mailMessage.ReplacementValues.Add("Environment", environmentName); ;
                    mailMessage.ReplacementValues.Add("Message", partialMatchMessage);
                    mailMessage.ReplacementValues.Add("DateOccurred", DateTime.Now.ToString());
                    mailMessage.ReplacementValues.Add("MachineName", Environment.MachineName);

                    //Merge the template
                    mailMessage.MergeTemplate();

                    bodyText = mailMessage.BodyText;

                    mailMessage.Send();
                }

            }
            catch (Exception ex)
            {


            }

        }

        private static string BuildMatchDetail(string partialMatchMessage, DataRow dr)
        {
            partialMatchMessage += string.Format("<TR><TD colspan=6><BR>Study_id: <b>{0}</b> Pop_id: <b>{1}</b> Lithocode: <B>{2}</b></TD></TR>", dr["Study_id"].ToString(), dr["Pop_id"].ToString(), dr["strLithocode"].ToString());
            partialMatchMessage += string.Format("<TR><TD>Pop:</TD><TD>{0}</TD><TD>{1}</TD><TD>{2}</TD><TD>{3}</TD><TD>{4}</TD><TD>{5}</TD></TR>",
                dr["popFName"].ToString(), dr["popLName"].ToString(), dr["popAddr"].ToString(),
                dr["popCity"].ToString(), dr["PopSt"].ToString(), dr["popZip5"].ToString());
            partialMatchMessage += string.Format("<TR><TD>Old:</TD><TD>{0}</TD><TD>{1}</TD><TD>{2}</TD><TD>{3}</TD><TD>{4}</TD><TD>{5}</TD></TR>",
                dr["FName"].ToString(), dr["LName"].ToString(), dr["PrimaryNumberOld"].ToString() + " " + dr["PreDirectionalOld"].ToString() + " " + dr["StreetNameOld"].ToString() + " " + dr["StreetSuffixOld"].ToString() +
                " " + dr["PostDirectionalOld"].ToString() + " " + dr["UnitDesignatorOld"].ToString() + " " + dr["SecondaryNumberOld"].ToString(),
                dr["CityOld"].ToString(), dr["StateOld"].ToString(), dr["Zip5Old"].ToString());
            partialMatchMessage += string.Format("<TR><TD>New:</TD><TD>{0}</TD><TD>{1}</TD><TD>{2}</TD><TD>{3}</TD><TD>{4}</TD><TD>{5}</TD></TR>",
                dr["FName"].ToString(), dr["LName"].ToString(), dr["PrimaryNumberNew"].ToString() + " " + dr["PreDirectionalNew"].ToString() + " " + dr["StreetNameNew"].ToString() + " " + dr["StreetSuffixOld"].ToString() +
                " " + dr["PostDirectionalNew"].ToString() + " " + dr["UnitDesignatorNew"].ToString() + " " + dr["SecondaryNumberNew"].ToString(),
                dr["CityNew"].ToString(), dr["StateNew"].ToString(), dr["Zip5New"].ToString() + "-" + dr["Plus4ZipNew"].ToString()); 
            return partialMatchMessage;
        }


    }
}
