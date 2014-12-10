using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NRC.Exporting
{
    public class ExportValidationError
    {

        public string FileName { get; set; }
        public string ErrorDescription { get; set; }

        public ExportValidationError()
        {

        }

        public ExportValidationError(string errordescription)
        {
            ErrorDescription = errordescription;
        }

        public ExportValidationError(string filename, string errordescription)
        {
            FileName = filename;
            ErrorDescription = errordescription;
        }
    }
}
