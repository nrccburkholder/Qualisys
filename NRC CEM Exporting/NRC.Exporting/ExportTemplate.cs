using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;
using System.Xml.Linq;
using System.IO;
using NRC.Exporting.DataProviders;

namespace NRC.Exporting
{
    [System.Serializable]
    public class ExportTemplate
    {

        #region properties

        bool mIsValid = false;

        public int? ExportTemplateID { get; set; }
        public string ExportTemplateName { get; set; }
        public int? SurveyTypeID { get; set; }
        public int? SurveySubTypeID { get; set; }
        public int? ValidDateType { get; set; }
        public DateTime? ValidStartDate { get; set; }
        public DateTime? ValidEndDate { get; set; }
        public string ExportTemplateVersionMajor { get; set; }
        public int? ExportTemplateVersionMinor { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedOn { get; set; }
        public int? ClientID { get; set; }
        public int? DefaultNotificationID {get; set;}
        public string DefaultNamingConvention { get; set; }
        public int? State { get; set; }
        public bool ReturnsOnly { get; set; }
        public int? SampleUnitCahpsTypeID { get; set; }
        public string XMLSchemaDefinition { get; set; }
        public bool isOfficial { get; set; }
        public int? DefaultFileMakerType { get; set; }
        public List<ExportSection> Sections { get; set; }
        public bool IsValid { get {return mIsValid;}}
        public List<string> MissingColumns { get; set; }

        #endregion

        #region constructors

        public ExportTemplate()
        {
            XMLSchemaDefinition = string.Empty;
            Sections = new List<ExportSection>();
            MissingColumns = new List<string>();
        }

        #endregion

        #region public methods

        public static List<ExportTemplate>Select(ExportTemplate template, bool IncludeChildProperties = false)
        {
            return ExportTemplateProvider.Select(template, IncludeChildProperties);
        }
            
        #endregion

        #region Validation

        public bool ValidateTemplateAgainstXSD()
        {
            WalkXSD();
            mIsValid = MissingColumns.Count == 0;
            return mIsValid;
        }

        private void WalkXSD()
        {
            MissingColumns.Clear();

            string xsd = this.XMLSchemaDefinition; 

            if (xsd != string.Empty)
            { 
                           
                XmlSchema schema = XmlSchema.Read(new StringReader(this.XMLSchemaDefinition), new ValidationEventHandler(ValidationCallBack));
                schema.Compile(ValidationCallBack);
                string ns = schema.TargetNamespace;
                // Iterate over each XmlSchemaElement in the Values collection 
                // of the Elements property. 
                XmlSchemaElement root = schema.Items[0] as XmlSchemaElement;

                XmlSchemaSequence children = ((XmlSchemaComplexType)root.ElementSchemaType).ContentTypeParticle as XmlSchemaSequence;
                foreach (XmlSchemaObject child in children.Items.OfType<XmlSchemaElement>())
                {
                    WalkXSDChildren(child, root.Name);
                }
            }

        }

        private void WalkXSDChildren(XmlSchemaObject xso, string parentName)
        {

            if (xso.GetType().Equals(typeof(XmlSchemaElement)))
            {
                XmlSchemaElement xse = (XmlSchemaElement)xso;

                // Get the complex type of the element.
                XmlSchemaComplexType complexType = xse.ElementSchemaType as XmlSchemaComplexType;

                if (complexType == null)
                {
                    // it's a simple type, so no sub elements
                    XmlSchemaElement parent = GetParentElement(xse);

                    bool HasMatchingColumn = this.IsExist(xse.Name);

                    if (!HasMatchingColumn)
                    { 
                        MissingColumns.Add(parent.Name + ": " + xse.Name); 
                    }

                }
                else
                {
                    // If the complex type has any attributes, get an enumerator  
                    // and write each attribute name to the console. 
                    if (complexType.AttributeUses.Count > 0)
                    {
                        IDictionaryEnumerator enumerator = complexType.AttributeUses.GetEnumerator();

                        while (enumerator.MoveNext())
                        {
                            XmlSchemaAttribute attribute = (XmlSchemaAttribute)enumerator.Value;
                        }
                    }

                    // Get the sequence particle of the complex type.
                    XmlSchemaSequence sequence = complexType.ContentTypeParticle as XmlSchemaSequence;
                    if (sequence != null)
                    {
                        // Iterate over each XmlSchemaElement in the Items collection. 
                        foreach (XmlSchemaObject childElement in sequence.Items)
                        {
                            //Console.WriteLine("Child Element: {0}", childElement.Name);
                            WalkXSDChildren(childElement, xse.Name);
                        }
                    }
                }
            }
        }

        private XmlSchemaElement GetParentElement(XmlSchemaObject xse)
        {
            XmlSchemaObject xso = xse.Parent;

            if (!xso.GetType().Equals(typeof(XmlSchemaElement)))
            {
                return GetParentElement(xso);
            }
            else
            {
                return (XmlSchemaElement)xse.Parent;
            }
        }

        private void ValidationCallBack(object sender, ValidationEventArgs args){}

        public bool IsExist(string name)
        {
            bool b = false;

            foreach (ExportSection section in this.Sections)
            {
                if (section.ExportTemplateSectionName.Equals(name, StringComparison.OrdinalIgnoreCase))
                {
                    b = true;
                    break;
                }
                else
                {
                    b = IsColumn(section, name);
                    if (b == true) break;
                }
            }

            return b;
        }

        private bool IsColumn(ExportSection section, string name)
        {
            bool b = false;

            foreach (ExportColumn column in section.ExportColumns)
            {
                if (column.ExportColumnName.Equals(name, StringComparison.OrdinalIgnoreCase))
                {
                    b = true;
                    break;
                }
                else
                {
                    b = IsColumnResponse(column, name);
                    if (b == true) break;
                }
            }

            return b;
        }

        private bool IsColumnResponse(ExportColumn column, string name)
        {
            bool b = false;

            foreach (ExportColumnResponse response in column.ColumnResponses)
            {
                if (response.ExportColumnName.Equals(name, StringComparison.OrdinalIgnoreCase))
                {
                    b = true;
                    break;
                }
            }

            return b;
        }

        #endregion

    }
}
