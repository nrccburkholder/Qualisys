using System;
using System.Linq;

using Nrc.QualiSys.Library;

namespace NRC.Picker.SamplingService.Store.Models
{
    public class DateRange
    {
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public SamplePeriod Period { get; set; }

        public DateRange(DateTime start, DateTime end, SamplePeriod period)
        {
            Start = start;
            End = end;
            Period = period;
        }

        public DateRange(SampleSet sample)
        {
            if (sample.DateRangeFrom == null || sample.DateRangeTo == null)
            {
                throw new StoreCorruptException();
            }
            
            Start = (DateTime)sample.DateRangeFrom;
            End = (DateTime)sample.DateRangeTo;

            Survey survey = Survey.Get(sample.SurveyId);
            foreach (SamplePeriod period in
                survey.SamplePeriods.Where(period => Start >= period.ExpectedStartDate && End <= period.ExpectedEndDate))
            {
                Period = period;
                break;
            }
        }

        public float CoverageFraction
        {
            get
            {
                if (Period.ExpectedStartDate == null || Period.ExpectedEndDate == null)
                {
                    throw new StoreCorruptException();
                }

                return ((float)(End - Start).Days) / (Period.ExpectedEndDate.Value - Period.ExpectedStartDate.Value).Days;
            }
        }
    }
}