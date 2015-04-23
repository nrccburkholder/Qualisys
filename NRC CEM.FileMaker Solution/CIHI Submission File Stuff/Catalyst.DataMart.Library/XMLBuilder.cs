using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.IO;
using System.Data;


namespace Catalyst.DataMart.Library
{
    public static class XMLBuilder
    {

        private static XMLWriter mXmlWriter;

        public static XmlDocument CreateXML(DataSet ds)
        {
            mXmlWriter = new XMLWriter();

            // here, we will build the results XML



            XmlDocument xmldoc = new XmlDocument();
            xmldoc.LoadXml(mXmlWriter.XMLString);

            return xmldoc;
        }

    }


    internal class XMLWriter
    {

        #region properties

        private XmlTextWriter mXMLWriter;
        private StringWriter mStringWriter;

        private readonly XmlTextWriter Writer { get { return mXMLWriter; } }

        public readonly string XMLString
        {
            get
            {
                StringBuilder sb = mStringWriter.GetStringBuilder();
                mXMLWriter.Close();
                return sb.ToString();
            }
        }

        #endregion

        #region public methods

        public void StartElement(string name)
        {
            mXMLWriter.WriteStartElement(name);
        }

        public void EndElement()
        {
            mXMLWriter.WriteEndElement();
        }

        public void WriteAttribute(string name, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    mXMLWriter.WriteAttributeString(name, value);
                }
            }
        }

        public void WriteElementString(string name, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    mXMLWriter.WriteElementString(name, value);
                }
            }
        }

        public string SanitizeElement(string s)
        {
            string temp = s;

            temp = temp.Replace("&", "&amp;");
            temp = temp.Replace("<", "&lt;");
            temp = temp.Replace(">", "&gt;");
            temp = temp.Replace("'", "&apos;");
            temp = temp.Replace(@"""", "&quot;");

            return temp;
        }

        #endregion

        #region constructors

        public XMLWriter()
        {
            mStringWriter = new StringWriter();
            mXMLWriter = new XmlTextWriter(mStringWriter);
            mXMLWriter.Formatting = Formatting.Indented;
        }

        public XMLWriter(string stylesheet)
        {
            mStringWriter = new StringWriter();
            mXMLWriter = new XmlTextWriter(mStringWriter);
            mXMLWriter.Formatting = Formatting.Indented;
            mXMLWriter.WriteProcessingInstruction("xml-stylesheet", string.Format(" type='text/xsl' href='{0}'", stylesheet));
        }

        #endregion


    }
}
