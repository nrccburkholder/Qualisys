using Microsoft.VisualBasic;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Text;
using System.Reflection;

//********************************************************************'
// Created by Tom D. - Date unknown
// 
// Auggur - Added functionality to limit the size of the file to 1mb
// Elibad - Added overloads to the Write trace to accept write the details of an exception
//          and inner exception details, also created a TraceFlag property
// Elibad - 07/09/2009 Cleaned up a lot of repeated code, reorganize 
//
//  This class provides support to create log files with a size limit of 1mb
//*********************************************************************
namespace NRC.Miscellaneous
{
	public class Tracer
	{
		#region "Private variables"

		private string _TracePath = "";
		private string _ErrorPath = "";

		private bool _TraceFlag = false;
		#endregion

		#region "Public Properties"

		public bool TraceFlag {
			get { return _TraceFlag; }
			set { _TraceFlag = value; }
		}

		public string FileName {
			get { return _TracePath; }
			set {
				if (!File.Exists(value)) {
					try {
                        File.WriteAllText(value, "");
						//My.Computer.FileSystem.WriteAllText(value, "", true);
						FileSystem.Kill(value);
					} catch (Exception ex) {
						throw new System.Exception("Invalid FileName for LogFile", ex);
					}
				}
				_TracePath = value;
			}
		}

		public string ErrorFileName {
			get { return _ErrorPath; }
			set {
				if (!File.Exists(value)) {
					try {
                        File.WriteAllText(value, "");
						FileSystem.Kill(value);
					} catch (Exception ex) {
						throw new System.Exception("Invalid FileName for ErrorLog", ex);
					}
				}
				_ErrorPath = value;
			}
		}

		#endregion

		#region "Construtors"

		public Tracer() : this(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Trace.Log"))
		{
		}

		public Tracer(string LogFile) : this(LogFile, Path.GetDirectoryName(LogFile) + "\\Trace_Errors.Log")
		{
		}

		public Tracer(string LogFile, string ErrorFile)
		{
			this.FileName = LogFile;
			this.ErrorFileName = ErrorFile;
		}

		#endregion

		public string CreateLineDivision()
		{
            if (_TraceFlag)
                return "-----------------------------------------------------------------------------";
            return "";

		}

		public void CreateLineDivision(bool TempTraceFlag)
		{
			CreateLineDivision(_TracePath, TempTraceFlag);
		}

		public void WriteTrace(bool TempTraceFlag, string Msg, System.Exception Exception)
		{
			WriteTrace(_TracePath, TempTraceFlag, Msg, Exception);
		}

		public void WriteTrace(bool TempTraceFlag, string Msg)
		{
			WriteTrace(TempTraceFlag, Msg, null);
		}

		public void WriteTrace(bool TempTraceFlag, System.Exception Exception)
		{
			WriteTrace(TempTraceFlag, null, Exception);
		}

		public void WriteTrace(string Msg)
		{
			WriteTrace(_TraceFlag, Msg);
		}

		public void WriteTrace(System.Exception Exception)
		{
			WriteTrace(_TraceFlag, Exception);
		}

		public void WriteTrace(string Msg, System.Exception Exception)
		{
			WriteTrace(_TraceFlag, Msg, Exception);
		}

		//Error methods
		public void WriteError(bool TempTraceFlag, string Msg, System.Exception Exception)
		{
			WriteTrace(_ErrorPath, TempTraceFlag, Msg, Exception);
		}

		public void WriteError(bool TempTraceFlag, string Msg)
		{
			WriteError(TempTraceFlag, Msg, null);
		}

		public void WriteError(bool TempTraceFlag, System.Exception Exception)
		{
			WriteError(TempTraceFlag, null, Exception);
		}

		public void WriteError(string Msg)
		{
			WriteError(_TraceFlag, Msg);
		}

		public void WriteError(System.Exception Exception)
		{
			WriteError(_TraceFlag, Exception);
		}

		public void WriteError(string Msg, System.Exception Exception)
		{
			WriteError(_TraceFlag, Msg, Exception);
		}

		#region "Private Methods"

		private void WriteLine(string FileName, string Msg, bool WriteTimeStamp = true)
		{
			string sExtraText = "";
			//### auggur 10/13/2006 added check to see if the message passed has a newline
			//character at the end if it does then write to file as is if not then add it.

			if (WriteTimeStamp) {
				sExtraText = "               Time: " + DateAndTime.Now;
			}


			if (Strings.Right(Msg, 1) == Environment.NewLine || Strings.Right(Msg, 1) == Constants.vbCr || Strings.Right(Msg, 1) == Constants.vbLf) {
				Msg = Strings.Left(Msg, Msg.Length - 1);
			}

			File.AppendAllText(FileName, Msg + sExtraText + Environment.NewLine);
		}

		private void VerifyFileSize(string FileName, int SizeMB = 1)
		{
			StreamReader sr = null;
			string[] StrArray = null;
			string sFileData = null;
			double realFileSize = 0;
			//_TracePath = My.Application.Info.DirectoryPath & "\Trace.Log"

			//### auggur 09/22/2006 only perform file size chekc if file exists.
			if (File.Exists(FileName) == true) {
				//### auggur 09/08/2006 get the file size in bytes and do math to get it to Megabites
                realFileSize = new FileInfo(FileName).Length;
				realFileSize = realFileSize / 1024;
				//KB'S
				realFileSize = realFileSize / 1024;
				//MBS
				//### auggur 09/08/2006added check for file size in order to limit 
				//it's growth to only one megabyte 
				if ((realFileSize) > SizeMB) {
					//read the file into array
					sr = File.OpenText(FileName);
					//string = contents of file
					sFileData = sr.ReadToEnd();
					//close stream
					sr.Close();
					//eliminate data at the begining of the string(old data)
					sFileData = sFileData.Substring(Convert.ToInt32(sFileData.Length * 0.25), (sFileData.Length - Convert.ToInt32(sFileData.Length * 0.25)));
					//fill array with data
					StrArray = Strings.Split(sFileData, ControlChars.NewLine);
					//drop the old file
					FileSystem.Kill(FileName);
					//write the truncated array to the file
					File.WriteAllLines(FileName, StrArray);
				}
			}

		}

		private void CreateLineDivision(string FileName, bool TempTraceFlag)
		{
			if (TempTraceFlag) {
				File.AppendAllText(FileName, "-----------------------------------------------------------------------------" + Environment.NewLine);
			}
		}


		private void WriteException(string FileName, System.Exception Exception)
		{
            StringBuilder sb = new StringBuilder();
			try {
				VerifyFileSize(FileName);
                sb.AppendLine(CreateLineDivision());

                sb.AppendLine("Exception.Message: " + Exception.Message);
                sb.AppendLine("Exception.Source: " + Exception.Source);
                sb.AppendLine("Exception.StackTrace: " + Exception.StackTrace);

				//write out any data related to the exception
				if (Exception.Data.Count > 0) {
                    sb.AppendLine("Exception.Data: ");
					foreach (DictionaryEntry de in Exception.Data) {
                        sb.AppendLine("     " + de.Key.ToString() + " ... " + de.Value.ToString());
					}
				}

				System.Exception iEx = Exception.InnerException;

				while (iEx != null) {
                    sb.AppendLine(CreateLineDivision());
                    
					sb.AppendLine("Inner Exception.Message: " + Exception.InnerException.Message);
                    sb.AppendLine("Inner Exception.StackTrace: " + Exception.InnerException.StackTrace);
					iEx = iEx.InnerException;
				}

                sb.AppendLine(CreateLineDivision());
                File.AppendAllText(FileName, sb.ToString());
			} catch (Exception ex) {
				//since this is an error resizing or writing to the trace log just create
				// and write to a new file.
				File.WriteAllText(Path.GetDirectoryName(FileName) + "\\Trace-ERROR-Ocurred.err", "ERROR: 2000 - Error trying to write to trace file at: " + FileName + " : Time:" + DateAndTime.Now + " : " + ex.Message + Environment.NewLine);
			}
		}

		private void WriteTrace(string FileName, bool TempTraceFlag, string Msg, System.Exception Exception)
		{
			try {
				//Me._TraceFlag = TraceFlag
				if (TempTraceFlag) {
					VerifyFileSize(FileName);
					if (Msg != null && !string.IsNullOrEmpty(Msg)) {
                        File.AppendAllText(FileName, Msg);
					}
					if (Exception != null) {
						WriteException(FileName, Exception);
					}
				}
			} catch (Exception ex) {
				//since this is an error resizing or writing to the trace log just create
				// and write to a new file.
                File.AppendAllText(Path.GetDirectoryName(FileName) + "\\Trace-ERROR-Ocurred.err", "ERROR: 2000 - Error trying to write to trace file at: " + FileName + " : Time:" + DateAndTime.Now + " : " + ex.Message + Environment.NewLine);
			}
		}
		#endregion

	}

}

