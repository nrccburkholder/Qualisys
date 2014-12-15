using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;

namespace NRC.Exporting
{
    public class XmlDocumentEx: XmlDocument
    {

        public List<ExportValidationError> ValidationErrorList { get; set; }
        public bool IsValid { get { return ValidationErrorList.Count == 0; } }


        public XmlDocumentEx(): base()
        {
            ValidationErrorList = new List<ExportValidationError>();
        }

        public bool Validate()
        {
            bool isValid = true;

            XDocument xDoc = XDocument.Parse(this.OuterXml);

            xDoc.Validate(this.Schemas, (o, e) =>
            {
                XElement element = (XElement)o;
                ValidationErrorList.Add(new ExportValidationError(element.Name.ToString(), element.Value, e.Message, e.Severity));
                isValid = false;
            });

            return isValid;
        } 
    }
}