using System;
using System.Collections.Generic;
using System.Threading;

using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

using NRC.Platform.Test.DevelopmentInterfaces;

namespace NRC.Picker.SamplingService.TestFixtures
{
    public class AutoSamplerFixture : ITestFixture
    {

        private const string _dataSetId = "Data set ID";
        private const string _configFileSource = "Autosampler configuration file source path";
        private const string _defaultConfigFileSource = @"C:\NRC.Test\Data\AutoSampler\ConfigurationFiles\BasicSettings.xml";
        private const string _configFileDestination = "Autosampler configuration file destination path";
        private const string _defaultConfigFileDestination = @"c:\NRC\Platform\NRC.Picker.SamplingService\NRC.Picker.SamplingService.Autosampler\bin\Debug\settings.xml";

        private const string _serviceName = "Autosampler";
        private const string _serviceMutex = "AutosamplerMutex";

        private const string _queueServiceName = "QueueService";
        private const string _queueServiceMutex = "QueuingMutex";

        public Configuration Config;

        private const int _testRuntime = 420000;
        private const float _samplingSuccessThreshhold = 0.8f;

        public TestCase Testcase
        {
            get;
            set;
        }

        public void SetupTest(Dictionary<string, object> runtimeStateTable)
        {
            int dataSetId = Int32.Parse(StaticUtilities.GetResourceValue(_dataSetId, Testcase.Resources));
            StaticUtilities.StopService(_serviceName, _serviceMutex);
            StaticUtilities.StopService(_queueServiceName, _queueServiceMutex);
            CleanDataSet(dataSetId);

            string configSource = StaticUtilities.GetResourceValue(_configFileSource, Testcase.Resources);
            string configDestination = StaticUtilities.GetResourceValue(_configFileDestination, Testcase.Resources);

            if (configSource == null)
            {
                configSource = _defaultConfigFileSource;
            }
            if (configDestination == null)
            {
                configDestination = _defaultConfigFileDestination;
            }

            try
            {
                StaticUtilities.ChangeServiceConfigFile(configSource, configDestination, _serviceName, _serviceMutex);
            }
            catch (Exception ex)
            {
                throw new Exception(String.Format("Error ensuring the service is running; can't run fixture: {0}", ex.Message), ex);
            }

        }

        public void ExecuteTest(Dictionary<string, object> runtimeStateTable)
        {
            Thread.Sleep(_testRuntime);
        }

        public void CleanupTest(Dictionary<string, object> runtimeStateTable)
        {
            int dataSetId = Int32.Parse(StaticUtilities.GetResourceValue(_dataSetId, Testcase.Resources));
            StaticUtilities.StopService(_serviceName, _serviceMutex);
            CleanDataSet(dataSetId);
        }

        public IEnumerable<string> GetRequiredResourceNames()
        {
            return new string[] {_dataSetId, _configFileSource};
        }

        public IEnumerable<string> GetOptionalResourceNames()
        {
            return new string[] {};
        }

        private static void CleanDataSet(int dataSetId)
        {
            var dataset = new Dataset(dataSetId, _samplingSuccessThreshhold);
            dataset.ClearSamples();
            dataset.Dequeue();
            dataset.Enqueue();
        }
    }
}
