using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Xml.Linq;

namespace NRC.Common.Configuration.Helpers
{
    internal class ListType: IConfigType
    {
        public bool Handles(Type memberType)
        {
            return (memberType.IsGenericType && memberType.GetGenericTypeDefinition() == typeof(List<>));
        }

        public object Create(Type memberType, ConfigUseAttribute memberData, IEnumerable<XElement> elements, string attrValue, Dictionary<string, string> extras, ConfigHelper helper)
        {
            if (elements != null)
            {
                return CreateFromElements(memberType, memberData, elements, extras, helper);
            }
            else if (attrValue != null)
            {
                throw new ConfigException(String.Format("The member {0} is a list, and hence must appear as child elements, not an attribute.", memberData.Name));
            }
            else if (memberData.CreateAlways || (memberData.ExtraName != null && extras.ContainsKey(memberData.ExtraName)))
            {
                XElement def = new XElement(memberData.Name);
                if (memberData.ChildName != null)
                {
                    def.Add(new XElement(memberData.ChildName));
                }
                return CreateFromElements(memberType, memberData, new XElement[] { def }, extras, helper);
            }
            // unlike other types, missing data is considered just an empty list (assuming that it's not the style of list that has a parent node with children, since
            // then the parent node must be present)
            else if (memberData.IsOptional || helper.EverythingOptional || memberData.ChildName == null)
            {
                return Activator.CreateInstance(memberType); // return an empty list
            }
            else
            {
                throw new ConfigException(String.Format("The member {0} does not appear in the configuration, and is either not optional or no default was provided.", memberData.Name));
            }
        }

        private object CreateFromElements(Type memberType, ConfigUseAttribute memberData, IEnumerable<XElement> elements, Dictionary<string, string> extras, ConfigHelper helper)
        {
            object list = Activator.CreateInstance(memberType);

            MethodInfo addMethod = memberType.GetMethod("Add");
            Type genericArg = (memberType.GetGenericArguments())[0]; // if memberType is List<X>, genericArg is X

            Dictionary<string, Type> childTypes = new Dictionary<string, Type>();

            if (memberData.MultipleNames != null)
            {
                for (int i = 0; i < memberData.MultipleNames.Length; i++)
                {
                    childTypes[memberData.MultipleNames[i]] = (memberData.MultipleTypes != null) ? 
                        memberData.MultipleTypes[i] : genericArg;
                }
            }

            // if ChildName is specified, promote the children of this element and use them instead
            if (memberData.ChildName != null)
            {
                if (memberData.ChildName != null)
                {
                    childTypes[memberData.ChildName] = genericArg;
                }

                foreach (XElement element in elements)
                {
                    helper.CheckForInclude(element, false);
                }

                List<XElement> children = new List<XElement>();
                elements.ToList().ForEach(a => children.AddRange(GetChildrenByName(a, a.Name.LocalName, childTypes.Keys.ToList(), helper)));
                elements = children;
            }
            else
            {
                childTypes[memberData.Name] = genericArg;
            }

            foreach (XElement element in elements)
            {
                object sub = helper.LoadByType(childTypes[element.Name.LocalName], memberData, new XElement[] { element }, null, extras);
                addMethod.Invoke(list, new object[]{ sub });
            }

            return list;
        }

        private IEnumerable<XElement> GetChildrenByName(XElement element, string parentName, List<string> nameList, ConfigHelper helper)
        {
            HashSet<string> names = new HashSet<string>(nameList);

            List<XElement> children = new List<XElement>();
            children.AddRange(element.Elements());

            IEnumerable<string> bad = children.Where(a => !names.Contains(a.Name.LocalName)).Select(a => a.Name.LocalName);
            helper.CheckUnusedNodes(parentName, "element", bad);

            return children;
        }

        public string SerializeAsString(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper)
        {
            throw new ConfigException(String.Format("Member {0} cannot be serialized as a scalar -- it's a list.", memberData.Name));
        }

        public IEnumerable<XElement> SerializeAsElements(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper)
        {
            if (value == null)
            {
                if (memberData.IsOptional)
                {
                    return new XElement[] { };
                }
                throw new ConfigException(String.Format("Member {0} has no value set but isn't optional.", memberData.Name));
            }

            List<XElement> ret = new List<XElement>();

            PropertyInfo countMethod = memberType.GetProperty("Count");
            int count = (int)countMethod.GetValue(value, null);

            PropertyInfo itemMethod = memberType.GetProperty("Item");
            Type genericArg = (memberType.GetGenericArguments())[0]; // if memberType is List<X>, genericArg is X

            for (int i = 0; i < count; i++)
            {
                object curValue = itemMethod.GetValue(value, new object[] { i });

                ConfigUseAttribute childData = (ConfigUseAttribute)memberData.Clone();
                if (childData.ChildName != null)
                {
                    childData.Name = childData.ChildName;
                    childData.ChildName = null;
                    childData.MultipleNames = null;
                    childData.MultipleTypes = null;
                }
                else if (childData.MultipleNames != null)
                {
                    if (childData.MultipleTypes != null)
                    {
                        Type vt = curValue.GetType();
                        for (int j = 0; j < childData.MultipleTypes.Length; j++)
                        {
                            if (vt == childData.MultipleTypes[j] || vt.IsSubclassOf(childData.MultipleTypes[j]))
                            {
                                childData.Name = childData.MultipleNames[j];
                                childData.ChildName = null;
                                childData.MultipleNames = null;
                                childData.MultipleTypes = null;
                                break;
                            }
                        }
                    }
                    else
                    {
                        childData.Name = childData.MultipleNames[0];
                        childData.ChildName = null;
                        childData.MultipleNames = null;
                        childData.MultipleTypes = null;
                    }
                }

                foreach (XElement e in helper.SaveByTypeAsElements(genericArg, childData, curValue))
                {
                    ret.Add(e);
                }
            }

            if (memberData.ChildName != null || memberData.MultipleNames != null)
            {
                XElement enclosing = new XElement(memberData.Name);
                ret.ForEach(a => enclosing.Add(a));
                return new XElement[] { enclosing };
            }
            else
            {
                return ret;
            }
        }
    }
}
