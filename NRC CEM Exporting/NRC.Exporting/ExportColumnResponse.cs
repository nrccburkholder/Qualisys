using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CEM.Exporting.DataProviders;

namespace CEM.Exporting
{
    [System.Serializable]
    public class ExportColumnResponse
    {

        public int? ExportTemplateColumnResponseID { get; set; }
        public int? ExportTemplateColumnID { get; set; }
        public int? ExportTemplateID { get; set; }
        public int? ExportTemplateSectionID { get; set; }
        public int? RawValue { get; set; }
        public string ExportColumnName { get; set; }
        public string RecodeValue { get; set; }
        public string ResponseLabel { get; set; }



        public ExportColumnResponse()
        {

        }

        public static List<ExportColumnResponse> Select(ExportColumnResponse response)
        {
            return ExportColumnResponseProvider.Select(response);
        }

    }
}
