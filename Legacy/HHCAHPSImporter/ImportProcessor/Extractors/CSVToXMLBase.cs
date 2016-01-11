using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.Reflection;
using System.Text.RegularExpressions;

using System.Xml;
using System.Xml.Serialization;

// using LumenWorks.Framework.IO.Csv;


namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    public class CSVToXMLBase
    {
        #region original version using generic csv parser
        //public XElement CsvToXML(DAL.Generated.ClientDetail client, CsvReader csv, string name)
        //{
        //    var xroot = new XElement(name); //Create the root element

        //    List<string> headers = csv.GetFieldHeaders().ToList<string>();

        //    while (csv.ReadNextRecord())
        //    {
        //        var xrow = new XElement("r", new XAttribute("id", csv.CurrentRecordIndex));

        //        foreach (string h in headers)
        //        {
        //            // if (csv[h].Trim().Length > 0)
        //            {
        //                XElement xvar = new XElement("nv", new XAttribute("n", h));
        //                xvar.Value = csv[h];

        //                xrow.Add(xvar);
        //            }
        //        }

        //        xroot.Add(xrow);
        //    }

        //    return xroot;
        //}
        #endregion

        public XElement CsvToXML(Type t, List<object> records, string name)
        {
            var xroot = new XElement(name); //Create the root element

            var fields = t.GetFields().ToList();

            // starting the rowid at 1.
            int rowid = 1;
            foreach (object r in records)
            {
                var xrow = new XElement("r", new XAttribute("id", rowid++));

                foreach (var field in fields)
                {
                    string fieldName = field.Name;

                    XmlAttributeAttribute exportNameAttrib = (XmlAttributeAttribute)field.GetCustomAttributes(typeof(XmlAttributeAttribute), false).FirstOrDefault();
                    if (exportNameAttrib != null)
                    {
                        fieldName = exportNameAttrib.AttributeName;
                    }

                    XElement xvar = new XElement("nv", new XAttribute("n", fieldName));

                    object value = t.GetField(field.Name).GetValue(r);

                    if (value != null)
                    {
                        xvar.Value = value.ToString();
                    }

                    xrow.Add(xvar);

                }
                xroot.Add(xrow);
            }

            return xroot;
        }
    }
}
