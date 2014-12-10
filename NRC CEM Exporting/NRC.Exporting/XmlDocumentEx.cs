using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;
using System.IO;

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


        public bool Validate(string xsd)
        {
            bool isValid = true;

            XmlSchema schema = XmlSchema.Read(new StringReader(xsd), null);
            string ns = schema.TargetNamespace;

            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add(ns, XmlReader.Create(new StringReader(xsd)));

            XDocument xDoc = XDocument.Parse(this.OuterXml);

            xDoc.Validate(schemas, (o, e) =>
            {
                ValidationErrorList.Add(new ExportValidationError(e.Message));
                isValid = false;
            });

            return isValid;
        }
    }
}
