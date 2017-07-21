using System.Threading;
using System.Linq;

using NRC.Common;
using NRC.Common.Configuration;
using NRC.Common.Service;

using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

namespace NRC.Picker.SamplingService.QueueService
{
    public class QueueService : FancyServiceBase
    {
        private static readonly Logger _logger;
        private static readonly Configuration _config;

        public override string InternalName { get { return "QueueService"; } }
        public override string DisplayName { get { return "NRC Sampling Service QueueService"; } }

        static QueueService()
        {
            try
            {
                _logger = Logger.GetLogger("queueservice");
            }
            catch
            {
                _logger = Logger.GetLogger();
            }
            _config = ConfigManager.Load<Configuration>();
        }

        public static void Main(string[] args)
        {
            FancyServiceRunner.ServiceMain(new QueueService(), args);
        }

        protected override void RunOnce()
        {
            _logger.Info("Started QueueService");
            while (!_stop)
            {
                _logger.Info("Checking for work");
                DoWork();
                Thread.Sleep(_config.RunInterval);
            }
            _logger.Info("Ended QueueService");
        }

        public static void DoWork()
        {
            Dataset dataset = QualisysAdapter.GetNextNewDataset(_config.SampleCountThreshold);
            if (dataset != null)
            {
                dataset.Enqueue();
                _logger.Info(string.Format("Queued dataset {0}", dataset.ID));
            }

            QualisysAdapter.CleanAbortedDatasets(_config.SampleCountThreshold);
        }
    }
}