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
	public class MonthlyScheduler : Scheduler
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

		public MonthlyScheduler() : base()
		{
		}

		public MonthlyScheduler(string Time) : base(Time)
		{
		}

		public MonthlyScheduler(int Interval, string StartDate, string Time, bool Enabled) : base(Interval, StartDate, Time, Enabled)
		{
		}

		protected override DateTime GetNextOccurrence(DateTime BaseDate)
		{
			int iInterval = 1;
			int MaxDays = 0;

			MaxDays = System.DateTime.DaysInMonth(BaseDate.AddDays(iInterval).Year, BaseDate.AddDays(iInterval).Month);

			if (_iDayOfMonth >= MaxDays) {
				return System.DateTime.Parse(BaseDate.AddDays(iInterval).ToString("MM/") + MaxDays.ToString() + BaseDate.AddDays(iInterval).ToString("/yyyy ") + this.Time);
			}

			while (BaseDate.AddDays(iInterval).Day != _iDayOfMonth) {
				iInterval += 1;
			}

			return System.DateTime.Parse(BaseDate.AddDays(iInterval).ToString("MM/dd/yyyy") + " " + this.Time);
		}
	}
}
