using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.Common;
using NRCFileConverterLibrary.Factory;
using NRCFileConverterLibrary.Providers;
using NRC = NRCFileConverterLibrary.Common;
using NLog;

namespace NRCFileConverterLibrary.Processor
{
    public delegate void OnClientNotify(object obj, LogTraceArgs args);
    public class Processor
    {
        /// <summary>
        /// This event is raised once the process is started.
        /// </summary>
        public event EventHandler BeginProcess;
        /// <summary>
        /// This event is raised once the work is done.
        /// </summary>
        public event EventHandler EndProcess;

        /// <summary>
        /// log/trace utilities subscribe to this event. The processor will notify when a log or a trace needs to be written.
        /// </summary>
        public event EventHandler<LogTraceArgs> LogTraceListeners;

        /// <summary>
        /// This function initiates processing by creating providers.
        /// </summary>
        public void Process()
        {
            NotifyLogTraceListeners("Started Processing", NRC.LogLevel.Info);
            //Fire the BeginProcess event.
            if (null != BeginProcess)
                BeginProcess(this, new EventArgs());

            foreach (var ProviderRuleConfig in GetRulesConfiguration())
            {
                try
                {
                    var provider = ProviderFactory.Create(ProviderRuleConfig);
                    provider.LogTraceListeners += provider_LogTraceListeners;
                    provider.OnBeginConversion += provider_BeginConversion;
                    provider.Convert();

                }
                catch (NRCFileConversionException ex)
                {
                    NotifyLogTraceListeners(ex.ToString(), NRC.LogLevel.Error);
                }
                catch (Exception ex)
                {
                    NotifyLogTraceListeners(ex.ToString(), NRC.LogLevel.Fatal);
                }

            }
            //Fire the EndProcess event.
            if (null != EndProcess)
                EndProcess(this, new EventArgs());
        }

        private void provider_LogTraceListeners(object sender, LogTraceArgs e)
        {
            if (LogTraceListeners != null)
            {
                LogTraceListeners(this, e);
            }
        }

        private void NotifyLogTraceListeners(string msg, NRC.LogLevel logLevel)
        {
            var args = new LogTraceArgs { Message = Logs.FormatMessage(msg), LogLevel = logLevel };
            Logs.Info(args.Message);

            if (LogTraceListeners != null)
            {
                LogTraceListeners(this, args);
            }
        }

        void provider_BeginConversion(object sender, EventArgs e)
        {
            NotifyLogTraceListeners(sender.GetType() + " Started", NRC.LogLevel.Info);
        }

        private static List<RuleConfigurationItem> GetRulesConfiguration()
        {
            List<RuleConfigurationItem> rulesConfig = (List<RuleConfigurationItem>)ConfigurationManager.GetSection("RuleConfigurations");
            return rulesConfig;
        }

    }
}
