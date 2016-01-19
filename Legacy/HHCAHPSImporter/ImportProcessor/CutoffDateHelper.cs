using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor
{
    internal static class CutoffDateHelper
    {
        private enum Quarter
        {
            Q1,
            Q2,
            Q3,
            Q4
        }

        private static Quarter GetQuarter(int sampleMonth)
        {
            switch (sampleMonth)
            {
                case 1:
                case 2:
                case 3:
                    return Quarter.Q1;
                case 4:
                case 5:
                case 6:
                    return Quarter.Q2;
                case 7:
                case 8:
                case 9:
                    return Quarter.Q3;
                case 10:
                case 11:
                case 12:
                    return Quarter.Q4;
                default:
                    throw new ArgumentOutOfRangeException(nameof(sampleMonth), sampleMonth, "Sample month must be between 1 and 12.");
            }
        }

        public static bool IsPastCutoff(DateTime q1Cutoff, DateTime q2Cutoff, DateTime q3Cutoff, DateTime q4Cutoff, int sampleMonth, int sampleYear, DateTime currentDate)
        {
            var quarter = GetQuarter(sampleMonth);

            DateTime cutoff;
            switch (quarter)
            {
                case Quarter.Q1:
                    cutoff = new DateTime(sampleYear, q1Cutoff.Month, q1Cutoff.Day);
                    break;
                case Quarter.Q2:
                    cutoff = new DateTime(sampleYear, q2Cutoff.Month, q2Cutoff.Day);
                    break;
                case Quarter.Q3:
                    cutoff = new DateTime(sampleYear + 1, q3Cutoff.Month, q3Cutoff.Day);
                    break;
                case Quarter.Q4:
                    cutoff = new DateTime(sampleYear + 1, q4Cutoff.Month, q4Cutoff.Day);
                    break;
                default:
                    throw new InvalidOperationException(string.Format("Couldn't get the cutoff date for quarter {0}.", quarter));
            }

            return currentDate.Date > cutoff;
        }
    }
}
