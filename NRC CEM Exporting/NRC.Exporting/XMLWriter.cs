using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.IO;
using System.Data;
using System.Xml.Schema;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace CEM.Exporting
{

    public class XMLWriter : IDisposable
    {

        #region properties

        private XmlTextWriter writer;

        private StringWriter mStringWriter;

        private XmlTextWriter Writer { get { return writer; } }

        public string XmlString
        {
            get
            {
                StringBuilder sb = new StringBuilder();
                sb = mStringWriter.GetStringBuilder();
                writer.Close();
                return sb.ToString();
            }
        }

        #endregion

        #region public methods

        public void StartElement(string name)
        {
            writer.WriteStartElement(name);
        }

        public void EndElement()
        {
            writer.WriteEndElement();
        }

        public void WriteAttribute(string name, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    writer.WriteAttributeString(name, value);
                }
            }
        }

        public void WriteElementString(string name, string value)
        {
            if (name != null)
            {
                if (value != null)
                {
                    writer.WriteElementString(name, SanitizeElement(value));
                }
            }
        }

        public void WriteCommentstring(string comment)
        {
            writer.WriteComment(comment);
        }        

        private string SanitizeElement(string s)
        {
            string temp = s;

            temp = temp.Replace("&", "&amp;");
            temp = temp.Replace("<", "&lt;");
            temp = temp.Replace(">", "&gt;");
            temp = temp.Replace("'", "&apos;");
            temp = temp.Replace(@"""", "&quot;");
            temp = temp.Replace("\a", "");

            return temp;
        }

        public void Flush()
        {
            writer.Flush();
        }

        public void Close()
        {
            writer.Close();
        }

        #endregion

        #region constructors

        public XMLWriter()
        {
            mStringWriter = new StringWriter();
            writer = new XmlTextWriter(mStringWriter);
            writer.Formatting = Formatting.Indented;
            writer.WriteRaw(@"<?xml version=""1.0"" encoding=""UTF-8""?>");
        }

        public XMLWriter(StreamWriter stream)
        {
            writer = new XmlTextWriter(stream);
            writer.Formatting = Formatting.Indented;
            writer.WriteRaw(@"<?xml version=""1.0"" encoding=""UTF-8""?>");
        }

        public XMLWriter(StreamWriter stream, string stylesheet)
        {
            writer = new XmlTextWriter(stream);
            writer.Formatting = Formatting.Indented;
            writer.WriteProcessingInstruction("xml-stylesheet", string.Format(" type='text/xsl' href='{0}'", stylesheet));
        }

        #endregion

        #region destructors

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }


        public virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                writer.Dispose();
            }
        }
        #endregion

    }
}
