using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace Tools
{
    /// <summary>
    /// Summary description for clsXMLTools.
    /// </summary>
    public class clsXMLTools
    {
        public clsXMLTools()
        {
            //
            // TODO: Add constructor logic here
            //
        }
    }

    public class clsXmlNodeReader
    {
        private XmlNode _node;

        public clsXmlNodeReader(XmlNode node)
        {
            _node = node;
        }

        public bool Contains(string sNodeName)
        {
            XmlNode childnode = _node.SelectSingleNode(String.Format("{0}", sNodeName));
            return (childnode != null);
        }

        public string Value(string sNodeName)
        {
            XmlNode childnode = _node.SelectSingleNode(String.Format("{0}", sNodeName));
            if (childnode != null)
                return childnode.InnerText;
            else
                return "";

        }
    }
}

