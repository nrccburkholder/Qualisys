using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using CommonTools;
using SurveyPointDAL;
using Tools;
using DataAccess;

namespace SurveyPointClasses
{
    /// <summary>
    /// Summary description for clsImportUpdate.
    /// </summary>
    public class clsImportUpdate
    {
        public clsImportUpdate(string sWorkingDir)
        {
            Random rnd = new Random(unchecked((int)DateTime.Now.Ticks));
            string logFilename = String.Format("{0}\\iu_{1}.log", sWorkingDir, rnd.Next(1, Int16.MaxValue));
            _importLog = new FileInfo(logFilename);
            DMI.DataHandler.sConnection = DataAccess.DBConnections.GetConnectionString(clsConnection.MAIN_DB);
        }

        private FileInfo _importLog;
        private string _ImportFilename;
        private int _TemplateID;
        private int _SurveyInstanceID = -1;
        private bool _allowRedoOfResponses = false;

        public string ImportLogFilename
        {
            get
            {
                if (_importLog != null)
                    return Tools.clsTextLog.GetLogFilename(_importLog);
                else
                    return null;
            }
        }

        public string ImportFilename
        {
            get
            {
                return _ImportFilename;
            }
            set
            {
                _ImportFilename = value;
            }
        }

        public int SurveyInstanceID
        {
            get
            {
                return _SurveyInstanceID;
            }
            set
            {
                _SurveyInstanceID = value;
            }
        }

        public int TemplateID
        {
            get
            {
                return _TemplateID;
            }
            set
            {
                _TemplateID = value;
            }
        }

        public bool AllowRedoOfResponses
        {
            get
            {
                return _allowRedoOfResponses;
            }

            set
            {
                _allowRedoOfResponses = value;
            }
        }

        public void SetProcess(int iTemplateID, int iSurveyInstanceID, string sImportFile)
        {
            if (iTemplateID < 0) iTemplateID = clsNCRTools.extractTemplateIDFromFile(sImportFile);
            TemplateID = iTemplateID;
            SurveyInstanceID = iSurveyInstanceID;
            ImportFilename = sImportFile;
        }

        public void StartProcess()
        {
            ProcessFile(TemplateID, SurveyInstanceID, ImportFilename);
        }

        public void ProcessFile(int iTemplateID, int iSurveyInstanceID, string sImportFile)
        {
            clsTextLog.Log(_importLog, "*** start update import ***");
            StreamReader sr = null;
            SqlConnection conn = null;
            SqlTransaction trans = null;
            try
            {
                // init working vars
                IImportFile fileRowProc = null;
                clsSurveyInterview survey = null;
                dsSurveyPoint.TemplatesRow t = null;
                int iLastTemplateId = -1;
                int iLastFileDefId = -1;
                int iLastScriptId = -1;
                int rowsCount = 0;

                // get count of rows in file
                int rowsTotal = getTotalRows(sImportFile);
                clsTextLog.Log(_importLog, String.Format("*** {0} lines to process ***", rowsTotal));
                if (rowsTotal > 0)
                {
                    clsTextLog.Log(_importLog, "*** read import file ***");
                    sr = clsFileIO.getFileReader(sImportFile);

                    clsTextLog.Log(_importLog, "*** open db connection ***");
                    string connStr = DBConnections.GetConnectionString(clsConnection.MAIN_DB);
                    conn = new SqlConnection(connStr);
                    conn.Open();
                    clsTriggers trigger = new clsTriggers();
                    trigger.DBConnection = conn;
                    trigger.UserID = 1;

                    while (sr.Peek() >= 0)
                    {
                        rowsCount++;

                        clsTextLog.Log(_importLog, String.Format("* start line {0} *", rowsCount));

                        // get next line
                        string sFileRow = sr.ReadLine();

                        // get template
                        int iCurrentTemplateId;
                        if (iTemplateID > 0)
                            iCurrentTemplateId = iTemplateID;
                        else
                            iCurrentTemplateId = clsNCRTools.getTemplateIDFromLine(sFileRow);
                        if (iLastTemplateId != iCurrentTemplateId)
                        {
                            t = clsTemplate.getTemplate(iCurrentTemplateId);
                            iLastTemplateId = iCurrentTemplateId;
                        }
                        if (t != null)
                        {

                            //get file processor
                            if (iLastFileDefId != t.FileDefID)
                            {
                                fileRowProc = ImportFile.clsFactory.CreateByFileDef(t.FileDefID);
                                fileRowProc.FileDefID = t.FileDefID;
                                fileRowProc.SurveyInstanceID = iSurveyInstanceID;
                                fileRowProc.AllowRedoOfResponses = AllowRedoOfResponses;
                                iLastFileDefId = t.FileDefID;
                            }
                            fileRowProc.TemplateID = t.TemplateID;

                            // get survey
                            if (iLastScriptId != t.ScriptID)
                            {
                                clsTextLog.Log(_importLog, String.Format("*** init script {0} ***", t.ScriptID));
                                survey = new clsSurveyInterview(t.ScriptID, 1, conn);
                                survey.InputMode = QMS.qmsInputMode.VERIFY;
                                iLastScriptId = t.ScriptID;
                            }

                            // begin transaction
                            trans = conn.BeginTransaction();

                            // parse and import line
                            fileRowProc.DBTransaction = trans;
                            fileRowProc.ImportRow(sFileRow);

                            // run after import update trigger
                            trigger.DBTransaction = trans;
                            trigger.RunTriggers(InvocationPoint.AFTER_IMPORT_UPDATE);

                            //indicate one line has been processed
                            ProcessedEventArgs args = new ProcessedEventArgs(rowsCount, rowsTotal, ImportLogFilename);
                            OnRowProc(args);

                            // log warnings
                            if (fileRowProc.WarningMessage != null && fileRowProc.WarningMessage.Length > 0)
                            {
                                clsTextLog.Log(_importLog, "warnings:\r\n" + fileRowProc.WarningMessage);
                            }


                            // log errors
                            if (fileRowProc.ErrorMessage != null && fileRowProc.ErrorMessage.Length > 0)
                            {
                                clsTextLog.Log(_importLog, "errors:\r\n" + fileRowProc.ErrorMessage);
                            }
                            else
                            {
                                // score responses, and run after score triggers
                                survey.DBTransaction = trans;
                                survey.Score(fileRowProc.RespondentID);
                                trigger.RunTriggers(InvocationPoint.AFTER_IMPORT_UPDATE_SCORING);
                                clsTextLog.Log(_importLog, String.Format("Imported Respondent ID {0}", fileRowProc.RespondentID));
                            }

                            //commit transaction if no problems
                            if (trigger.HasTriggerErrors())
                                trans.Rollback();
                            else
                                trans.Commit();

                            trans = null;

                        }
                        else
                            clsTextLog.Log(_importLog, String.Format("Template id {0} not found.", iLastTemplateId));

                        clsTextLog.Log(_importLog, String.Format("* end line {0} *", rowsCount));

                    }

                }

                ProcessedEventArgs e = new ProcessedEventArgs(rowsCount, rowsTotal, ImportLogFilename);
                OnFileProc(e);

            }
            catch (Exception e)
            {
                clsTextLog.Log(_importLog, String.Format("{0}\n{1}\n{2}", e.Message, e.StackTrace, e.Source));
            }
            finally
            {
                if (sr != null) sr.Close();
                if (trans != null) trans.Rollback();
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                    conn.Dispose();
                }
                clsTextLog.Log(_importLog, "*** end update import ***");

                ProcessedEventArgs args = new ProcessedEventArgs(0, 0, ImportLogFilename);
                OnCompleteProc(args);
            }


        }

        private int getTotalRows(string sFilename)
        {
            int count = 0;
            StreamReader sr = null;
            try
            {
                sr = clsFileIO.getFileReader(sFilename);
                while (sr.ReadLine() != null)
                {
                    count++;
                }
            }
            finally
            {
                if (sr != null) sr.Close();
            }

            return count;

        }
        public event RowProcessedEventHandler RowProc;
        public event FileProcessedEventHandler FileProc;
        public event CompleteEventHandler CompleteProc;

        protected virtual void OnRowProc(ProcessedEventArgs e)
        {
            if (RowProc != null)
            {
                // Invokes the delegates. 
                RowProc(this, e);
            }

        }

        protected virtual void OnFileProc(ProcessedEventArgs e)
        {
            if (FileProc != null)
            {
                // Invokes the delegates. 
                FileProc(this, e);
            }
        }

        protected virtual void OnCompleteProc(ProcessedEventArgs e)
        {
            if (CompleteProc != null)
            {
                CompleteProc(this, e);
            }
        }
    }

    public delegate void RowProcessedEventHandler(object sender, ProcessedEventArgs args);
    public delegate void FileProcessedEventHandler(object sender, ProcessedEventArgs args);
    public delegate void CompleteEventHandler(object sender, ProcessedEventArgs args);

    public class ProcessedEventArgs : EventArgs
    {
        private int _RowsProcessed = 0;
        private int _RowsTotal = 0;
        private string _LogFile;

        public ProcessedEventArgs(int iRowsProcessed, int iTotalRows, string sLogFile)
        {
            RowsProcessed = iRowsProcessed;
            RowsTotal = iTotalRows;
            LogFile = sLogFile;

        }

        public string LogFile
        {
            get
            {
                return _LogFile;
            }
            set
            {
                _LogFile = value;
            }
        }

        public int RowsProcessed
        {
            get
            {
                return _RowsProcessed;
            }
            set
            {
                _RowsProcessed = value;
            }
        }

        public int RowsTotal
        {
            get
            {
                return _RowsTotal;
            }
            set
            {
                _RowsTotal = value;
            }
        }

        public int PercentProcessed()
        {
            if (RowsTotal > 0)
            {
                return Convert.ToInt32(100 * ((1.0 * RowsProcessed) / (1.0 * RowsTotal)));
            }
            else
                return -1;
        }
    }


}
