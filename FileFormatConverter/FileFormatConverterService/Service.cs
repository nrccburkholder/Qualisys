using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using NRCFileConverterLibrary.Common;
using System.Configuration;
using NRCFileConverterLibrary.Processor;

namespace FileFormatConverterService
{
    public partial class Service : ServiceBase
    {
        private System.Timers.Timer timerFileConverter;
        
        public Service()
        {
            InitializeComponent();
            timerFileConverter = new System.Timers.Timer();
        }

        protected override void OnStart(string[] args)
        {
            Logs.Info("NRCFileConverter Started");

            int mseconds;
            timerFileConverter.Elapsed += timerFileConverter_Elapsed;
            if (!int.TryParse(ConfigurationManager.AppSettings["TimerInterval"], out mseconds))
            {
                mseconds = 180000;//set it to 3 minutes                
                Logs.Warn("AppSetting ' TimerInterval' is either missing or not an integer.");
            }
            timerFileConverter.Interval = mseconds;
            timerFileConverter.Start();
        }

        void timerFileConverter_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            Logs.Info("NRCFileConverter Timer Elapsed");
            timerFileConverter.Stop();

            var processor = new Processor();
            processor.LogTraceListeners += processor_LogTraceListeners;
            processor.Process();
            timerFileConverter.Start();
        }

        protected override void OnStop()
        {
            Logs.Info("NRCFileConverter Stopped");
            timerFileConverter.Stop();
            timerFileConverter.Elapsed -= timerFileConverter_Elapsed;
        }

        void processor_LogTraceListeners(object sender, LogTraceArgs e)
        {
            if (Environment.UserInteractive)
            {
                Console.WriteLine(e.Message);
            }
        }

        internal void Start()
        {
            OnStart(null);
        }
    }
}
