using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Catalyst.DataMart.Library
{
    public class ExportColumnResponse
    {

        public int ExportTemplateColumnResponseID { get; set; }
        public int ExportTemplateColumnId { get; set; }
        public int RawValue { get; set; }
        public string ExportColumnName { get; set; }
        public string RecodeValue { get; set; }
        public string ResponseLabel { get; set; }



        public ExportColumnResponse()
        {

        }


    }
}
