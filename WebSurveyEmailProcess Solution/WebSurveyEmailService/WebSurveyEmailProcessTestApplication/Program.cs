using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebSurveyLibrary;
using WebSurveyLibrary.Common;
using Quartz;
using Quartz.Impl;
using NullableDateTime = System.Nullable<System.DateTime>;
using Nrc.Framework.BusinessLogic.Configuration;
using System.Reflection;
using System.Diagnostics;

namespace WebSurveyEmailProcessTestApplication
{
    class Program
    {

        private static CronExpression _sched;
        private static DateTimeOffset _lastRunDateTime;
        private static DateTimeOffset _nextRunDateTime;

        private static IScheduler _scheduler;

        static void Main(string[] args)
        {
            //string chronExpression = AppConfig.Params["WebSurveyCleanupInterval"].StringValue;




            //_sched = new CronExpression(chronExpression); // triggered at 11 PM everyday
            ////_sched = new CronExpression("0 0 7 */3 * ?"); // triggered at 7 AM everyday
            //_lastRunDateTime = DateTime.UtcNow.AddDays(-1);

            Console.WriteLine("Exchange Web Services Test");
            Console.WriteLine();
            Console.WriteLine("Press ENTER to begin.");
            Console.ReadLine();
            //Start();
            TestSummaryReport();
            Console.WriteLine("End of Processing");
            Console.WriteLine("Press ENTER to exit.");
            Console.ReadLine();
            Console.WriteLine("Exiting application...");

            //Logs.Info("WebSurveyEmailService Stopped");
        }

        static void TestSummaryReport()
        {

            WebSurveyWorker.DoSummaryReport();

        }

        static void Start()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
            string version = fvi.FileVersion;

            Logs.Info(string.Format("WebSurveyEmailService v{0} Started", version));
            CreateSchedule();
            _scheduler.Start();
            //WebSurveyWorker.DoWork();

            //_nextRunDateTime = (DateTimeOffset)_sched.GetNextValidTimeAfter(_lastRunDateTime);

            //// clean up based on chronexpression schedule
            //if (DateTime.UtcNow > _nextRunDateTime)
            //{
            //    // call the cleanup routine
            //    WebSurveyWorker.DoCleanup();
            //    _lastRunDateTime = DateTime.UtcNow;
            //}
        }

        static void CreateSchedule()
        {

            int cycleInterval = AppConfig.Params["WebSurveyServiceCycleTime"].IntegerValue;

            string cronExpression = AppConfig.Params["WebSurveyCleanupInterval"].StringValue;

            NameValueCollection properties = new NameValueCollection { { "quartz.threadPool.threadCount", "1" } };

           // cronExpression = "0 /5 * * * ?"; 

            ISchedulerFactory schedulerFactory = new StdSchedulerFactory();

            _scheduler = schedulerFactory.GetScheduler();

            // Create job detail for main DoWork call
            IJobDetail job = JobBuilder.Create<WorkJob>()
                    .WithIdentity("work", "g1")
                    .Build();

            // Create trigger
            ITrigger trigger = TriggerBuilder.Create()
            .WithIdentity("t1", "g1")
            .WithSimpleSchedule(x => x
                .WithIntervalInMinutes(cycleInterval)
                .RepeatForever())
            .Build();

            // Add job and trigger to schedule
            _scheduler.ScheduleJob(job, trigger);


            // Create job detail for the mailbox folder cleanup 
            IJobDetail cleanupJob = JobBuilder.Create<CleanUpJob>()
                    .WithIdentity("cleanup", "g2")
                    .Build();

            //Create another trigger for the cleanup job
            ITrigger trigger2 = TriggerBuilder.Create()
            .WithIdentity("t2", "g2")
            .WithCronSchedule(cronExpression)
            .Build();

            // add trigger to schedule
            _scheduler.ScheduleJob(cleanupJob, trigger2);

        }

    }

    internal class WorkJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {

            try
            {

                // Do the scheduled work here.
                Logs.Info("Begin Work");
                WebSurveyWorker.DoWork();
                Logs.Info("End Work");
                Logs.Info("Work Next fire: " + context.NextFireTimeUtc.ToString());

            }
            catch (JobExecutionException ex)
            {

                Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());

            }

        }
    }

    internal class CleanUpJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {

            try
            {

                // Do the scheduled work here.
                Logs.Info("Begin Cleanup");
                WebSurveyWorker.DoCleanup();
                Logs.Info("End Cleanup");
                Logs.Info("Cleanup Next fire: " + context.NextFireTimeUtc.ToString());

            }
            catch (JobExecutionException ex)
            {

                Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());

            }

        }
    }

}
