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
//  and implements the Daily Schedule
//*********************************************************************
namespace NRC.Miscellaneous.TaskScheduler
{
	public class DailyScheduler : Scheduler
	{


		protected override DateTime GetNextOccurrence(DateTime BaseDate)
		{
			DateTime functionReturnValue = default(DateTime);
			if (System.DateTime.Now.ToString("HH:mm:ss").CompareTo(this.Time) > 0) {
				functionReturnValue = System.DateTime.Parse(BaseDate.AddDays(this.Interval).ToString("MM/dd/yyyy") + " " + this.Time);
			} else {
				functionReturnValue = System.DateTime.Parse(BaseDate.ToString("MM/dd/yyyy") + " " + this.Time);
			}
			this._bFirstRun = false;
			return functionReturnValue;
		}

		public DailyScheduler() : base()
		{
		}

		public DailyScheduler(string Time) : base(Time)
		{
		}

		public DailyScheduler(int Interval, string StartDate, string Time, bool Enabled) : base(Interval, StartDate, Time, Enabled)
		{
		}

	}




}

