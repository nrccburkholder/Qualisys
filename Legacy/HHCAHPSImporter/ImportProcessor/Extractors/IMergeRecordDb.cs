using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public interface IMergeRecordDb
    {
        Dictionary<string, XElement> GetMergeRecords(int sampleYear, int sampleMonth, string CCN);

        void UpdateMergeRecords(int sampleYear, int sampleMonth, string CCN, XElement records);
    }
}
