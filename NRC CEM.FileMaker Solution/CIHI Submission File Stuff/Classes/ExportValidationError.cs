using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Schema;

namespace cihifilemaker.Classes
{
    public class ExportValidationError
    {

        public string ElementName { get; set; }
        public string ElementValue { get; set; }
        public string FileName { get; set; }
        public string ErrorDescription { get; set; }
        public XmlSeverityType Severity { get; set; }

        public ExportValidationError()
        {

        }

        public ExportValidationError(string errordescription)
        {
            ErrorDescription = errordescription;
        }

        public ExportValidationError(string elementname, string elementvalue, string errordescription, XmlSeverityType severity)
        {
            ElementName = elementname;
            ElementValue = elementvalue;
            ErrorDescription = errordescription;
            Severity = severity;
        }

        public ExportValidationError(string filename, string errordescription)
        {
            FileName = filename;
            ErrorDescription = errordescription;
        }

        public ExportValidationError(string elementname, string elementvalue, string filename, string errordescription, XmlSeverityType severity)
        {
            ElementName = elementname;
            ElementValue = elementvalue;
            FileName = filename;
            ErrorDescription = errordescription;
            Severity = severity;

        }
    }
}
