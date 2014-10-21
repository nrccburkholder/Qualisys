using System;
using System.Configuration;
using System.IO;
using System.Messaging;
using System.Text;
using Nrc.CatalystExporter.DataAccess;
using Nrc.CatalystExporter.DataContracts;
using Nrc.CatalystExporter.Logging;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;

namespace ScheduledClient
{
    public class Program
    {
        static void Main(string[] args)
        {
            var scheduleAccess = new ScheduledExportAccess();
            var logAccess = new ExportLogAccess();
            var catalystAccess = new CatalystDatamartAccess();
            var user = new UserContext("ScheduledClient");

            var exports = scheduleAccess.FindManyByDay_IncludeColumns(user);

            foreach (var export in exports)
            {
                user = new UserContext(export.CreatedBy);

                var surv = catalystAccess.FindBySurveyId_ClientStudySurvey(export.FileDefinitions.FirstOrDefault().SurveyId, user);

                DateTime start = export.DataStartDate;
                DateTime end = new DateTime();

                switch (export.DataInterval)
                {
                    case (int)IntervalType.Weeks:
                        end = start.AddDays(7 * export.DataIntervalCount);
                        break;
                    case (int)IntervalType.Months:
                        end = start.AddMonths(export.DataIntervalCount).AddDays(-1);
                        break;
                    case (int)IntervalType.Years:
                        end = start.AddYears(export.DataIntervalCount).AddDays(-1);
                        break;
                }

                var loc = GetFileLocation(export.CreatedBy, surv, export.FileDefinitions.FirstOrDefault().Name, (FileType)export.FileDefinitions.FirstOrDefault().FileType, export.FileDefinitions.Count > 1);

                var newLog = new ExportLog()
                {
                    CreatedBy = user.UserName,
                    CreationDate = DateTime.Now,
                    Name = export.FileDefinitions.FirstOrDefault().Name,
                    StartDate = start,
                    EndDate = end,
                    Location = loc
                };

                newLog.FileDefinitions = new List<FileDefinition>();

                newLog.FileDefinitions.AddRange(export.FileDefinitions);

                logAccess.Save(newLog, user);

                AddToQueue(newLog.Id);

                Logger.Log(string.Format("New Export Log Queued by Scheduler \r\n{0}", newLog.ExportLogToString()), System.Diagnostics.TraceEventType.Information, user);

                //update NextRunDate DataStartDate
                switch (export.RunInterval)
                {
                    case (int)IntervalType.Weeks:
                        export.NextRunDate = export.NextRunDate.AddDays(7 * export.RunIntervalCount);
                        if (export.IsRolling) //Move by run interval froward (do not jump by data interval becuase if datainteval > runinterval, then we would eventually only run future dates)
                            export.DataStartDate = export.DataStartDate.AddDays(7 * export.RunIntervalCount);
                        break;
                    case (int)IntervalType.Months:
                        export.NextRunDate = export.NextRunDate.AddMonths(export.RunIntervalCount);
                        if (export.IsRolling)//Move by run interval froward (do not jump by data interval becuase if datainteval > runinterval, then we would eventually only run future dates)
                            export.DataStartDate = export.DataStartDate.AddMonths(export.RunIntervalCount);
                        break;
                    case (int)IntervalType.Years:
                        export.NextRunDate = export.NextRunDate.AddYears(export.RunIntervalCount);
                        if (export.IsRolling)//Move by run interval froward (do not jump by data interval becuase if datainteval > runinterval, then we would eventually only run future dates)
                            export.DataStartDate = export.DataStartDate.AddYears(export.RunIntervalCount);
                        break;
                }

                scheduleAccess.Save(export, user);

                Logger.Log(string.Format("Scheduled Export Edited by Scheduler \r\n{0}", export.ScheduledExportToString()), System.Diagnostics.TraceEventType.Information, user);
            }
        }

        private static string GetFileLocation(string username, ClientStudySurvey survey, string fileName, FileType type, bool multipleSurveys)
        {
            string regexSearch = new string(Path.GetInvalidFileNameChars()) + new string(Path.GetInvalidPathChars());
            System.Text.RegularExpressions.Regex r = new System.Text.RegularExpressions.Regex(string.Format("[{0}]", System.Text.RegularExpressions.Regex.Escape(regexSearch)));

            var _userSettingsAccess = new UserSettingsAccess();
            StringBuilder sb = new StringBuilder();

            var usersetting = _userSettingsAccess.Find(username, new UserContext(username));
            if (usersetting != null && !string.IsNullOrWhiteSpace(usersetting.NetworkLocation))
                sb.Append(usersetting.NetworkLocation);
            else
                sb.Append(ConfigurationManager.AppSettings[username]
                     ?? ConfigurationManager.AppSettings["DefaultLocation"]);//User folder

            if (!sb.ToString().EndsWith("\\"))
                sb.Append("\\");

            sb.Append(r.Replace(survey.ClientName, ""));//Client folder
            sb.Append("\\");
            if (!multipleSurveys)
            {
                sb.Append(r.Replace(survey.StudyName, ""));//Study Folder
                sb.Append("\\");
            }
            sb.Append(r.Replace(fileName, ""));
            sb.Append("-");
            if (!multipleSurveys)
            {
                sb.Append(r.Replace(survey.SurveyName, ""));
                sb.Append("-");
            }
            sb.Append(DateTime.Now.ToString("yyyyMMddhhmmss"));
            sb.Append(".");
            if (type != FileType.Other_Delimiter)
                sb.Append(type.ToString().ToLower());
            else
                sb.Append("txt");

            return sb.Replace(' ', '_').ToString();

        }

        private static void AddToQueue(long exportLogId)
        {
            try
            {
                string queueName = System.Configuration.ConfigurationManager.AppSettings["Queue"];

                if (string.IsNullOrEmpty(queueName))
                    throw new ArgumentNullException("Queue");

                if (MessageQueue.Exists(queueName))
                {
                    using (MessageQueue queue = new MessageQueue(queueName))
                    {
                        queue.Formatter = new System.Messaging.XmlMessageFormatter(new Type[1] { typeof(long) });
                        using (Message m = new Message(exportLogId))
                        {
                            queue.Send(m);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Log(ex, new UserContext("ScheduledClient"));
            }
        }
    }
}
