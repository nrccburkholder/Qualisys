using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRC.Common.Configuration;

namespace NRC.Platform.FileCopyService
{
    public class IntervalManager : ConfigSection
    {
        [ConfigUse("Delay", IsOptional = true, Default = "null")]
        public DelayInterval delay;

        [ConfigUse("Daily", IsOptional = true, Default = "null")]
        public DailyInterval daily;

        [ConfigUse("Weekly", IsOptional = true, Default = "null")]
        public WeeklyInterval weekly;

        [ConfigUse("Monthly", IsOptional = true, Default = "null")]
        public MonthlyInterval monthly;
        
        public IInterval Which()
        {
            //If you need to add a new implementation of IInterval, add it to 'all' here
            IInterval[] all = { delay, daily, weekly, monthly };
            if (all.Where(t => t != null).Count() != 1)
            {
                throw new ConfigException("Must specify exactly 1 Interval");
            }
            return all.Where(t => t != null).First();
        }
    }

    public interface IInterval
    {
        bool ShouldRun(DateTime lastRun, DateTime now);
    }

    public class DelayInterval : ConfigSection, IInterval
    {
        [ConfigUse("Seconds")]
        public int seconds;

        public bool ShouldRun(DateTime lastRun, DateTime now)
        {
            TimeSpan diff = now - lastRun;
            return diff.TotalSeconds >= seconds;
        }
    }

    public class DailyInterval : ConfigSection, IInterval
    {
        [ConfigUse("Hour")]
        public int hour;

        [ConfigUse("Minute")]
        public int minute;

        public bool ShouldRun(DateTime lastRun, DateTime now)
        {
            DateTime when = new DateTime(now.Year, now.Month, now.Day, hour, minute, 0);
            TimeSpan diff = now - when;
            // return true if we are past when we should run, but lastRun hasn't happened since then
            return now >= when && lastRun < when;
        }
    }

    public class WeeklyInterval : ConfigSection, IInterval
    {
        [ConfigUse("DayOfWeek")]
        public string dayOfWeek;

        [ConfigUse("Hour")]
        public int hour;

        [ConfigUse("Minute")]
        public int minute;

        public bool ShouldRun(DateTime lastRun, DateTime now)
        {
            DateTime nextRun = new DateTime(now.Year, now.Month, now.Day, hour, minute, 0);
            TimeSpan diff = now - nextRun;
            // return true if we are past when we should run, but lastRun hasn't happened since then
            //   and dayOfWeek matches
            return now >= nextRun && lastRun < nextRun && now.ToString("dddd").ToLower() == dayOfWeek.ToLower();
        }
    }

    public class MonthlyInterval : ConfigSection, IInterval
    {
        [ConfigUse("DayOfMonth")]
        public int dayOfMonth;

        [ConfigUse("Hour")]
        public int hour;

        [ConfigUse("Minute")]
        public int minute;

        public bool ShouldRun(DateTime lastRun, DateTime now)
        {
            DateTime when = new DateTime(now.Year, now.Month, now.Day, hour, minute, 0);
            TimeSpan diff = now - when;
            // return true if we are past when we should run, but lastRun hasn't happened since then
            //   and dayOfMonth matches
            return now >= when && lastRun < when && now.Day == dayOfMonth;
        }
    }
}
