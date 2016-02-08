using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class SampleMonthValidator
    {
        public static void Validate(int? sampleMonth, int? sampleYear)
        {
            Validate(new SampleMonth { Month = sampleMonth, Year = sampleYear });
        }

        public static void Validate(SampleMonth sampleMonth)
        {
            if (sampleMonth.HasMissingData) throw new InvalidOperationException("Sample month or year is missing.");
            if (!sampleMonth.HasEnded) throw new InvalidOperationException("Sample month has not ended yet. This file was received too early.");
        }

        public static void Validate(IEnumerable<SampleMonth> sampleMonths)
        {
            if (!sampleMonths.Any()) return;

            var distinctMonths = sampleMonths.Distinct();

            foreach (var month in distinctMonths)
            {
                Validate(month);
            }

            if (distinctMonths.Count() > 1) throw new InvalidOperationException("More than one sample month in file.");
        }
    }
}
