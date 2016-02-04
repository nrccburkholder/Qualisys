using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal class SampleMonth
    {
        public int? Month { get; set; }
        public int? Year { get; set; }

        public bool HasMissingData
        {
            get
            {
                return Month == null || Month <= 0 || Year == null || Year <= 0;
            }
        }

        public override bool Equals(object obj)
        {
            var compareTo = obj as SampleMonth;
            if (compareTo == null) return false;

            return Year == compareTo.Year && Month == compareTo.Month;
        }

        public override int GetHashCode()
        {
            return Year.GetHashCode() ^ Month.GetHashCode();
        }
    }
}
