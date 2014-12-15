using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace NRC.Exporting
{
    [System.Serializable]
    public class ExportSection
    {

        public int? ExportTemplateSectionID{ get; set; }
        public string ExportTemplateSectionName{ get; set; }
        public int? ExportTemplateID{ get; set; }
        public string DefaultNamingConvention{ get; set; }
        public List<ExportColumn> ExportColumns{ get; set; }

        public ExportSection()
        {
            ExportColumns = new List<ExportColumn>();
        }

        public static List<ExportSection> Select(ExportSection section, bool IncludeChildProperties = false)
        {
            return DataProviders.ExportSectionProvider.Select (section, IncludeChildProperties);
        }


    }
}
