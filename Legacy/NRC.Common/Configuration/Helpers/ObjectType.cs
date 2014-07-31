using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Linq;

namespace NRC.Common.Configuration.Helpers
{
    internal class ObjectType: IConfigType
    {
        private const string TEXT_NODE_NAME = "#TEXT";

        private static Logger _logger = Logger.GetLogger();

        public bool Handles(Type memberType)
        {
            return memberType == typeof(ConfigSection) || memberType.IsSubclassOf(typeof(ConfigSection));
        }

        public object Create(Type memberType, ConfigUseAttribute memberData, IEnumerable<XElement> elements, string attrValue, Dictionary<string, string> extras, ConfigHelper helper)
        {
            if (elements != null)
            {
                if (elements.Count() != 1)
                {
                    throw new ConfigException(String.Format("The element {0} is configured to only appear one time.", memberData.Name));
                }

                return CreateFromElement(elements.FirstOrDefault(), memberType, memberData, extras, helper);
            }
            else if (attrValue != null)
            {
                throw new ConfigException(String.Format("The member {0} is a config subsection, and hence must appear as a child element, not an attribute.", memberData.Name));
            }
            else if (memberData.CreateAlways || (memberData.ExtraName != null && extras.ContainsKey(memberData.ExtraName)))
            {
                return CreateFromElement(new XElement(memberData.Name), memberType, memberData, extras, helper);
            }
            else if (memberData.IsOptional || helper.EverythingOptional)
            {
                return null;
            }
            else
            {
                throw new ConfigException(String.Format("The member {0} does not appear in the configuration, and is either not optional or no default was provided.", memberData.Name));
            }
        }

        private object CreateFromElement(XElement element, Type memberType, ConfigUseAttribute memberData, Dictionary<string, string> extras, ConfigHelper helper)
        {
            List<KeyValuePair<string, XElement>> children = element.Elements().Select(a => new KeyValuePair<string, XElement>(a.Name.LocalName, a)).ToList();
            IDictionary<string, string> attributes = element.Attributes().ToDictionary(a => a.Name.LocalName, a => a.Value);

            if (element.Nodes().Count() == 1 && (element.Nodes().FirstOrDefault().NodeType == XmlNodeType.Text || element.Nodes().FirstOrDefault().NodeType == XmlNodeType.CDATA))
            {
                attributes[TEXT_NODE_NAME] = ((XText)element.Nodes().FirstOrDefault()).Value;
            }

            IEnumerable<string> dups = children.Select(a => a.Key).Intersect(attributes.Keys);
            if (dups.Count() > 0)
            {
                throw new ConfigException(String.Format("The element {0} incorrectly uses the same name ({1}) for both an attribute and a child node.", element.Name, dups.FirstOrDefault()));
            }

            if (memberData != null)
            {
                if (memberData.CustomType)
                {
                    if (!attributes.ContainsKey("customType"))
                    {
                        throw new ConfigException(String.Format("The element {0} is missing the customType attribute.", element.Name));
                    }

                    Type customType = Type.GetType(attributes["customType"]);
                    if (customType == null)
                    {
                        throw new ConfigException(String.Format("The custom type {0} cannot be resolved.", attributes["customType"]));
                    }

                    if (!(customType == memberType || customType.IsSubclassOf(memberType)))
                    {
                        throw new ConfigException(String.Format("The custom type {0} must derive from {1}.", customType.FullName, memberType.FullName));
                    }

                    memberType = customType;
                }
                else if (memberData.MultipleTypes != null)
                {
                    for (int i = 0; i < memberData.MultipleNames.Length; i++)
                    {
                        if (memberData.MultipleNames[i].Equals(element.Name.LocalName))
                        {
                            memberType = memberData.MultipleTypes[i];
                            break;
                        }
                    }
                }
            }

            ConfigSection ret = (ConfigSection)Activator.CreateInstance(memberType);

            string includePath = helper.CheckForInclude(element, memberType.IsSubclassOf(typeof(ConfigSection)));
            if (includePath != null)
            {
                DirectoryInfo basedir = helper.GetBaseDirectory();
                string fullIncludePath = basedir != null ? Path.Combine(basedir.FullName, includePath) : includePath;

                try
                {
                    _logger.Trace(String.Format("Loading sub-configuration for {0} from file: {1}", element.Name, fullIncludePath));
                    XDocument doc = XDocument.Load(fullIncludePath);
                    ConfigSection subsection = (ConfigSection)helper.LoadByType(memberType, memberData, new XElement[] { doc.Root }, null, null);
                    subsection.IncludePath = includePath; // just want the relative part here
                    return subsection;
                }
                catch (Exception ex)
                {
                    throw new ConfigException(String.Format("Error creating sub-configuration reader from file {0}: {1}", fullIncludePath, ex.Message), ex);
                }
            }

            try
            {
                foreach (PropertyInfo property in ret.GetType().GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
                {
                    CreateMember(property, property.PropertyType, (m => property.SetValue(ret, m, null)), children, attributes, extras, helper);
                }

                foreach (FieldInfo field in ret.GetType().GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
                {
                    CreateMember(field, field.FieldType, (m => field.SetValue(ret, m)), children, attributes, extras, helper);
                }
            }
            catch (ConfigException ex)
            {
                // slight aesthetic improvement in error message:
                Match m = Regex.Match(ex.Message, "Error parsing node (.*?): (.*)");
                if (m.Success)
                {
                    throw new ConfigException(String.Format("Error parsing node {0}/{1}: {2}", element.Name, m.Groups[1].Value, m.Groups[2].Value), ex.InnerException);
                }
                else
                {
                    throw new ConfigException(String.Format("Error parsing node {0}: {1}", element.Name, ex.Message), ex.InnerException);
                }
            }

            helper.CheckUnusedNodes(element.Name.LocalName, "element", children.Select(a => a.Key));
            helper.CheckUnusedNodes(element.Name.LocalName, "attribute", attributes.Keys);
            helper.CompletedLoad(ret);

            return ret;
        }

        // this should remove any nodes it uses from the children/attribute data structures
        private void CreateMember(MemberInfo member, Type memberType, Action<object> setter,
            List<KeyValuePair<string, XElement>> children, IDictionary<string, string> attributes, 
            Dictionary<string, string> extras, ConfigHelper helper)
        {
            if (!member.DeclaringType.IsSubclassOf(typeof(ConfigSection)) ||  // exclude Equals(), toString(), etc
                member.Name.EndsWith("__BackingField")) // exclude backing fields for Properties
            {
                return;
            }

            string memberKind = member.GetType().Name.Replace("Info", "").ToLower();

            ConfigUseAttribute memberData = (ConfigUseAttribute)(member.GetCustomAttributes(typeof(ConfigUseAttribute), false).FirstOrDefault());
            if (memberData == null)
            {
                _logger.Trace(String.Format("No {0} attribute specified for {1} {2}, not doing anything.", typeof(ConfigUseAttribute).Name, memberKind, member.Name));
                return;
            }

            bool useMultiple = (memberData != null && memberData.MultipleNames != null && memberData.ChildName == null);
            HashSet<string> nameSet = new HashSet<string>(useMultiple ? memberData.MultipleNames : new string[] { memberData.Name });

            List<XElement> elements = new List<XElement>();
            for (int i = 0; i < children.Count; i++)
            {
                if (nameSet.Contains(children[i].Key))
                {
                    elements.Add(children[i].Value);
                    children.RemoveAt(i);
                    i--; // compensate for coming i++ so we stay in the same place
                }
            }

            // if no matches, then it's not used and should be null, not zero
            if (elements.Count == 0)
            {
                elements = null;
            }

            string attrValue = null;
            if (attributes.ContainsKey(memberData.Name))
            {
                attrValue = attributes[memberData.Name];
                attributes.Remove(memberData.Name);
            }
            else if (memberData.XmlType == XmlType.Text && attributes.ContainsKey(TEXT_NODE_NAME))
            {
                attrValue = attributes[TEXT_NODE_NAME];
                attributes.Remove(TEXT_NODE_NAME);
            }

            setter(helper.LoadByType(memberType, memberData, elements, attrValue, extras));
        }

        public string SerializeAsString(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper)
        {
            throw new ConfigException(String.Format("Member {0} cannot be serialized as a scalar -- it's an object.", memberData.Name));
        }

        public IEnumerable<XElement> SerializeAsElements(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper)
        {
            helper.CompletedSave((ConfigSection)value);

            XElement ret = new XElement(memberData.Name);

            Type configType = value.GetType();
            try
            {
                foreach (PropertyInfo property in configType.GetProperties(BindingFlags.Public | BindingFlags.Instance))
                {
                    SerializeMember(property, property.PropertyType, () => property.GetValue(value, null), ret, helper);
                }

                foreach (FieldInfo field in configType.GetFields(BindingFlags.Public | BindingFlags.Instance))
                {
                    SerializeMember(field, field.FieldType, () => field.GetValue(value), ret, helper);
                }
            }
            catch (ConfigException ex)
            {
                throw new ConfigException(String.Format("Error saving node {0}: {1}", memberData.Name, ex.Message), ex.InnerException);
            }

            if (memberData != null && memberData.CustomType)
            {
                ret.Add(new XAttribute("customType", Regex.Replace(configType.AssemblyQualifiedName, @"^([^,]+,\s+[^,]+),.*$", "$1")));
            }

            ConfigSection subsection = (ConfigSection)value;
            if (subsection.IncludePath != null)
            {
                DirectoryInfo basedir = helper.GetBaseDirectory();
                string fullIncludePath = basedir != null ? Path.Combine(basedir.FullName, subsection.IncludePath) : subsection.IncludePath;

                try
                {
                    _logger.Trace(String.Format("Writing sub-configuration for {0} to file: {1}", memberData.Name, fullIncludePath));
                    XDocument doc = new XDocument(new XDeclaration("1.0", "UTF-8", "yes"), ret);
                    using (StreamWriter writer = new StreamWriter(File.Open(fullIncludePath, FileMode.Create), new UTF8Encoding(false)))
                    {
                        doc.Save(writer, SaveOptions.None);
                    }
                }
                catch (Exception ex)
                {
                    throw new ConfigException(String.Format("Error creating sub-configuration writer for file {0}: {1}", fullIncludePath, ex.Message), ex);
                }

                ret = helper.CreateIncludeElement(memberData.Name, subsection.IncludePath);
            }

            return new XElement[]{ ret };
        }

        private void SerializeMember(MemberInfo member, Type memberType, Func<object> getValue, XElement element, ConfigHelper helper)
        {
            if (!member.DeclaringType.IsSubclassOf(typeof(ConfigSection)) ||  // exclude Equals(), toString(), etc
                member.Name.EndsWith("__BackingField")) // exclude backing fields for Properties
            {
                return;
            }

            string memberKind = member.GetType().Name.Replace("Info", "").ToLower();

            ConfigUseAttribute memberData = (ConfigUseAttribute)(member.GetCustomAttributes(typeof(ConfigUseAttribute), false).FirstOrDefault());
            if (memberData == null)
            {
                _logger.Trace(String.Format("No {0} attribute specified for {1} {2}, not doing anything.", typeof(ConfigUseAttribute).Name, memberKind, member.Name));
                return;
            }

            if (memberData.XmlType == XmlType.Attribute)
            {
                element.SetAttributeValue(memberData.Name, helper.SaveByTypeAsString(memberType, memberData, getValue()));
            }
            else if (memberData.XmlType == XmlType.Text || memberData.Name.Equals(TEXT_NODE_NAME))
            {
                element.Add(new XText(helper.SaveByTypeAsString(memberType, memberData, getValue())));
            }
            else
            {
                foreach (XElement e in helper.SaveByTypeAsElements(memberType, memberData, getValue()))
                {
                    element.Add(e);
                }
            }
        }
    }
}
