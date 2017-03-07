using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.EntityClient;
using System.Data.Metadata.Edm;
using System.Data.Objects;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using NRC.Common;
using Nrc.Framework.BusinessLogic.Configuration;
using Nrc.QualiSys.Library;

using NRC.Picker.SamplingService.Store.Models;

namespace NRC.Picker.SamplingService.Store
{
    public static class QualisysAdapter
    {
        public class DBContext : IDisposable
        {
            private readonly MetadataWorkspace _metadataWorkspace;
            private readonly SqlConnection _sqlConnection;
            private readonly EntityConnection _entityConnection;

            public QualisysEntities DB { get; private set; }

            public DBContext()
            {
                _metadataWorkspace = new MetadataWorkspace(
                    new string[] { "res://*/" },
                    new Assembly[] { Assembly.GetExecutingAssembly() });
                _sqlConnection = new SqlConnection(AppConfig.QualisysConnection + " MultipleActiveResultSets=True;");
                _entityConnection = new EntityConnection(_metadataWorkspace, _sqlConnection);

                DB = new QualisysEntities(_entityConnection);
                DB.CommandTimeout = 300;
            }

            public void Dispose()
            {
                _sqlConnection.Dispose();
                _entityConnection.Dispose();
                DB.Dispose();
            }
        }

        public static Dataset GetNextNewDataset(float sampleCountThreshold)
        {
            using (DBContext dbContext = new DBContext())
            {
                string[] finishedStateStrings = { State.Completed.ToString(), State.Failed.ToString(), State.Locked.ToString() };
                
                foreach (int datasetID in dbContext.DB.QualisysDatasets
                                                      .Where(ds => (ds.ApplyDate != null) && ds.Study.bitAutosample && (ds.SampleDataset.Count == 0))
                                                      //.Where(ds => ds.Study.bitAutosample)
                                                      //.Where(ds => ds.SampleDataset.Count == 0)
                                                      .Where(ds => !dbContext.DB.QueuedDatasets
                                                                                .Where(qds => (qds.Dataset.StudyID == ds.StudyID) && !finishedStateStrings.Contains(qds.StateString))
                                                                                //.Where(qds => !finishedStateStrings.Contains(qds.StateString))
                                                                                .Any())
                                                      .Select(ds => ds.DatasetID)
                                                      .Except(dbContext.DB.QueuedDatasets.Select(ds => ds.DatasetID)))
                {
                    Logger.GetLogger().Info(String.Format("Detected dataset {0} for autosampling", datasetID));
                    return new Dataset(datasetID, sampleCountThreshold);
                }

                return null;
            }
        }

        public static void CleanAbortedDatasets(float sampleCountThreshold)
        {
            string abortedString = State.Aborted.ToString();
            using (DBContext dbContext = new DBContext())
            {
                foreach (int datasetID in dbContext.DB.QueuedDatasets
                                                   .Where(qds => qds.StateString == abortedString)
                                                   .Select(qds => qds.DatasetID)
                                                   .ToList())
                {
                    Dataset dataset = new Dataset(datasetID, sampleCountThreshold);
                    dataset.ClearSamples();
                    dataset.Release();
                }
            }
        }

        public static StudyDataset GetStudyDataset(int datasetID)
        {
            QualisysDataset dataset;
            using (DBContext dbContext = new DBContext())
            {
                dataset = dbContext.DB.QualisysDatasets.First(ds => ds.DatasetID == datasetID);
            }

            if (dataset.StudyID == null)
            {
                throw new StoreCorruptException();
            }

            foreach (StudyDataset studyDataset in StudyDataset.GetByStudyId((int)dataset.StudyID, dataset.LoadDate, dataset.LoadDate))
            {
                if (studyDataset.Id == datasetID)
                {
                    return studyDataset;
                }
            }

            throw new StoreCorruptException();
        }

        private enum SurveyOrder
        {
            Primary,
            Secondary,
            Tertiary,
            Quaternary,
            Quinary,
            Senary,
            Septenary,
            Octonary,
            Nonary,
            Denary,
            Inpatient,
            Outpatient,
            EmergencyRoom,
            Other,
            Census
        }

        private static SurveyOrder GetOrderForSurvey(Survey survey)
        {
            switch (survey.get_SamplingToolPriority())
            {
                case 1: return SurveyOrder.Primary;
                case 2: return SurveyOrder.Secondary;
                case 3: return SurveyOrder.Tertiary;
                case 4: return SurveyOrder.Quaternary;
                case 5: return SurveyOrder.Quinary;
                case 6: return SurveyOrder.Senary;
                case 7: return SurveyOrder.Septenary;
                case 8: return SurveyOrder.Octonary;
                case 9: return SurveyOrder.Nonary;
                case 10: return SurveyOrder.Denary;
                case 99:
                    if (survey.SamplePeriods[0].SamplingMethod == SampleSet.SamplingMethod.Census)
                    {
                        return SurveyOrder.Census;
                    }
                    if (survey.Name.ToLower().Contains("ip") || survey.Name.ToLower().Contains("inpatient"))
                    {
                        return SurveyOrder.Inpatient;
                    }
                    if (survey.Name.ToLower().Contains("op") || survey.Name.ToLower().Contains("outpatient"))
                    {
                        return SurveyOrder.Outpatient;
                    }
                    if (survey.Name.ToLower().Contains("ed") || survey.Name.ToLower().Contains("er"))
                    {
                        return SurveyOrder.EmergencyRoom;
                    }
                else  return SurveyOrder.Other;
            }
            return SurveyOrder.Other;
        }

        public static IEnumerable<Survey> GetSurveys(Dataset dataset)
        {
            List<Survey> surveys = new List<Survey>(Survey.GetByStudy(dataset.Study));

            surveys.Sort((surveyA, surveyB) =>
            {
                SurveyOrder orderA = GetOrderForSurvey(surveyA);
                SurveyOrder orderB = GetOrderForSurvey(surveyB);

                return orderA != orderB ? orderA.CompareTo(orderB) : surveyA.Id.CompareTo(surveyB.Id);
            });

            return surveys;
        }

        public static SampleResult CreateSample(Dataset dataset, Survey survey, DateRange dateRange)
        {
            SampleSet sample = SampleSet.CreateSampleSet(survey.Id,
                                                         new Collection<StudyDataset> { dataset.StudyDataset },
                                                         dateRange.Start,
                                                         dateRange.End,
                                                         dataset.Study.AccountDirector,
                                                         dateRange.Period,
                                                         false,
                                                         -1);  // modified to pass -1 instead of 0 so that auto seeding is enabled  TSB 05/11/2015

            return new SampleResult(dataset, survey, dateRange, sample);
        }

        public static IEnumerable<SampleSet> GetSamplesForDataset(int datasetID)
        {
            using (DBContext dbContext = new DBContext())
            {
                foreach (int sampleID in dbContext.DB.SampleDatasets
                                                  .Where(sds => sds.DatasetID == datasetID)
                                                  .Select(sds => sds.SampleID))
                {
                    SampleSet sampleSet = SampleSet.GetSampleSet(sampleID);
                    if (sampleSet == null)
                    {
                        throw new StoreCorruptException();
                    }
                    yield return SampleSet.GetSampleSet(sampleID);
                }
            }
        }

        public static void ScheduleSample(SampleSet sample)
        {
            sample.ScheduleSampleSetGeneration(DateTime.Now);
        }

        public static SamplePlanWorksheet GetSamplePlanWorksheet(int sampleID, int sampleUnitID)
        {
            using (DBContext dbContext = new DBContext())
            {
                return dbContext.DB.SamplePlanWorksheets.First(spw => spw.SampleID == sampleID && spw.SampleUnitID == sampleUnitID);
            }
        }

        public static QueuedDataset GetQueuedDataset(int datasetID)
        {
            using (DBContext dbContext = new DBContext())
            {
                return dbContext.DB.QueuedDatasets.Where(ds => ds.DatasetID == datasetID).FirstOrDefault();
            }
        }

        public static SampleSet GetMostRecentSampleSetForSurvey(Survey survey)
        {
            StudyDataset dataset = StudyDataset.GetByStudyId(survey.StudyId, null, null)
                                               .OrderByDescending(ds => ds.DateLoaded)
                                               .First();

            return GetSamplesForDataset(dataset.Id).OrderByDescending(ss => ss.SampleEndDate).FirstOrDefault();
        }

        public static void Enqueue(int datasetID)
        {
            using (DBContext dbContext = new DBContext())
            {
                QueuedDataset queuedDataset = QueuedDataset.CreateQueuedDataset(
                    0,          // this is discarded and generated by the db
                    datasetID,
                    State.New.ToString()
                    );
                dbContext.DB.QueuedDatasets.AddObject(queuedDataset);
                dbContext.DB.SaveChanges();
            }
        }

        public static void Dequeue(int datasetID)
        {
            using (DBContext dbContext = new DBContext())
            {
                QueuedDataset queuedDataset = dbContext.DB.QueuedDatasets.Where(ds => ds.DatasetID == datasetID).FirstOrDefault();
                dbContext.DB.QueuedDatasets.DeleteObject(queuedDataset);
                dbContext.DB.SaveChanges();
            }
        }

        public static QueuedDataset GetNextDataset()
        {
            string newString = State.New.ToString();
            using (DBContext dbContext = new DBContext())
            {
                QueuedDataset queuedDataset = dbContext.DB.QueuedDatasets
                                                       .Where(ds => ds.StateString == newString)
                                                       .OrderBy(ds => ds.DatasetQueueID)
                                                       .FirstOrDefault();
                if (queuedDataset == null)
                {
                    return null;
                }
                queuedDataset.State = State.Queued;
                dbContext.DB.SaveChanges();
                return queuedDataset;
            }
        }

        public static List<QueuedDataset> GetQueuedDatasets(DateTime start, DateTime end)
        {
            using (DBContext dbContext = new DBContext())
            {
                return dbContext.DB.QueuedDatasets
                                .Where(qds => qds.SampleStartTime >= start)
                                .Where(qds => qds.SampleStartTime <= end)
                                .OrderByDescending(qds => qds.SampleStartTime)
                                .ToList();
            }
        }

        public static void SetState(int datasetID, State state)
        {
            using (DBContext dbContext = new DBContext())
            {
                QueuedDataset queuedDataset = dbContext.DB.QueuedDatasets.Where(qds => qds.DatasetID == datasetID).First();
                queuedDataset.StateString = state.ToString();
                dbContext.DB.SaveChanges();
            }
        }

        public static void SetStartTime(int datasetID)
        {
            using (DBContext dbContext = new DBContext())
            {
                QueuedDataset queuedDataset = dbContext.DB.QueuedDatasets.Where(qds => qds.DatasetID == datasetID).First();
                queuedDataset.SampleStartTime = DateTime.Now;
                dbContext.DB.SaveChanges();
            }
        }

        public static void SetEndTime(int datasetID)
        {
            using (DBContext dbContext = new DBContext())
            {
                QueuedDataset queuedDataset = dbContext.DB.QueuedDatasets.Where(qds => qds.DatasetID == datasetID).First();
                queuedDataset.SampleEndTime = DateTime.Now;
                dbContext.DB.SaveChanges();
            }
        }
    }
}
