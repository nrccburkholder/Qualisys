using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using Nrc.QualiSys.Library;
using NRC.Common;

namespace NRC.Picker.SamplingService.Store.Models
{
    public class Dataset
    {
        public StudyDataset StudyDataset { get; private set; }
        public QueuedDataset QueuedDataset { get; private set; }
        public Study Study { get; private set; }
        public Client Client { get; private set; }

        private float _sampleCountThreshold { get; set; }
        public DatasetResult Result { get; private set; }

        public bool Stop { get; set; }

        public int ID { get { return StudyDataset.Id; } }
        public IEnumerable<Survey> Surveys
        {
            get
            {
                return QualisysAdapter.GetSurveys(this).ToList();
            }
        }
        public IEnumerable<SampleSet> Samples
        {
            get
            {
                return QualisysAdapter.GetSamplesForDataset(ID);
            }
        }
        public State State
        {
            get
            {
                return QueuedDataset.State;
            }
            private set
            {
                QueuedDataset.State = value;
            }
        }

        public static Dataset GetNextDataset(float sampleCountThreshold)
        {
            QueuedDataset queuedDataset = QualisysAdapter.GetNextDataset();

            if (queuedDataset == null)
            {
                return null;
            }

            Dataset dataset = new Dataset(queuedDataset.DatasetID, sampleCountThreshold);

            return dataset;
        }

        public Dataset(int datasetID, float sampleCountThreshold)
        {
            StudyDataset = QualisysAdapter.GetStudyDataset(datasetID);
            QueuedDataset = QualisysAdapter.GetQueuedDataset(datasetID);
            Study = Study.GetStudy(StudyDataset.StudyId);
            Client = Study.Client;

            _sampleCountThreshold = sampleCountThreshold;
            Result = new DatasetResult(this, sampleCountThreshold);

            Stop = false;
        }

        public bool IsQueued { get { return QueuedDataset != null; } }
        public void Enqueue()
        {
            if (!IsQueued)
            {
                QueuedDataset = QueuedDataset.Enqueue(ID);
            }
        }
        public void Dequeue()
        {
            if (IsQueued)
            {
                QueuedDataset.Dequeue(ID);
                QueuedDataset = null;
            }
        }

        public void ClearSamples()
        {
            ClearSamples(true);
        }

        public void ClearSamples(bool clearScheduled)
        {
            var samples = clearScheduled
                              ? Samples
                              : Samples.Where(sample => sample.ScheduledDate == null);

            foreach (SampleSet sample in samples)
            {
                if (sample.IsScheduledForGeneration)
                {
                    sample.UnscheduleSampleSetGeneration();
                }
                SampleSet.DeleteSampleSet(sample.Id);
            }

            Result = new DatasetResult(this, _sampleCountThreshold);
        }

        public void Sample(bool enableScheduling)
        {
            Logger logger = Logger.GetLogger();

            try
            {
                State = State.Processing;
                QueuedDataset.SetStartTime();

                if (StudyDataset.RecordCount == 0)
                {
                    logger.Error(String.Format("dataset ({0}) has no records!", ID));
                    throw new CorruptDatasetException();
                }

                ClearSamples(false);

                CheckHCHAPS();

                foreach (Survey survey in Surveys)
                {
                    if (Stop)
                    {
                        logger.Info("Detected stop request, aborting sampling");
                        throw new ProcessingAbortedException();
                    }
                    if (!survey.IsValidated)
                    {
                        continue;
                    }

                    DateRange[] dateRanges = GetDateRanges(survey).ToArray();
                    if (dateRanges.Length == 0)
                    {
                        throw new NoValidPeriodsException();
                    }
                    foreach (DateRange dateRange in dateRanges.TakeWhile(dr => !Stop))
                    {
                        SampleResult sampleResult = QualisysAdapter.CreateSample(this, survey, dateRange);
                        if (enableScheduling && sampleResult.Check(_sampleCountThreshold))
                        {
                            QualisysAdapter.ScheduleSample(sampleResult.Sample);
                        }
                        Result.AddSampleResult(sampleResult);
                    }
                }

                State = State.Completed;
                QueuedDataset.SetEndTime();
            }
            catch (ProcessingAbortedException)
            {
                State = State.Aborted;
                throw;
            }
            catch (CAHPSCCNLockedException)
            {
                State = State.Locked;
                throw;
            }
            catch(Exception ex)
            {
                State = State.Failed;
                throw;
            }
        }

        public IEnumerable<DateRange> GetDateRanges(Survey survey)
        {
            List<DateRange> dateRanges = new List<DateRange>();

            // find the date interval of our dataset
            DateTime dataStart = GetStudyDatasetDateRange(survey).MinimumDate;
            DateTime dataEnd = GetStudyDatasetDateRange(survey).MaximumDate;

            // create a DateRange for each sampleperiod our dataset occupies
            foreach (SamplePeriod period in survey.SamplePeriods)
            {
                DateTime start;
                DateTime end;

                DateTime periodStart;
                DateTime periodEnd;
                try
                {
                    periodStart = (DateTime)period.ExpectedStartDate;
                    periodEnd = (DateTime)period.ExpectedEndDate;
                }
                catch (InvalidOperationException)
                {
                    throw new Exception("Sample period start and/or end date is undefined.");
                }

                if ((periodStart <= dataStart) && (dataStart <= periodEnd))
                {
                    start = dataStart;
                }
                else if (dataStart < periodStart)
                {
                    start = periodStart;
                }
                else
                {
                    continue;
                }

                if ((periodStart <= dataEnd) && (dataEnd <= periodEnd))
                {
                    end = dataEnd;
                }
                else if (periodEnd < dataEnd)
                {
                    end = periodEnd;
                }
                else
                {
                    continue;
                }

                // this is a hack for HHCAHPS, where all data entries are often the first of the month
                // TODO: analyze survey rules need for new property here or not
                if (survey.get_IsMonthlyOnly() && survey.get_ResurveyExclusionPeriodsNumericDefault() == 6 ) //(survey.SurveyType == SurveyTypes.HHcahps)
                {
                    dateRanges.Add(new DateRange(periodStart, periodEnd, period));
                }
                else
                {
                    dateRanges.Add(new DateRange(start, end, period));
                }
            }

            return dateRanges;
        }

        private void CheckHCHAPS()
        {
            foreach (Survey survey in Surveys)
                                      //.Where(s => s.SurveyType == SurveyTypes.Hcahps))
                // TODO: analyze survey rules need for new property here or not
                if (survey.get_IsMonthlyOnly() && survey.get_ResurveyExclusionPeriodsNumericDefault() == 6)
                {
                    DateTime dataStart = GetStudyDatasetDateRange(survey).MinimumDate;
                    SampleSet lastSample = QualisysAdapter.GetMostRecentSampleSetForSurvey(survey);
                    if (lastSample != null)
                    {
                        int daysBetweenSamples = (dataStart - lastSample.SampleEndDate).Days;
                        if (daysBetweenSamples > 1)
                        {
                            throw new HCAHPSGapException();
                        }
                    }

                    MedicareNumberList medicareNumberList = MedicareNumber.GetBySurveyID(survey.Id);
                    foreach (MedicareNumber medicareNumber in medicareNumberList)
                    {
                        bool failed = false;
                        medicareNumber.RecalculateProportion(dataStart, Study.AccountDirectorEmployeeId, ref failed);
                        if (failed)
                        {
                            throw new CAHPSRecalculationFailedException();
                        }
                    }

                    if (MedicareNumber.GetSamplingLockedBySurveyIDs(survey.Id.ToString()).Rows.Count != 0)
                    {
                        throw new CAHPSCCNLockedException();
                    }
                }
        }

        public StudyDatasetDateRange GetStudyDatasetDateRange(Survey survey)
        {
            foreach (StudyDatasetDateRange studyDatasetDateRange in StudyDataset.DateRanges)
            {
                if (survey.SampleEncounterField.Id == studyDatasetDateRange.FieldId &&
                    survey.SampleEncounterField.TableId == studyDatasetDateRange.TableId)
                {
                    return studyDatasetDateRange;
                }
            }
            throw new Exception("Could not find matching date range");
        }

        public void Release()
        {
            QueuedDataset.State = State.New;
        }
    }
}
