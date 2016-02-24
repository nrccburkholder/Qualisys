using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Xml;
namespace NRCFileConverterLibrary.Common
{
    /// <summary>
    /// RuleConfigurationHandler reads the configuration file App.Config and extracts the information.
    /// </summary>
    public class RuleConfigurationHandler: IConfigurationSectionHandler
    {
        public RuleConfigurationHandler()  { }
        public object Create(object parent, object configContext, System.Xml.XmlNode section)
        {
            List<RuleConfigurationItem> items = new List<RuleConfigurationItem>();
            XmlNodeList processesNodes = section.SelectNodes("Rule");
            foreach (XmlNode processNode in processesNodes)
            {
                RuleConfigurationItem item = new RuleConfigurationItem();
                item.Name = processNode.Attributes["Name"].InnerText;
                item.FileType = processNode.Attributes["FileType"].InnerText;
                item.InputPath = processNode.Attributes["InputPath"].InnerText;
                item.InProcessPath = processNode.Attributes["InProcessPath"].InnerText;
                item.ArchivePath = processNode.Attributes["ArchivePath"].InnerText;
                item.Provider = processNode.Attributes["Provider"].InnerText;
                item.PrimaryKey = processNode.Attributes["PrimaryKey"].InnerText;
                item.OutPath = processNode.Attributes["OutPath"].InnerText;
                items.Add(item);
            }
            return items;
        }
    }
}
