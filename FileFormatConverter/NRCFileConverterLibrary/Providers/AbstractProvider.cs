using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.common;
using NRCFileConverterLibrary.Common;

namespace NRCFileConverterLibrary.Providers
{
    public abstract class AbstractProvider : IProvider
    {

        #region Events
        /// <summary>
        /// Event raised to do Initialization.
        /// </summary>
        public event EventHandler OnInitialize;
        /// <summary>
        /// Event raised before Event Conversion Begins.
        /// </summary>
        public event EventHandler OnBeginConversion;
        /// <summary>
        /// Event raised once Conversion is complete.
        /// </summary>
        public event EventHandler OnEndConversion;

        public event EventHandler<LogTraceArgs> LogTraceListeners;
        #endregion //Events

        #region properties

        public string Name { get; set; }
        public string FileType { get; set; }
        public string InputPath { get; set; }
        public string InProcessPath { get; set; }
        public string OutPath { get; set; }
        public string ArchivePath { get; set; }
        public string PrimaryKey { get; set; }

        #endregion //properties

        #region protected members
        protected void Archive(string FullFilePath)
        {
            try
            {
                // Extract the file
                FileInfo file = new FileInfo(FullFilePath);
                // add to the archive path.
                string fileName = file.Name;
                if (File.Exists(Path.Combine(ArchivePath, fileName)))
                {
                    fileName = Utility.MakeFileNameUnique(file.Name);

                }
                File.Move(FullFilePath, Path.Combine(ArchivePath, fileName));
                File.Delete(Path.Combine(InputPath, file.Name));
            }
            catch (Exception)
            {
                //log
                throw;
            }

        }

        protected void MoveFileToProcess(string filePath)
        {
            try
            {
                var file = new FileInfo(filePath);
                var processPath = this.InProcessPath + file.Name;
                var accessProcessPath = processPath.Replace("csv", "accdb");
                File.Copy(filePath, processPath);

            }
            catch (Exception)
            {

                throw;
            }
        }

        protected string MovetoOutPutLocation(string processPath, string fileType)
        {
            string outFilePath;
            try
            {
                string[] fullfname = processPath.Split('.');
                if (fullfname.Count() > 1)
                {
                    var fileInfo = new FileInfo(fullfname[0] + fileType);
                    var outFilename = fileInfo.Name;
                    if (File.Exists(Path.Combine(OutPath, fileInfo.Name)))
                    {
                        outFilename = Utility.MakeFileNameUnique(outFilename);

                    }
                    outFilePath = Path.Combine(OutPath, outFilename);
                    File.Move(fileInfo.FullName, outFilePath);
                }
                else
                    throw new ProviderException("Invalid file path:" + processPath);
            }
            catch (Exception)
            {
                //log   
                throw;
            }
            return outFilePath;
        }

        #endregion //protected members

        #region Public methods
        /// <summary>
        /// File conversion initiated by this Method.
        /// </summary>
        public void Convert()
        {
            Initialize();
            if (null != OnInitialize)
                OnInitialize(this, new EventArgs());
            List<string> InPutFiles = CheckForWork();
            Validate();
            if (null != OnBeginConversion)
                OnBeginConversion(this, new EventArgs());
            //BeginConversion();
            //check the directory with all csv files
            foreach (var filePath in InPutFiles)
            {
                Trace(string.Format("Started processing the file:'{0}'", filePath));

                MoveFileToProcess(filePath);
                Trace(string.Format("File:'{0}' moved to {1}", filePath, InProcessPath));

                var file = new FileInfo(filePath);
                var processPath = Path.Combine(InProcessPath, file.Name);

                try
                {
                    var convertedfile = ConvertTheFile(processPath);
                    Trace(string.Format("File:'{0}' conversion complete ", processPath));

                    var outFilePath = MovetoOutPutLocation(processPath, ".accdb");
                    Trace(string.Format("File:'{0}' moved to output directory {1}.", outFilePath, OutPath));
                }
                catch (Exception ex)
                {
                    //Failure converting, creating an output error file with the exception details

                    string errorOutFilePath = Path.Combine(OutPath, "ERROR_" + file.Name + DateTime.Now.ToString("yyyyMMdd-HHmmss") + ".TXT");
                    File.WriteAllText(errorOutFilePath, ex.ToString());

                    throw;
                }
                finally
                {
                    Archive(processPath);
                    Trace(string.Format("File:'{0}' Archived.", processPath));
                }

                Trace(string.Format("Completed processing the file:'{0}'", filePath));
            }

            if (null != OnEndConversion)
                OnEndConversion(this, new EventArgs());
            EndConversion();

        }

        private void Trace(string message)
        {
            message = Logs.FormatMessage(message);
            Logs.Trace(message);

            //This is how the log entires are bubbled up to the UI without the nLog functionality
            if (LogTraceListeners != null)
            {
                LogTraceListeners(this, new LogTraceArgs() { Message = message });  
            }
        }

        public abstract string ConvertTheFile(string processPath);

        public abstract void Validate();

        /// <summary>
        /// This Method checks if unprocessed files are present in the input folder.
        /// </summary>
        public virtual List<string> CheckForWork()
        {
            List<string> InPutFiles = new List<string>();
            InPutFiles.AddRange(FileConverter.GetFiles(this.InputPath, this.FileType, SearchOption.TopDirectoryOnly).ToList());
            return InPutFiles;
        }

        #endregion //Public methods

        #region Protected methods
        protected virtual void EndConversion() { }

        protected virtual void Initialize()
        {

            try
            {
                string[] inProcessFiles = Directory.GetFiles(InProcessPath);
                // Delete source files that were copied.
                foreach (string f in inProcessFiles)
                {
                    File.Delete(f);
                }
            }

            catch (Exception)
            {
                // The calling function will handle this exception.
                throw;
            }


        }
        #endregion //Protected
    }
}
