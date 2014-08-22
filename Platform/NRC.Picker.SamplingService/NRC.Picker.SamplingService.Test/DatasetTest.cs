using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using Nrc.QualiSys.Library;

using NRC.Common;
using NRC.Picker.SamplingService.Autosampler;
using NRC.Picker.SamplingService.Mailer;
using NRC.Picker.SamplingService.QueueService;
using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

namespace NRC.Picker.SamplingService.Test
{
    [TestClass()]
    public class DatasetTest
    {
        public static int ClientID = 85;
        public static int StudyID = 199;
        public static int DatasetID = 463;
        public static int SurveyID = 282;

        public static float SampleCountThreshold = 0.8f;
        public static string MailerUrl = "http://lnk0tdiapp01:3417/Service";

        public static readonly Logger Logger = Logger.GetLogger("datasettest");

        public TestContext TestContext { get; set; }

        [ClassCleanup()]
        public static void MyClassCleanup()
        {
            Dataset ds = new Dataset(DatasetID, SampleCountThreshold);
            ds.ClearSamples();
        }

        [TestMethod()]
        public void DatasetConstructorTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            Assert.AreEqual(StudyID, target.Study.Id);
        }

        [TestMethod()]
        public void QueueServiceDoWorkTest()
        {
            QueueService.QueueService.DoWork();
        }

        [TestMethod()]
        public void ClearSamplesTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            target.ClearSamples();
            int count = 0;
            foreach (SampleSet sample in target.Samples)
            {
                if (sample.ScheduledDate != null)
                {
                    count++;
                }
            }
            Assert.AreEqual(0, count);
        }

        [TestMethod()]
        public void DequeueTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            target.Dequeue();
            Assert.IsNull(QualisysAdapter.GetQueuedDataset(DatasetID));
        }

        [TestMethod()]
        public void EnqueueTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            target.Dequeue();
            target.Enqueue();
            Assert.IsNotNull(QualisysAdapter.GetQueuedDataset(DatasetID));
            Assert.AreEqual(target.State, State.New);
        }

        [TestMethod()]
        public void GetDateRangesTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            Survey survey = Survey.Get(SurveyID);
            IEnumerable<DateRange> actual = target.GetDateRanges(survey);

            int count = 0;
            foreach (DateRange dateRange in actual)
            {
                count++;
            }
            Assert.AreEqual(3, count);
        }

        [TestMethod()]
        public void SampleTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            Survey survey = Survey.Get(SurveyID);

            target.ClearSamples();

            IEnumerable<SampleResult> sampleResults = target.Result.GetResultsForSurvey(survey);
            int count = 0;
            foreach (SampleResult sampleResult in sampleResults)
            {
                count++;
            }
            Assert.AreEqual(0, count);

            target.Dequeue();
            Assert.IsNull(target.QueuedDataset);

            target.Enqueue();
            Assert.IsNotNull(target.QueuedDataset);

            target.Sample(false);

            sampleResults = target.Result.GetResultsForSurvey(survey);
            count = 0;
            foreach (SampleResult sampleResult in sampleResults)
            {
                count++;
            }
            Assert.AreEqual(3, count);
            Assert.IsTrue(target.Result.Check());
        }

        [TestMethod()]
        public void ClientTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);

            Client expected = Client.GetClient(ClientID);
            Client actual = target.Client;

            Assert.AreEqual(expected.Id, actual.Id);
        }

        [TestMethod()]
        public void StudyTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);

            Study expected = Study.GetStudy(StudyID);
            Study actual = target.Study;

            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void SurveysTest()
        {
            Dataset target = new Dataset(DatasetID, SampleCountThreshold);
            IEnumerable<Survey> actual = target.Surveys;

            int count = 0;
            int validCount = 0;
            foreach (Survey survey in actual)
            {
                count++;
                if (survey.IsValidated)
                {
                    validCount++;
                }
            }

            Assert.AreEqual(2, count);
            Assert.AreEqual(1, validCount);
        }

        [TestMethod()]
        public void AutosampleTest()
        {
            Dataset dataset = new Dataset(DatasetID, SampleCountThreshold);
            dataset.ClearSamples();

            AutosamplerService.SampleDataset(dataset);
        }

        [TestMethod()]
        public void DanaDatasetTest()
        {
            Dataset dataset = new Dataset(465, SampleCountThreshold);
            dataset.ClearSamples();

            AutosamplerService.SampleDataset(dataset);
        }

        [TestMethod()]
        public void NoValidPeriodsTest()
         {
            const int noPeriodDatasetID = 36;

            Dataset dataset = new Dataset(noPeriodDatasetID, SampleCountThreshold);
            dataset.ClearSamples();
            dataset.Dequeue();
            dataset.Enqueue();
            try
            {
                dataset.Sample(false);
            }
            catch (NoValidPeriodsException)
            {
            }
            catch
            {
                Assert.Fail("Should have thrown a NoValidPeriodsException error");
            }
        }

        [TestMethod()]
        public void HHCAHPSGetDateRangesTest()
        {
            Dataset target = new Dataset(510, SampleCountThreshold);
            Survey survey = Survey.Get(189);
            DateRange dateRange = target.GetDateRanges(survey).ToArray()[0];

            Assert.AreEqual(dateRange.Period.ExpectedStartDate, dateRange.Start);
            Assert.AreEqual(dateRange.Period.ExpectedEndDate, dateRange.End);

            // let's see if it breaks like it ought to
            survey.SurveyType = SurveyTypes.None;

            dateRange = target.GetDateRanges(survey).ToArray()[0];
            Assert.AreNotEqual(dateRange.Period.ExpectedEndDate, dateRange.End);
        }

        [TestMethod()]
        public void GetNextNewDatasetTest()
        {
            int datasetID = 144840;

            Dataset dataset = new Dataset(datasetID, SampleCountThreshold);
            dataset.ClearSamples();
            dataset.Dequeue();

            dataset = QualisysAdapter.GetNextNewDataset(SampleCountThreshold);
            Assert.IsNotNull(dataset);

            bool foundOurDataset = false;
            while (dataset != null)
            {
                if (!foundOurDataset && dataset.ID == DatasetID)
                {
                    foundOurDataset = true;
                    break;
                }
                else
                {
                    dataset.Enqueue();
                }
            }
            Assert.IsTrue(foundOurDataset);
        }
    }
}