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
        private static string USPS_ACS_fileExtractionPath  = string.Empty;


        #region constants


        #endregion

        public static void DoDownloadWork()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();
            errorList.Clear();

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
            }

        }


        public static void DoExtractWork()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();
            errorList.Clear();

            try
            {                
                ExtractFiles();
                ProcessFiles();
                //UpdateAddresses();

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
                        int downloadLog_id = USPS_ACS_DataProvider.InsertDownloadLog(key, fileId, fileName, status, size, code, name, fulfilled, modified, fileURL, Enum.GetName(typeof(DownloadStatus), DownloadStatus.New));

                        string downloadStatus;
                        if (DownloadFile(fileURL, fileName))
                        {
                            // Set the status of the file. By default when a file URL is retrieved from the webservice by calling getFile(),
                            // the status is set to ‘S’. Acceptable values are N=New, S=Started, C=Completed, or X=Canceled. Any other
                            // values passed are defaulted to C. 
                            downloadStatus = "C"; // completed
                        }
                        else
                        {
                            downloadStatus = "X";  //mark as canceled
                        }
                        fdl.setStatus(authToken, key, fileId, downloadStatus);
                        Logs.Info(String.Format("DownloadFile: {0} -- status {1}", fileName , downloadStatus));
                        USPS_ACS_DataProvider.UpdateDownloadLogStatus(downloadStatus);
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
                errorList.Add(new USPS_ACS_Error(ErrorType.Download, ex.Message));
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

            if (Directory.Exists(path))
            {
                string[] extensions = new string[1] { ".zip" };
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
                using (Ionic.Zip.ZipFile zip1 = ZipFile.Read(zipFile))
                {
                    // Here, we extract conditionally based on entry name.  
                    foreach (ZipEntry e in zip1.Where(x => (!Path.GetFileNameWithoutExtension(x.FileName).EndsWith("N")))) // we are not extracting the files whose filenames end with 'N' because those are just billing statements.
                    {
                        string Password = AppConfig.Params["USPS_ACS_FileExtractionPassword"].StringValue; 
                        e.ExtractWithPassword(extractToPath, ExtractExistingFileAction.OverwriteSilently, Password);
        
                        string path = Path.Combine(extractToPath, e.FileName);
                        // We retrive information from the file's header.
                        ExtractLog exLog = ReadFileHeader(path, Path.GetFileName(zipFile));

                        // Add the record to the USPS_ACS_ExtractFileLog table
                        int extractFileLog_id = USPS_ACS_DataProvider.InsertExtractFileLog(exLog.FileName, exLog.FilePath, exLog.Version, exLog.DetailRecordIndicator, exLog.CustomerID, exLog.RecordCount, exLog.CreatedDate, exLog.HeaderText, exLog.ZipFileName, exLog.Status);
                        extractCount += 1;
                    }
                }

                // Archive the zip file
                ArchiveZipFile(zipFile);

                Logs.Info(String.Format("{0} Files extracted from {1}",extractCount.ToString(),Path.GetFileName(zipFile)));

            }
            catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, ex.Message));
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
                    string s = "";
                    
                    if (!sr.EndOfStream)
                    {
                        s = sr.ReadLine(); // read the first line
                        string recordType = s.Substring(0, 1);
                        if (recordType == "H") // check to see if the record is a header record
                        {
                            
                            string version = s.Substring(1, 2);
                            if (!version.Equals("01"))  // if it's not version "01" then it's the old version, which we are indicating by "00"
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
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, ex.Message));
                return exlog; 
            }
            finally
            {

            }
        }

        private static void ArchiveZipFile(string currentFile)
        {
            string archivePath = Path.Combine(Path.GetDirectoryName(currentFile), "Archive", Path.GetFileName(currentFile));
            try 
            {
                MoveFile(currentFile, archivePath);

                USPS_ACS_DataProvider.UpdateDownloadLogStatus(Path.GetFileName(currentFile),Enum.GetName(typeof(DownloadStatus),DownloadStatus.Archived));

             } catch(Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, ex.Message));
                Logs.LogException(String.Format("ProcessFiles -- ArchiveZipFile: {0}", Path.GetFileName(currentFile)),ex);
            }

        }

        #endregion

        #region Process Extracted Files

        private static void ProcessFiles()
        {

            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            DataTable dt = USPS_ACS_DataProvider.SelectExtractFilesByStatus(Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.New));

            int fileCount = 0;
            foreach (DataRow dr in dt.Rows)
            {
                OpenFile(dr);
                fileCount += 1;
            }

            stopwatch.Stop();
            Logs.Info(String.Format("{0} Files(s) processed.", fileCount.ToString()));
            Logs.Info(String.Format("Process Files Elapsed Time: {0} seconds.", (stopwatch.ElapsedMilliseconds / 1000).ToString()));

        }


        private static void OpenFile(DataRow dr)
        {
            try
            {
                int USPS_ACS_ExtractFileLog_ID = Convert.ToInt32(dr["USPS_ACS_ExtractFileLog_ID"]);
                string filename = dr["FileName"].ToString();
                string filepath = dr["FilePath"].ToString();
                string version = dr["Version"].ToString();
                int recordCount = Convert.ToInt32(dr["RecordCount"]);  // this is coming from the header
                string detailRecordIndicator = dr["DetailRecordIndicator"].ToString();

                string status = Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.Archived);
                if (recordCount > 0) // i
                {
                    int rCount = 0;
                    // Open the stream and read it back. 
                    using (StreamReader sr = File.OpenText(filepath))
                    {
                        string s = "";
                        do
                        {
                            s = sr.ReadLine();
                            if (s.Length > 1) // this is here to protect against a last line that may or may not only have a CRLF
                            {
                                if (s.Substring(0, 1) == detailRecordIndicator) // only process detail records
                                {
                                    InsertExtractFileRecord(USPS_ACS_ExtractFileLog_ID, filename, detailRecordIndicator, version, s);
                                    rCount += 1;
                                }
                            }
                        } while (sr.Peek() != -1);
                    }

                    Logs.Info(String.Format("{0} Record(s) extracted from {1}", rCount.ToString(), Path.GetFileName(filepath)));
                } 
                else
                {
                    status = Enum.GetName(typeof(ExtractFileStatus), ExtractFileStatus.Empty_File);
                    Logs.Info(String.Format("{0} is an EMPTY FILE",Path.GetFileName(filepath)));
                }

                ArchiveExtractFile(USPS_ACS_ExtractFileLog_ID,filepath, status);

                
            }
            catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, ex.Message));
                Logs.LogException("ProcessFiles - OpenFile() Error", ex);
            }

        }


        private static void InsertExtractFileRecord(int extractFileLog_id, string filename, string recordtype, string version, string recordText)
        {

            try
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
                    MiddleName = "";
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

                string newAddress = "";

                if (PrimaryNumberNew.Length > 0) newAddress = newAddress + PrimaryNumberNew + " ";
                if (PreDirectionalNew.Length > 0) newAddress = newAddress + PreDirectionalNew + " ";
                if (StreetNameNew.Length > 0) newAddress = newAddress + StreetNameNew + " ";
                if (StreetSuffixNew.Length > 0) newAddress = newAddress + StreetSuffixNew + " ";
                if (PostDirectionalNew.Length > 0) newAddress = newAddress + PostDirectionalNew;

                USPS_ACS_DataProvider.InsertExtractFileRecord(extractFileLog_id, recordText, FirstName, LastName, PrimaryNumberOld, StreetNameOld, CityOld, StateOld, FiveDigitZipCodeOld, UnitDesignatorOld, SecondaryNumberOld, newAddress, CityNew, StateNew, UnitDesignatorNew, SecondaryNumberNew, FiveDigitZipCodeNew, Plus4CodeNew);

            } catch (Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, ex.Message));
                Logs.LogException("ProcessFiles - InsertExtractFileRecord() Error", ex);
            }
        }

        private static void ArchiveExtractFile(int extractFileLog_id, string currentFile, string status)
        {
            string archivePath = Path.Combine(Path.GetDirectoryName(currentFile), "Archive", Path.GetFileName(currentFile));

            try
            {
                 MoveFile(currentFile, archivePath);

                 if (USPS_ACS_DataProvider.UpdateExtractFileLogStatus(extractFileLog_id, status) > 0)
                 {
                     Logs.Info(String.Format("ExtractFile {0} status set to {1}.", Path.GetFileName(currentFile), status));
                 }
                 else throw new Exception(String.Format("ExtractFile {0} status set failed.", Path.GetFileName(currentFile)));

            } catch(Exception ex)
            {
                errorList.Add(new USPS_ACS_Error(ErrorType.Extract, ex.Message));
                Logs.LogException(String.Format("ProcessFiles -- ArchiveExtractFile: {0}", Path.GetFileName(currentFile)),ex);
            }
        }


        #endregion

        #region Update Addresses

        private static void UpdateAddresses()
        {
            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            //DataTable dt = USPS_ACS_DataProvider.SelectExtractFileRecordsByStatus(Enum.GetName(typeof(ExtractFileRecordStatus), ExtractFileRecordStatus.New));

            //foreach (DataRow dr in dt.Rows)
            //{
            //    UpdateRecords(dr);
            //}

            stopwatch.Stop();
            Logs.Info(String.Format("Update Addresses Elapsed Time: {0} seconds.", (stopwatch.ElapsedMilliseconds / 1000).ToString()));
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
                        }

                        // everything went ok, so break out of the loop
                        result = true;
                        break;
                    }
                    catch (Exception ex)
                    {
                        Exception newException = new Exception("Error Copying File From [" + currentLocation + "] To [" + copyToLocation + "] after " + i + " Attempts.", ex);
                        System.Threading.Thread.Sleep(1000);
                    }

                } // end of loop
                return result;
            }
            catch
            {
                return false;
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

    }
}
