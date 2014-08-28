using System;
using System.Collections.Generic;
using System.Threading;

using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

using NRC.Platform.Test.DevelopmentInterfaces;

namespace NRC.Picker.SamplingService.TestFixtures
{
    public class SamplingE2EFixture : ITestFixture
    {
        private const string _dataSetId = "Data set ID";
        private const string _queueServiceConfigFileSource = "Queue Service configuration file source path";
        private const string _defaultQueueServiceConfigFileSource = @"C:\NRC.Test\Data\QueueService\ConfigurationFiles\BasicSettings.xml";
        private const string _queueServiceConfigFileDestination = "Queue Service configuration file destination path";
        private const string _defaultQueueServiceConfigFileDestination = @"c:\NRC\Platform\NRC.Picker.SamplingService\NRC.Picker.SamplingService.Autosampler\bin\Debug\settings.xml";
        private const string _autosamplerConfigFileSource = "Autosampler configuration file source path";
        private const string _defaultAutosamplerConfigFileSource = @"C:\NRC.Test\Data\AutoSampler\ConfigurationFiles\BasicSettings.xml";
        private const string _autosamplerConfigFileDestination = "Autosampler configuration file destination path";
        private const string _defaultAutosamplerConfigFileDestination = @"c:\NRC\Platform\NRC.Picker.SamplingService\NRC.Picker.SamplingService.Autosampler\bin\Debug\settings.xml";

        private const string _autosamplerServiceName = "Autosampler";
        private const string _autosamplerServiceMutex = "AutosamplerMutex";
        private const string _queueServiceName = "QueueService";
        private const string _queueServiceMutex = "QueueServiceMutex";

        private const int _testRuntime = 420000;
        private const float _samplingSuccessThreshhold = 0.8f;


        public Configuration Config;

        public TestCase Testcase{ get; set; }

        public void SetupTest(Dictionary<string, object> runtimeStateTable)
        {
            int dataSetId = Int32.Parse(StaticUtilities.GetResourceValue(_dataSetId, Testcase.Resources));
            StaticUtilities.StopService(_queueServiceName, _queueServiceMutex);
            StaticUtilities.StopService(_autosamplerServiceName, _autosamplerServiceMutex);
            CleanDataSet(dataSetId);

            string queueServiceConfigSource = StaticUtilities.GetResourceValue(_queueServiceConfigFileSource, Testcase.Resources);
            string queueServiceConfigDestination = StaticUtilities.GetResourceValue(_queueServiceConfigFileDestination, Testcase.Resources);

            if (queueServiceConfigSource == null)
            {
                queueServiceConfigSource = _defaultQueueServiceConfigFileSource;
            }
            if (queueServiceConfigDestination == null)
            {
                queueServiceConfigDestination = _defaultQueueServiceConfigFileDestination;
            }

            string autosamplerConfigSource = StaticUtilities.GetResourceValue(_autosamplerConfigFileSource, Testcase.Resources);
            string autosamplerConfigDestination = StaticUtilities.GetResourceValue(_autosamplerConfigFileDestination, Testcase.Resources);

            if (autosamplerConfigSource == null)
            {
                autosamplerConfigSource = _defaultAutosamplerConfigFileSource;
            }
            if (autosamplerConfigDestination == null)
            {
                autosamplerConfigDestination = _defaultAutosamplerConfigFileDestination;
            }

            try
            {
                StaticUtilities.ChangeServiceConfigFile(queueServiceConfigSource, queueServiceConfigDestination, _queueServiceName, _queueServiceMutex);
            }
            catch (Exception ex)
            {
                throw new Exception(String.Format("Error ensuring the service is running; can't run fixture: {0}", ex.Message), ex);
            }

            try
            {
                StaticUtilities.ChangeServiceConfigFile(autosamplerConfigSource, autosamplerConfigDestination, _autosamplerServiceName, _autosamplerServiceMutex);
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
            StaticUtilities.StopService(_queueServiceName, _queueServiceMutex);
            StaticUtilities.StopService(_autosamplerServiceName, _autosamplerServiceMutex);
            CleanDataSet(dataSetId);
        }

        public IEnumerable<string> GetRequiredResourceNames()
        {
            return new string[] {_dataSetId};
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
        }
    }
}
