using System.Collections.Generic;
using System.Linq;

using Nrc.QualiSys.Library;

namespace NRC.Picker.SamplingService.Store.Models
{
    public class DatasetResult
    {
        public Study Study { get; set; }
        public Dataset Dataset { get; set; }
        public float SampleCountThreshold { get; set; }

        public IEnumerable<Survey> Surveys
        {
            get
            {
                return this.Study.Surveys;
            }
        }

        public IEnumerable<SampleResult> AllSamples { get { return Surveys.SelectMany(GetResultsForSurvey); } }
        public IEnumerable<SampleResult> SuccessfulSamples { get { return AllSamples.Where(sr => sr.Check(SampleCountThreshold)); } }
        public IEnumerable<SampleResult> FailedSamples { get { return AllSamples.Where(sr => !sr.Check(SampleCountThreshold)); } }

        private readonly Dictionary<int, List<SampleResult>> _sampleResultsForSurveyID;

        public DatasetResult(Dataset dataset, float sampleCountThreshold)
        {
            Dataset = dataset;
            Study = Dataset.Study;

            SampleCountThreshold = sampleCountThreshold;

            _sampleResultsForSurveyID = new Dictionary<int, List<SampleResult>>();

            foreach (Survey survey in Study.Surveys)
            {
                _sampleResultsForSurveyID[survey.Id] = new List<SampleResult>();
            }

            foreach (SampleSet sample in dataset.Samples)
            {
                AddSample(sample);
            }
        }

        public void AddSample(SampleSet sample)
        {
            Survey survey = Survey.Get(sample.SurveyId);
            AddSampleResult(new SampleResult(Dataset, survey, new DateRange(sample), sample));
        }

        public void AddSampleResult(SampleResult sampleResult)
        {
            _sampleResultsForSurveyID[sampleResult.Survey.Id].Add(sampleResult);
        }

        public IEnumerable<SampleResult> GetResultsForSurvey(Survey survey)
        {
            return _sampleResultsForSurveyID[survey.Id];
        }

        public bool Check()
        {
            return FailedSamples.Count() == 0;
        }
    }

    public class SampleResult
    {
        private readonly List<SampleUnitResult> _sampleUnitResults;

        public Dataset Dataset { get; set; }
        public Survey Survey { get; set; }
        public DateRange DateRange { get; set; }
        public SampleSet Sample { get; set; }

        public IEnumerable<SampleUnitResult> SampleUnitResults
        {
            get
            {
                return _sampleUnitResults;
            }
        }

        public SampleResult(Dataset dataset, Survey survey, DateRange dateRange, SampleSet sample)
        {
            Dataset = dataset;
            Survey = survey;
            DateRange = dateRange;
            Sample = sample;

            _sampleUnitResults = new List<SampleUnitResult>(SampleUnit.GetAllSampleUnitsForSurvey(survey)
                                                                      .Select(unit => new SampleUnitResult(sample, unit)));
        }

        public bool Check(float sampleCountThreshold)
        {
            return SampleUnitResults.All(sampleUnitResult => sampleUnitResult.Check(sampleCountThreshold));
        }
    }

    public class SampleUnitResult
    {
        public int Available { get; set; }
        public int Target { get; set; }
        public int RealTarget { get; set; }
        public int Actual { get; set; }
        public int PriorOutgo { get; set; }

        public SampleSet Sample { get; set; }
        public SampleUnit SampleUnit { get; set; }

        public SampleUnitResult(SampleSet sample, SampleUnit sampleUnit)
        {
            Sample = sample;
            SampleUnit = sampleUnit;

            Target = sampleUnit.Target;
            SamplePlanWorksheet spw = QualisysAdapter.GetSamplePlanWorksheet(sample.Id, sampleUnit.Id);
            if (spw.AvailableUniverse != null)
            {
                Available = (int)spw.AvailableUniverse;
            }
            if (spw.OutgoNeededNow != null)
            {
                RealTarget = (int)spw.OutgoNeededNow;
            }
            if (spw.SampleCount != null)
            {
                Actual = (int)spw.SampleCount;
            }
            if (spw.TotalPriorPeriodOutgo != null)
            {
                PriorOutgo = (int)spw.TotalPriorPeriodOutgo;
            }
        }

        public float SampleCoverage
        {
            get { return (((float)Actual) / RealTarget); }
        }

        public bool Check(float sampleCountThreshold)
        {
            return (Available == Actual) || Threshold(sampleCountThreshold);
        }

        public bool Threshold(float sampleCountThreshold)
        {
            return (Actual >= RealTarget * sampleCountThreshold);
        }
    }
}
