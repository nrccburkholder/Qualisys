﻿using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using Quartz;
using Quartz.Impl;
using System.Configuration;
using CEM.Exporting;
using CEM.Exporting.Configuration;
using NRC.Logging;


namespace CEM.FileMaker
{
    public partial class FileMakerService : ServiceBase
    {


        private EventLog eventLog;
        private IScheduler jobScheduler;
        private static string EventSource = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
        private static string EventClass = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.Name;

        public FileMakerService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {

            Assembly assembly = Assembly.GetExecutingAssembly();
            FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
            string version = fvi.FileVersion;

            eventLog = new EventLog();
            eventLog.Source = "CEM.FileMaker_Service";
            eventLog.Log = "Application";

            Logs.Info(string.Format("CEM.FileMakerService v{0} Started", version));

            CreateSchedule();
            jobScheduler.Start();

        }

        protected override void OnStop()
        {
            if (jobScheduler != null)
            {
                jobScheduler.Shutdown();
            }
            Logs.Info("CEM.FileMakerService Stopped");
        }

        private void CreateSchedule()
        {
            string schedulerCron = SystemParams.Params.GetParam("ServiceInterval").StringValue;

            NameValueCollection properties = new NameValueCollection { { "quartz.threadPool.threadCount", "1" } };
            ISchedulerFactory schedulerFactory = new StdSchedulerFactory(properties);

            //ISchedulerFactory schedulerFactory = new StdSchedulerFactory();

            jobScheduler = schedulerFactory.GetScheduler();

            // Create job detail for the making the files
            IJobDetail job = JobBuilder.Create<FileMakerJob>()
                    .WithIdentity("main", "g1")
                    .Build();

            // Create trigger
            ITrigger trigger = TriggerBuilder.Create()
            .WithIdentity("t1", "g1")
            .WithCronSchedule(schedulerCron)  // we don't have to use a cron expression.  If it is a consistent interval, could use something like the SimpleSchedule below
            .Build();



            //// Create trigger
            //ITrigger trigger = TriggerBuilder.Create()
            //.WithIdentity("t1", "g1")
            //.WithSimpleSchedule(x => x
            //    .WithIntervalInMinutes(1)
            //    .RepeatForever())
            //.Build();


            // Add job and trigger to schedule
            jobScheduler.ScheduleJob(job, trigger);

        }

        [DisallowConcurrentExecutionAttribute]
        internal class FileMakerJob : IJob
        {
            public void Execute(IJobExecutionContext context)
            {
                try
                {
                    // Do the scheduled work here.
                    Logs.Info("FileMakerService Begin Work");
                    Exporter.MakeFiles();
                    Logs.Info("FileMakerService End Work");
                }
                catch (JobExecutionException ex)
                {
                    Logs.Error("Error executing job.",ex);
                }

            }
        }
    }
}
