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
using WebSurveyLibrary;
using System.Timers;
using WebSurveyLibrary.Common;
using Quartz;
using Quartz.Impl;
using NullableDateTime = System.Nullable<System.DateTime>;
using Nrc.Framework.BusinessLogic.Configuration;
using NLog;
using System.Reflection;


namespace WebSurveyEmailService
{
    public partial class WebSurveyEmailService : ServiceBase
    {

        private EventLog eventLog;    
        private IScheduler _scheduler;


        public WebSurveyEmailService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
            string version = fvi.FileVersion;

            eventLog = new EventLog();
            eventLog.Source = "WebSurveyEmailService";
            eventLog.Log = "Application";

            Logs.Info(string.Format("WebSurveyEmailService v{0} Started", version));

            CreateSchedule();
            _scheduler.Start();

        }

        protected override void OnStop()
        {

            if (_scheduler != null)
            {
                _scheduler.Shutdown();
            }
            Logs.Info("WebSurveyEmailService Stopped");

        }


        private void CreateSchedule()
        {

            int cycleInterval = AppConfig.Params["WebSurveyServiceCycleTime"].IntegerValue;

            string cronExpCleanup = AppConfig.Params["WebSurveyCleanupInterval"].StringValue;

            string cronExpReport = AppConfig.Params["WebSurveySummaryReportInterval"] == null ? "0 0 0 1/1 * ? *" : AppConfig.Params["WebSurveySummaryReportInterval"].StringValue; // defaults to run at midnight if it can't find the QualPro_Param

            NameValueCollection properties = new NameValueCollection { { "quartz.threadPool.threadCount", "1" } };

            ISchedulerFactory schedulerFactory = new StdSchedulerFactory(properties);


            _scheduler = schedulerFactory.GetScheduler();

            // Create job detail for main DoWork call
            IJobDetail job = JobBuilder.Create<MyJob>()
                    .WithIdentity("main", "g1")
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

            //Create another trigger for the job
            ITrigger trigger2 = TriggerBuilder.Create()
            .WithIdentity("t2", "g2")
            .WithCronSchedule(cronExpCleanup)
            .Build();

            // add trigger to schedule
            _scheduler.ScheduleJob(cleanupJob,trigger2);


            // Create job detail for the summary report
            IJobDetail summaryReportJob = JobBuilder.Create<SummaryReportJob>()
                    .WithIdentity("summaryReport", "g3")
                    .Build();

            //Create another trigger for the job
            ITrigger trigger3 = TriggerBuilder.Create()
            .WithIdentity("t3", "g3")
            .WithCronSchedule(cronExpReport)
            .Build();

            // add trigger to schedule
            _scheduler.ScheduleJob(summaryReportJob, trigger3);

        }
    }

    [DisallowConcurrentExecution]
    internal class MyJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            try
            {
                // Do the scheduled work here.
                Logs.Info("WebSurveyEmailService Begin Email Processing");
                WebSurveyWorker.DoWork();
                Logs.Info("WebSurveyEmailService End Email Processing");
            }
            catch (JobExecutionException ex)
            {
                Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
            }

        }
    }

    [DisallowConcurrentExecution]
    internal class CleanUpJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            try
            {
                // Do the scheduled work here.
                Logs.Info("WebSurveyEmailService Begin Cleanup");
                WebSurveyWorker.DoCleanup();
                Logs.Info("WebSurveyEmailService End Cleanup");
            }
            catch (JobExecutionException ex)
            {
                Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
            }
        }
    }


    [DisallowConcurrentExecution]
    internal class SummaryReportJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            try
            {
                // Do the scheduled work here.
                Logs.Info("WebSurveyEmailService Begin Summary Report");
                WebSurveyWorker.DoSummaryReport();
                Logs.Info("WebSurveyEmailService End Summary Report");
            }
            catch (JobExecutionException ex)
            {
                Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
            }
        }
    }



}
