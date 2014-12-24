using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NRC.Exporting.DataProviders;

namespace NRC.Exporting
{
    [System.Serializable]
    public class ExportColumn
    {

        public int? ExportTemplateID { get; set; }
        public int? ExportTemplateSectionID { get; set; }
        public int? ExportTemplateColumnID { get; set; }
        public string ExportTemplateColumnDescription{ get; set; }
        public int? ColumnOrder{ get; set; }
        public int? DataSourceID{ get; set; }
        public string ExportColumnName{ get; set; }
        public string SourceColumnName{ get; set; }
        public int? DispositionProcessID{ get; set; }
        public int? FixedWidthLength{ get; set; }
        public int? ColumnSetKey{ get; set; }
        public int? FormatID{ get; set; }
        public double? MissingThreshholdPercentage{ get; set; }
        public bool? CheckFrequencies{ get; set; }
        public List<ExportColumnResponse> ColumnResponses { get; set; }

        public ExportColumn()
        {
            ColumnResponses = new List<ExportColumnResponse>();
        }


        public List<ExportColumn> SelectSelect(ExportColumn Column, bool IncludeChildProperties = false)
        {
            return ExportColumnProvider.Select(Column, IncludeChildProperties);
        }
    }
}
