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
//  and implements the Monthly Schedule
//*********************************************************************
namespace NRC.Miscellaneous.TaskScheduler
{
	public class QuarterlyScheduler : Scheduler
	{

		private int _iDayOfMonth = 1;
		public int DayofMonth {
			get { return _iDayOfMonth; }
			set {
				if (value <= 31) {
					_iDayOfMonth = value;
				} else {
					throw new System.Exception("Invalid Day of Month. This value can not be higher than 31");
				}

			}
		}

		public QuarterlyScheduler() : base()
		{
		}

		public QuarterlyScheduler(string Time) : base(Time)
		{
		}

		public QuarterlyScheduler(int Interval, string StartDate, string Time, bool Enabled) : base(Interval, StartDate, Time, Enabled)
		{
		}

		protected override DateTime GetNextOccurrence(DateTime BaseDate)
		{
			int iInterval = 1;
			int MaxDays = 0;
			int iaddMonths = 1;
			int iModMonth = 0;
			DateTime dTestCheck = default(DateTime);

			//Do While BaseDate.AddDays(iInterval).Day <> _iDayOfMonth
			//    iInterval += 1
			//Loop

			if (BaseDate > DateTime.Now) {
				dTestCheck = BaseDate;
			} else {
				dTestCheck = DateTime.Now;
			}

			//iModMonth = (BaseDate.AddDays(iInterval).Month - 1) Mod 3
			iModMonth = (BaseDate.Month - 1) % 3;

			if (iModMonth != 0 || 
                    (iModMonth == 0 && (_iDayOfMonth <= dTestCheck.Day & Time.CompareTo(dTestCheck.ToString("HH:mm")) <= 0))) {
				iaddMonths = 3 - iModMonth;
			} else {
				iaddMonths = 0;
			}

			MaxDays = System.DateTime.DaysInMonth(BaseDate.AddDays(iInterval).Year, BaseDate.AddDays(iInterval).Month);

			if (_iDayOfMonth >= MaxDays) {
				return System.DateTime.Parse(BaseDate.AddMonths(iaddMonths).ToString("MM/") + MaxDays.ToString() + BaseDate.AddMonths(iaddMonths).ToString("/yyyy ") + this.Time);
			} else {
				return System.DateTime.Parse(BaseDate.AddMonths(iaddMonths).ToString("MM/") + _iDayOfMonth.ToString() + BaseDate.AddMonths(iaddMonths).ToString("/yyyy ") + this.Time);
				//Return Date.Parse(BaseDate.AddMonths(iaddMonths).AddDays(iInterval).ToString("MM/dd/yyyy") & " " & Me.Time)
			}
		}
	}
}
