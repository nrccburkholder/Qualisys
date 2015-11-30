using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceLogging;
using USPS_ACS_Library;
using Quartz;
using Quartz.Impl;
using Nrc.Framework.BusinessLogic.Configuration;
using ServiceLogging;
using System.Diagnostics;

namespace ServiceTester_Console
{
    class Program
    {
        private EventLog eventLog;
        private static IScheduler _scheduler;

        static void Main(string[] args)
        {
            Console.WriteLine();
            Console.WriteLine(string.Format("Environment: {0}", GetEnvironment()));
            Console.WriteLine();
            Console.WriteLine("Press return to start");
            Console.ReadLine();

            Start();

            Console.WriteLine("Press return to exit");
            Console.ReadLine();

            Stop();
        }

        static void Start()
        {

            Logs.Info("USPS_ACS_Service Begin Work");

            //USPS_ACS_Library.ServiceWorker.DoDownloadWork();
            USPS_ACS_Library.ServiceWorker.DoExtractWork();

            //CreateSchedule();
            //_scheduler.Start();
            Logs.Info("USPS_ACS_Service End Work");

        }


        static void Stop()
        {

            if (_scheduler != null)
            {
                _scheduler.Shutdown();
            }

            Logs.Info("USPS_ACS_Service Stopped");
        }


        private static void CreateSchedule()
        {
            try
            {

                string downloadCron = AppConfig.Params["USPS_ACS_ServiceDownloadInterval"].StringValue;
                string extractCron = AppConfig.Params["USPS_ACS_ServiceExtractInterval"].StringValue;

                NameValueCollection properties = new NameValueCollection { { "quartz.threadPool.threadCount", "1" } };

                ISchedulerFactory schedulerFactory = new StdSchedulerFactory(properties);

                _scheduler = schedulerFactory.GetScheduler();

                // Create job detail for the file downloads from USPS
                IJobDetail job = JobBuilder.Create<DownloadJob>()
                        .WithIdentity("main", "g1")
                        .Build();

                // Create trigger
                ITrigger trigger1 = TriggerBuilder.Create()
                .WithIdentity("t1", "g1")
                .WithCronSchedule(downloadCron)
                .Build();

                // Add job and trigger to schedule
                _scheduler.ScheduleJob(job, trigger1);



                // Create job detail for processing the extracted files  
                IJobDetail extractJob = JobBuilder.Create<ExtractJob>()
                        .WithIdentity("cleanup", "g2")
                        .Build();

                //Create another trigger for the job
                ITrigger trigger2 = TriggerBuilder.Create()
                .WithIdentity("t2", "g2")
                .WithCronSchedule(extractCron)
                .Build();

                // add trigger to schedule
                _scheduler.ScheduleJob(extractJob, trigger2);

            }
            catch (Exception ex)
            {
                Logs.LogException("Error in CreateScheduler", ex);
            }
        }

        internal class DownloadJob : IJob
        {
            public void Execute(IJobExecutionContext context)
            {
                try
                {
                    // Do the scheduled work here.
                    Logs.Info("USPS_ACS_Service Begin Work");
                    USPS_ACS_Library.ServiceWorker.DoDownloadWork();
                    Logs.Info("USPS_ACS_Service End Work");
                }
                catch (JobExecutionException ex)
                {
                    Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
                }

            }
        }

        internal class ExtractJob : IJob
        {
            public void Execute(IJobExecutionContext context)
            {
                try
                {
                    // Do the scheduled work here.
                    Logs.Info("USPS_ACS_Service Begin Work");
                    USPS_ACS_Library.ServiceWorker.DoExtractWork();
                    Logs.Info("USPS_ACS_Service End Work");
                }
                catch (JobExecutionException ex)
                {
                    Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
                }

            }
        }


        static string GetEnvironment()
        {
            string env = "Unknown";
            switch (AppConfig.EnvironmentType)
            {
                case EnvironmentTypes.Production:
                    env = "Prod";
                    break;
                case EnvironmentTypes.Staging:
                    env = "Stage";
                    break;
                case EnvironmentTypes.Testing:
                    env = "Test";
                    break;
                default:
                    break;
            }

            return env;

        }
    }
}
