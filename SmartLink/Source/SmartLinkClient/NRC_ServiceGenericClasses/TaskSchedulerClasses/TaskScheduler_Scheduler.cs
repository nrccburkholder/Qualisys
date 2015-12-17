using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Diagnostics;
//********************************************************************'
// Created by Elibad - 09/01/2007
//
//  This class is the base class for the Task Schedulers
//  These Classes can schedule any type of task based 
//  on different interval types (Hourly, Daily, Weekly, etc)
//*********************************************************************

namespace NRC.Miscellaneous.TaskScheduler
{
	public abstract class Scheduler : IDisposable
	{

		private int _iInterval;
		private DateTime _dtLastRun;
		private DateTime _dtNextRun;
		private bool _bEnabled;
		private System.DateTime _dStartDate;
		private DateTime _dtTime;

		private System.Timers.Timer _tTimer = new System.Timers.Timer();
		protected bool disposed = false;

		protected bool _bFirstRun;
		/// <summary>
		/// Generates the Next Run Date
		/// </summary>
		protected abstract DateTime GetNextOccurrence(DateTime BaseDate);

		/// <summary>
		/// This Event gets Trigered when the schedule reaches the next run Date and time
		/// </summary>
		public event RunTaskEventHandler RunTask;
		public delegate void RunTaskEventHandler();

		/// <summary>
		/// Interval of recurrence
		/// </summary>
		/// <remarks>
		/// Examples:
		/// Interval = 2
		/// 
		/// If Recurrence Type = Daily then it will run every 2 Days
		/// If Recurrence Type = Weekly then it will run every 2 Weeks
		/// </remarks>
		public int Interval {
			get { return _iInterval; }
			set {
				if (value > 0) {
					_iInterval = value;
					if (this.Enabled) {
						this._bFirstRun = true;
						this.UpdateNextOccurrence();
					}
				} else {
					throw new System.Exception("Incorrect Interval value" + Environment.NewLine + Environment.NewLine + "Interval should be higher than 0");
				}
			}
		}

		/// <summary>
		/// Date to start schedule
		/// </summary>
		/// <value>Default value is Date.Now</value>
		public string StartDate {
			get { return _dStartDate.ToString("MM/dd/yyyy"); }
			set {
				try {
					_dStartDate = System.DateTime.Parse(value);
				} catch {
					throw new System.Exception("Incorrect Date" + Environment.NewLine + Environment.NewLine + "Please provide a date using mm/dd/yyyy format");
				}

				if (this.Enabled) {
					this.UpdateNextOccurrence();
				}
			}
		}

		/// <summary>
		/// Defines if the schedule is running
		/// </summary>
		public bool Enabled {
			get { return _bEnabled; }
			set {
				_bEnabled = value;
				_tTimer.Enabled = value;
				if (this.Enabled) {
					this._bFirstRun = true;
					this.UpdateNextOccurrence();
				}
			}
		}


		/// <summary>
		/// Time of the Day for Next recurrence
		/// </summary>
		public string Time {
			get { return _dtTime.ToString("HH:mm"); }
			set {
				try {
					_dtTime = DateTime.Parse(value);
				} catch  {
					throw new System.Exception("Incorrect Time" + Environment.NewLine + Environment.NewLine + "Please provide correct time value (24 hh:mm or hh:mm AM/PM)");
				}

				if (this.Enabled) {
					this._bFirstRun = true;
					this.UpdateNextOccurrence();
				}
			}
		}

		public Scheduler() : this("01:00:00")
		{
		}

		public Scheduler(string Time) : this(1, System.DateTime.Today.ToString("MM/dd/yyyy"), Time, false)
		{
		}

		public Scheduler(int Interval, string StartDate, string Time, bool Enabled)
		{
			//Initialize variables
			this.Interval = Interval;
			this.StartDate = StartDate;
			this.Time = Time;
			this._bEnabled = Enabled;
			this._bFirstRun = true;

			_dtLastRun = System.DateTime.Now;
			_dtNextRun = System.DateTime.Now.AddDays(3);

			//Initialize internal Timer
			_tTimer.Elapsed += VerifySchedule;

			// Set the timer interval to the number of minutes set in the app.config file
			_tTimer.Interval = new TimeSpan(0, 0, 10).TotalMilliseconds;

			_tTimer.AutoReset = false;

			// Turn on _tTimer
			_tTimer.Enabled = Enabled;
		}

		/// <summary>
		/// This Method is executed by the internal timer Tick event
		/// </summary>
		/// <remarks>This Method verifies wheter the Next run date has been reached</remarks>
		private void VerifySchedule(object sender, System.Timers.ElapsedEventArgs e)
		{
			if (DateAndTime.Now > _dtNextRun) {
				_dtLastRun = _dtNextRun;
				this.UpdateNextOccurrence();
				if (RunTask != null) {
					RunTask();
				}
			}
			_tTimer.Start();
		}

		/// <summary>
		/// This Method updates the Next Run Date and Time with the proper value
		/// </summary>
		protected void UpdateNextOccurrence()
		{
			if (_dtLastRun > _dStartDate) {
				_dtNextRun = GetNextOccurrence(_dtLastRun);
			} else if (_dStartDate > System.DateTime.Now) {
				_dtNextRun = GetNextOccurrence(_dStartDate);
			}
		}
		public void Start()
		{
			this.Enabled = true;
		}

		public void Stop()
		{
			this.Enabled = false;
		}

		/// <summary>
		/// This value determines how often the scheduler will verify that the next scheduled run has been reached
		/// </summary>
		/// <value>Default = 30 Seconds</value>
		public int ScheduleCheckInterval {
			get { return Convert.ToInt32(_tTimer.Interval / 1000); }
			set {
				if (value > 0) {
					_tTimer.Interval = value * 1000;
				}
			}
		}

		#region "IDisposable support"
		protected virtual void dispose(bool disposing)
		{
			if (!this.disposed) {

				if (disposing) {
				}
				//SaveRunDates()
			}
			this.disposed = true;
		}

		public void Dispose()
		{
			dispose(true);
			GC.SuppressFinalize(this);
		}

        //protected override void Finalize()
        //{
        //    dispose(false);
        //    base.Finalize();
        //}

		/// <summary>
		/// Gets the Date and Time for Next Run
		/// </summary>
		public string NextRun {
			get {
				string functionReturnValue = null;
				functionReturnValue = _dtNextRun.ToString("MM/dd/yyyy HH:mm");
				if (this.Enabled == false) {
					functionReturnValue = "Scheduler is Disabled";
				}
				return functionReturnValue;
			}
		}

		#endregion

	}

	//Public MustInherit Class NRC_Scheduler
}
