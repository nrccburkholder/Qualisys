using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
//********************************************************************'
// Created by Elibad - 09/01/2007
//
//  This class inheriths the TaskScheduler functionality
//  and implements the Weekly Schedule
//*********************************************************************
namespace NRC.Miscellaneous.TaskScheduler
{
	public class WeeklyScheduler : Scheduler
	{

		private bool[] _bWeekdays = new bool[8];
		/// <summary>
		/// Sets the WeekDays using string format
		/// </summary>
		public string WeekDays {
			get {
				DayOfWeek Day = default(DayOfWeek);
				int iCount = 0;
				string Days = string.Empty;

				for (iCount = (int)DayOfWeek.Sunday; iCount <= (int)DayOfWeek.Saturday; iCount++) {
					if (_bWeekdays[iCount]) {
						Day = (DayOfWeek)System.Enum.Parse(typeof(DayOfWeek), iCount.ToString());
						Days = Days + Day.ToString() + ", ";
					}
				}

				return Days.Substring(0, Days.Length - 2);

			}
			set {
				if (value.ToUpper().Contains("SUNDAY")) {
					MarkWeekDay(DayOfWeek.Sunday, true);
				} else {
					MarkWeekDay(DayOfWeek.Sunday, false);
				}

				if (value.ToUpper().Contains("MONDAY")) {
					MarkWeekDay(DayOfWeek.Monday, true);
				} else {
					MarkWeekDay(DayOfWeek.Monday, false);
				}

				if (value.ToUpper().Contains("TUESDAY")) {
					MarkWeekDay(DayOfWeek.Tuesday, true);
				} else {
					MarkWeekDay(DayOfWeek.Tuesday, false);
				}

				if (value.ToUpper().Contains("WEDNESDAY")) {
					MarkWeekDay(DayOfWeek.Wednesday, true);
				} else {
					MarkWeekDay(DayOfWeek.Wednesday, false);
				}

				if (value.ToUpper().Contains("THURSDAY")) {
					MarkWeekDay(DayOfWeek.Thursday, true);
				} else {
					MarkWeekDay(DayOfWeek.Thursday, false);
				}

				if (value.ToUpper().Contains("FRIDAY")) {
					MarkWeekDay(DayOfWeek.Friday, true);
				} else {
					MarkWeekDay(DayOfWeek.Friday, false);
				}

				if (value.ToUpper().Contains("SATURDAY")) {
					MarkWeekDay(DayOfWeek.Saturday, true);
				} else {
					MarkWeekDay(DayOfWeek.Saturday, false);
				}
			}
		}

		protected override DateTime GetNextOccurrence(DateTime BaseDate)
		{
			int iAddDays = 0;
			int iCounter = 0;
			int iDay = 0;

			iAddDays = 0;

			iDay = (int)BaseDate.DayOfWeek;

			for (iCounter = 0; iCounter <= 6; iCounter++) {
				// If new week use interval to add the extra weeks
				if (iDay > 6) {
					iDay = 0;
					iAddDays = (this.Interval - 1) * 7;
				}

				if (_bWeekdays[iDay] & System.DateTime.Parse(BaseDate.AddDays(iAddDays + iCounter).ToString("MM/dd/yyyy") + " " + this.Time) > System.DateTime.Now) {
					break; // TODO: might not be correct. Was : Exit For
				}
				iDay = iDay + 1;
			}

			if (this._bFirstRun) {
				iAddDays = iCounter;
				this._bFirstRun = false;
			} else {
				iAddDays = iAddDays + iCounter;
			}

			return System.DateTime.Parse(BaseDate.AddDays(iAddDays).ToString("MM/dd/yyyy") + " " + this.Time);

		}

		/// <summary>
		/// Marks an specific day of the week to run schedule
		/// </summary>
		public void MarkWeekDay(DayOfWeek Day, bool Flag = true)
		{
			_bWeekdays[(int)Day] = Flag;
			if (this.Enabled) {
				this._bFirstRun = true;
				this.UpdateNextOccurrence();
			}
		}

		//Public Function GetWeekDayFlag(ByVal Day As Weekdays)
		//    GetWeekDayFlag = _bWeekdays(Day)
		//End Function

		public WeeklyScheduler() : base()
		{
		}



		public WeeklyScheduler(string Time) : base(Time)
		{
			int iCounter = 0;

			for (iCounter = 0; iCounter <= 7; iCounter++) {
				_bWeekdays[iCounter] = false;
			}
		}

		public WeeklyScheduler(int Interval, string StartDate, string Time, bool Enabled) : base(Interval, StartDate, Time, Enabled)
		{
		}

	}


}
