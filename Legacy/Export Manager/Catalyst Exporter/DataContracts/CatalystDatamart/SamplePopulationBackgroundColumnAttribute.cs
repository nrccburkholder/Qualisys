using System;

namespace Nrc.CatalystExporter.DataContracts
{
    public class SamplePopulationBackgroundColumnAttribute
    {
        public int StudyID { get; set; }
        public string ColumnName { get; set; }
        public string ColumnDescription { get; set; }
        public string ColumnCustomDescription { get; set; }
        public bool IsSelectable { get; set; }
        public string ColumnFormula { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDate { get; set; }
    }
}
