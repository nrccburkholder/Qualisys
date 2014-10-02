using System;
using System.Collections.Generic;
using System.Threading;

using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

using NRC.Platform.Test.DevelopmentInterfaces;

namespace NRC.Picker.SamplingService.TestFixtures
{
    public class QueueServiceFixture : ITestFixture
    {
        private const string _dataSetId = "Data set ID";
        private const string _configFileSource = "Queuing Service configuration file source path";
        private const string _defaultConfigFileSource = @"C:\NRC.Test\Data\QueueService\ConfigurationFiles\BasicSettings.xml";
        private const string _configFileDestination = "Queuing Service configuration file destination path";
        private const string _defaultConfigFileDestination = @"c:\NRC\Platform\NRC.Picker.SamplingService\NRC.Picker.SamplingService.QueueService\bin\Debug\settings.xml";

        private const string _serviceName = "QueueService";
        private const string _serviceMutex = "QueuingMutex";

        private const string _autosamplerServiceName = "AutosamplerService";
        private const string _autosamplerServiceMutex = "AutosamplerMutex";

        private const int _testRuntime = 60000;
        private const float _samplingSuccessThreshhold = 0.8f;
     
        public Configuration Config;

        public TestCase Testcase
        {
            get; 
            set;
        }

        public void SetupTest(Dictionary<string, object> runtimeStateTable)
        {
            int dataSetId = Int32.Parse(StaticUtilities.GetResourceValue(_dataSetId, Testcase.Resources));
            StaticUtilities.StopService(_serviceName, _serviceMutex);
            StaticUtilities.StopService(_autosamplerServiceName, _autosamplerServiceMutex);
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
        }


    }
}
