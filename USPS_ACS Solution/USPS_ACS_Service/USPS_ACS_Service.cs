using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using Quartz;
using Quartz.Impl;
using Nrc.Framework.BusinessLogic.Configuration;
using USPS_ACS_Library;
using ServiceLogging;

namespace USPS_ACS_Service
{
    public partial class USPS_ACS_Service : ServiceBase
    {
        private EventLog eventLog;
        private IScheduler _scheduler;

        public USPS_ACS_Service()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            eventLog = new EventLog();
            eventLog.Source = "USPS_ACS_Service";
            eventLog.Log = "Application";

            Logs.Info("USPS_ACS_Service Started");

            CreateSchedule();
            _scheduler.Start();
        }


        protected override void OnStop()
        {
            if (_scheduler != null)
            {
                _scheduler.Shutdown();
            }
            Logs.Info("USPS_ACS_Service Stopped");
        }


        private void CreateSchedule()
        {
            try { 

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

    }
}
