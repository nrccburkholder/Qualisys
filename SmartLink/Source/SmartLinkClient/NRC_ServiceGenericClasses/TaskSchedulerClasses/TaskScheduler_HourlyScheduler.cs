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
//  and implements the Hourly Schedule
//*********************************************************************
namespace NRC.Miscellaneous.TaskScheduler
{
	public class HourlyScheduler : Scheduler
	{

		public HourlyScheduler() : base(1, System.DateTime.Now.ToString(), System.DateTime.Now.ToString(), false)
		{
		}

		public HourlyScheduler(int Interval, string StartDate, string Time, bool Enabled) : base(Interval, StartDate, Time, Enabled)
		{
		}

		protected override System.DateTime GetNextOccurrence(System.DateTime BaseDate)
		{
			System.DateTime functionReturnValue = default(System.DateTime);
			if (this._bFirstRun) {
				System.DateTime dResult = System.DateTime.Parse(BaseDate.ToString("MM/dd/yyyy") + " " + this.Time);
				if (this.Time.CompareTo(System.DateTime.Now.ToString("HH:mm:ss")) < 0) {
					if (dResult.ToString("mm").CompareTo(System.DateTime.Now.ToString("mm")) <= 0) {
						dResult = DateTime.Parse(dResult.ToString("MM/dd/yyyy ") + System.DateTime.Now.AddHours(1).ToString("HH:") + dResult.ToString("mm:ss"));
					} else {
						dResult = DateTime.Parse(dResult.ToString("MM/dd/yyyy ") + System.DateTime.Now.ToString("HH:") + dResult.ToString("mm:ss"));
					}
				}
				functionReturnValue = dResult;
			} else {
				functionReturnValue = BaseDate.AddHours(this.Interval);
			}
			this._bFirstRun = false;
			return functionReturnValue;
		}

	}

}
