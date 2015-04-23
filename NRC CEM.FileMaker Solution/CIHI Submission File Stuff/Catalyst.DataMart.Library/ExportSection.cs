using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Catalyst.DataMart.Library
{
    public class ExportSection
    {

        public int ExportTemplateSectionID{ get; set; }
        public string ExportTemplateSectionName{ get; set; }
        public int ExportTemplateID{ get; set; }
        public string DefaultNamingConvention{ get; set; }
        public List<ExportColumn> ExportColumns{ get; set; }

        public ExportSection()
        {
            ExportColumns = new List<ExportColumn>();
        }

    }
}
