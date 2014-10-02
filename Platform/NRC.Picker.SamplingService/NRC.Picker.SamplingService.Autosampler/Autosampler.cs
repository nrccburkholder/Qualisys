using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

using NRC.Common;
using NRC.Common.Configuration;
using NRC.Common.Service;

using NRC.Picker.SamplingService.Mailer;
using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

namespace NRC.Picker.SamplingService.Autosampler
{
    public class AutosamplerService : FancyServiceBase
    {
        private static readonly Logger _logger;
        private static readonly Configuration _config;

        static AutosamplerService()
        {
            try
            {
                _logger = Logger.GetLogger("autosampler");
            }
            catch
            {
                _logger = Logger.GetLogger();
            }
            _config = ConfigManager.Load<Configuration>();
        }

        class ThreadPair
        {
            public Dataset Dataset { get; private set; }
            public Thread Thread { get; private set; }
            public ThreadPair(Dataset dataset, Thread thread)
            {
                Dataset = dataset;
                Thread = thread;
            }
        }

        private readonly List<ThreadPair> _threadPairs;
        private IEnumerable<Thread> StartedThreads
        {
            get
            {
                return _threadPairs.Select(p => p.Thread)
                                   .Where(t => t.ThreadState == ThreadState.Running);
            }
        }

        public override string InternalName { get { return "Autosampler"; } }
        public override string DisplayName { get { return "NRC Sampling Service Autosampler"; } }

        public AutosamplerService()
        {
            _threadPairs = new List<ThreadPair>();
        }

        public static void Main(string[] args)
        {
            FancyServiceRunner.ServiceMain(new AutosamplerService(), args);
        }

        protected override void RunOnce()
        {
            _logger.Info("Started Autosampler");
            while (!_stop)
            {
                Dataset dataset = Dataset.GetNextDataset(_config.SampleCountThreshold);
                if (dataset != null)
                {
                    _threadPairs.Add(new ThreadPair(dataset, new Thread(() => SampleDataset(dataset))));
                    _logger.Info(String.Format("dataset ({0}) selected for sampling", dataset.ID));
                }

                GroomThreads();

                foreach (ThreadPair p in _threadPairs.Where(p => p.Thread.ThreadState == ThreadState.Unstarted)
                                                     .TakeWhile(p => StartedThreads.Count() <= _config.AutosamplerThreads))
                {
                    p.Thread.Start();
                    _logger.Info((String.Format("dataset ({0}) began sampling", p.Dataset.ID)));
                }

                Thread.Sleep(1000);
            }
            _logger.Info("Ended Autosampler");
        }

        private void GroomThreads()
        {
            foreach (ThreadPair p in _threadPairs.Where(p => p.Thread.ThreadState == ThreadState.Stopped).ToList())
            {
                _threadPairs.Remove(p);
            }
        }

        public static void SampleDataset(Dataset dataset)
        {
            try
            {
                dataset.Sample(_config.EnableScheduling);
                _logger.Info((String.Format("dataset ({0}) completed sampling", dataset.ID)));
                ReportMailer.SendOutputReport(dataset, _config.MailerUrl);
            }
            catch (Exception exception)
            {
                try
                {
                    _logger.Info(String.Format("dataset ({0}) sampling failed", dataset.ID));
                    _logger.Error(String.Format("dataset ({0}) encountered a fatal error", dataset.ID), exception);
                    ReportMailer.SendAbortReport(dataset, _config.MailerUrl, exception);
                }
                catch (Exception e)
                {
                    _logger.Error(String.Format("dataset ({0}) encountered a fatal error during fatal error cleanup", dataset.ID), e);
                }
            }
        }

        public override void StopRequested()
        {
            foreach (Dataset dataset in _threadPairs.Where(p => p.Thread.ThreadState == ThreadState.Unstarted)
                                                    .Select(p => p.Dataset))
            {
                dataset.Release();
                _logger.Info((String.Format("dataset ({0}) released, unsampled", dataset.ID)));
            }

            foreach (Dataset dataset in _threadPairs.Select(p => p.Dataset))
            {
                dataset.Stop = true;
            }

            while (_threadPairs.Count != 0)
            {
                GroomThreads();
            }
        }
    }
}