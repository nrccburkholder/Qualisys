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
using ServiceLogging;
using System.Reflection;
using Quartz;
using Quartz.Impl;
using System.Configuration;

namespace CEM.FileMaker
{
    public partial class FileMakerService : ServiceBase
    {
        private EventLog eventLog;
        private IScheduler _scheduler;

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
            eventLog.Source = "FileMakerService";
            eventLog.Log = "Application";

            Logs.Info(string.Format("FileMakerService v{0} Started", version));

            CreateSchedule();
            _scheduler.Start();

        }

        protected override void OnStop()
        {
            if (_scheduler != null)
            {
                _scheduler.Shutdown();
            }
            Logs.Info("FileMakerService Stopped");
        }

        private void CreateSchedule()
        {
            string schedulerCron = ConfigurationManager.AppSettings["SchedulerCron"].ToString();

            NameValueCollection properties = new NameValueCollection { { "quartz.threadPool.threadCount", "1" } };

            ISchedulerFactory schedulerFactory = new StdSchedulerFactory(properties);

            _scheduler = schedulerFactory.GetScheduler();

            // Create job detail for the making the files
            IJobDetail job = JobBuilder.Create<FileMakerJob>()
                    .WithIdentity("main", "g1")
                    .Build();

            // Create trigger
            ITrigger trigger1 = TriggerBuilder.Create()
            .WithIdentity("t1", "g1")
            .WithCronSchedule(schedulerCron)
            .Build();

            // Add job and trigger to schedule
            _scheduler.ScheduleJob(job, trigger1);
        }

        internal class FileMakerJob : IJob
        {
            public void Execute(IJobExecutionContext context)
            {
                try
                {
                    // Do the scheduled work here.
                    Logs.Info("FileMakerService Begin Work");
                    NRC.Exporting.FileMakerServiceWorker.Run();
                    Logs.Info("FileMakerService End Work");
                }
                catch (JobExecutionException ex)
                {
                    Logs.Info("Quartz: Error executing job - " + ex.Message + ' ' + DateTime.UtcNow.ToString());
                }

            }
        }
    }
}
