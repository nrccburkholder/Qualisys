using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
using Utilities;

namespace NRC.Miscellaneous
{

	public class Stubborn_SQL_Runner
	{

		private int _iRetryThreshold;
		private int _iRetryIntervalStart;
		private int _iRetryIntervalEnd;
        private ArrayList _aExceptionKeys = new ArrayList();

		private Miscellaneous.Tracer _Tracer;

		/// <summary>
		/// The number of times to retry a SQL statement before sending a notification email.
		/// </summary>
		public int RetryCount {
			get { return this._iRetryThreshold; }
			set { this._iRetryThreshold = value; }
		}

		/// <summary>
		/// This is the amount of time in seconds to wait between each execution of the SQL statement.
		/// </summary>
		public int RetryIntervalStart {
			get { return this._iRetryIntervalStart; }
			set { this._iRetryIntervalStart = value; }
		}

		/// <summary>
		/// (not yet implemented)
		/// </summary>
		public int RetryIntervalEnd {
			get { return this._iRetryIntervalEnd; }
			set { this._iRetryIntervalEnd = value; }
		}

		/// <summary>
		/// This object is used to write entries to the trace log after [RetryCount] number of errors have occured.
		/// </summary>
		public Tracer Tracer {
			get { return this._Tracer; }
			set { this._Tracer = value; }
		}

		/// <summary>
		/// If the word or phrase passed to this method is included in a SQL exception, that exception will be tolerated by the Stubborn SQL Runner.
		/// </summary>
		public void AddExceptionKey(string ExceptionKey)
		{
			this._aExceptionKeys.Add(ExceptionKey);
		}

		public void RemoveExceptionKey(string ExceptionKey)
		{
			this._aExceptionKeys.Remove(ExceptionKey);
		}

		private bool IsRetryable(Exception ex)
		{

			foreach (string Key in this._aExceptionKeys) {
				if (ex.Message.Contains(Key)) {
					return true;
				}
			}

			return false;

		}

		/// <summary>
		/// Executes a stubborn SQL statement that returns a scalar value.   Email notifications and trace entries will be created based on the property values provided.
		/// </summary>
		public object ExecuteScalar(DbCommand DBCommandObject)
		{

			int iRetryInterval = this._iRetryIntervalStart;
			int iCountFailures = 0;

			while (true) {
				try {
					return DBCommandObject.ExecuteScalar();
				} catch (Exception ex) {
					if (IsRetryable(ex)) {
						System.Threading.Thread.Sleep(new TimeSpan(0, 0, iRetryInterval));

						iCountFailures += 1;

						if (iCountFailures % _iRetryThreshold == 0) {
							// macbrown 10/13/2009: Removed SQL as it contained PHI.
							Email.SendMail("There have been " + iCountFailures + " attempts made to run this SQL [<Sql Omitted>] in SmartLinkRaw. " + "The service will continue to retry until it succeeds!  Please address this issue ASAP.", ex);
							this._Tracer.WriteError("A timeout/permission error has repeatedly occured while executing an interpreter SQL statement.  " + Environment.NewLine + ex.Message + Environment.NewLine + "This error has now occurred " + iCountFailures + " times and a notification email has been sent. ");
						}
					} else {
						throw;
					}
				}
			}
		}

		/// <summary>
		/// Executes a stubborn SQL statement that does not return a value.   Email notifications and trace entries will be created based on the property values provided.
		/// </summary>
		public int ExecuteNonQuery(DbCommand DBCommandObject)
		{
			int iRetryInterval = this._iRetryIntervalStart;
			int iCountFailures = 0;

			while (true) {
				try {
					return DBCommandObject.ExecuteNonQuery();
				} catch (Exception ex) {
					if (IsRetryable(ex)) {
						System.Threading.Thread.Sleep(new TimeSpan(0, 0, iRetryInterval));

						iCountFailures += 1;

						if (iCountFailures % _iRetryThreshold == 0) {
							Email.SendMail("There have been " + iCountFailures + " attempts made to run this SQL [" + DBCommandObject.CommandText + "] in SmartLinkRaw. " + "The service will continue to retry until it succeeds!  Please address this issue ASAP.", ex);
							this._Tracer.WriteError("A timeout/permission error has repeatedly occured while executing an interpreter SQL statement.  " + Environment.NewLine + ex.Message + Environment.NewLine + "This error has now occurred " + iCountFailures + " times and a notification email has been sent. ");

						}

					} else {
						throw;
					}
				}
			}
		}


		public Stubborn_SQL_Runner Clone()
		{
			Stubborn_SQL_Runner ClonedRunner = new Stubborn_SQL_Runner();
			Tracer ClonedTracer = new Tracer();

			ClonedRunner.RetryCount = this._iRetryThreshold;
			ClonedRunner.RetryIntervalStart = this._iRetryIntervalStart;
			ClonedRunner.RetryIntervalEnd = this._iRetryIntervalEnd;

			foreach (string ExceptionKey in this._aExceptionKeys) {
				ClonedRunner.AddExceptionKey(ExceptionKey);
			}

			if (this._Tracer != null) {
				ClonedTracer.ErrorFileName = this._Tracer.ErrorFileName;
				ClonedTracer.FileName = this._Tracer.FileName;
				ClonedTracer.TraceFlag = this._Tracer.TraceFlag;
			}

			return ClonedRunner;

		}


	}

}
