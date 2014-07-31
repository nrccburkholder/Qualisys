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

            eventLog = new EventLog();
            eventLog.Source = "WebSurveyEmailService";
            eventLog.Log = "Application";

            Logs.Info("WebSurveyEmailService Started");

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

            string cronExpression = AppConfig.Params["WebSurveyCleanupInterval"].StringValue;

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
            .WithCronSchedule(cronExpression)
            .Build();

            // add trigger to schedule
            _scheduler.ScheduleJob(cleanupJob,trigger2);

        }
    }

    internal class MyJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            try
            {
                // Do the scheduled work here.
                Logs.Info("WebSurveyEmailService Begin Work");
                try
                {
                    WebSurveyWorker.DoWork();
                }catch (Exception ex1)
                {
                    Logs.Info("DoWork: Error executing  - " + ex1.Message + ' ' + DateTime.UtcNow.ToString());
                }
                
                Logs.Info("WebSurveyEmailService End Work");
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

    
}
