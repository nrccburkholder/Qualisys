using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Xml.Linq;

namespace NRC.Common.Configuration.Helpers
{
    internal class ConfigHelper
    {
        private const string INCLUDE_ATTRIBUTE = "include-file";

        private static Logger _logger = Logger.GetLogger();
        private static List<IConfigType> _types;
        private static ValueType _valueType;

        private ConfigOptions _options;

        static ConfigHelper()
        {
            _valueType = new ValueType();

            List<IConfigType> types = new List<IConfigType>();
            types.Add(_valueType);
            types.Add(new ObjectType());
            types.Add(new ListType());
            _types = types;
        }

        public ConfigHelper(ConfigOptions options)
        {
            _options = options;

            if (options.BaseDirectory != null && !options.BaseDirectory.Exists)
            {
                throw new ConfigException(String.Format("The base directory {0} does not exist.", options.BaseDirectory.FullName));
            }
        }

        public T LoadFromDocument<T>(Type rootType, XDocument doc, Dictionary<string, string> extras) where T : ConfigSection, new()
        {
            ConfigClassAttribute rootAttribute = (ConfigClassAttribute)(rootType.GetCustomAttributes(typeof(ConfigClassAttribute), false).FirstOrDefault());

            if (doc != null)
            {
                string version = (doc.Root.Attribute("version") != null) ? doc.Root.Attribute("version").Value : null;
                if (_options.VersionTransformer != null)
                {
                    _logger.Trace(String.Format("Version transformation was specified for configuration, transforming with version {0}", version ?? "<unspecified>"));
                    _options.VersionTransformer(doc, version);
                }

                if (rootAttribute != null)
                {
                    if (!doc.Root.Name.LocalName.Equals(rootAttribute.Name))
                    {
                        throw new ConfigException(String.Format("Invalid root node for configuration; expected {0}, found {1}", rootAttribute.Name, doc.Root.Name.LocalName));
                    }
                }

                return (T)LoadByType(rootType, rootAttribute, new XElement[] { doc.Root }, null, extras);
            }
            else
            {
                return (T)LoadByType(rootType, rootAttribute, null, null, extras);
            }
        }

        public XDocument SaveToDocument(ConfigSection config)
        {
            ConfigClassAttribute rootAttribute = (ConfigClassAttribute)(config.GetType().GetCustomAttributes(typeof(ConfigClassAttribute), false).FirstOrDefault());
            rootAttribute = rootAttribute ?? new ConfigClassAttribute();
            rootAttribute.Name = rootAttribute.Name ?? "settings";

            XElement root = SaveByTypeAsElements(config.GetType(), rootAttribute, config).FirstOrDefault();
            root.SetAttributeValue("version", _options.CurrentVersion ?? "<unknown>");

            return new XDocument(new XDeclaration("1.0", "UTF-8", "yes"), root);
        }

        // The Expression<Func<T>> stuff is a little hairy, but it's necessary because you can't just pass in the *value* of the
        // object's field, you have to pass in, essentially, a pointer to the field itself so its ConfigUse attribute can be looked up
        // in this function. For more details:
        // http://stackoverflow.com/questions/72121/finding-the-variable-name-passed-to-a-function-in-c
        // http://stackoverflow.com/questions/2616638/access-the-value-of-a-member-expression
        // http://stackoverflow.com/questions/208969/assignment-in-net-3-5-expression-trees
        public void CheckedAssign<T>(Expression<Func<T>> target, string value)
        {
            MemberExpression mexp = target.Body as MemberExpression;
            if (mexp == null)
            {
                throw new ConfigException("The target is not of the correct type.");
            }

            ConfigUseAttribute memberData = (ConfigUseAttribute)(mexp.Member.GetCustomAttributes(typeof(ConfigUseAttribute), false).FirstOrDefault());
            if (memberData == null)
            {
                throw new ConfigException("Attempting to assign to member which has no ConfigUse attribute.");
            }

            var convertedExpr = Expression.Convert(mexp.Expression, typeof(object));
            var configGetter = Expression.Lambda<Func<object>>(convertedExpr).Compile();
            ConfigSection configObj = (ConfigSection)configGetter();

            if ((mexp.Member as PropertyInfo) != null)
            {
                PropertyInfo info = mexp.Member as PropertyInfo;
                object v = LoadByType(info.PropertyType, memberData, null, value, new Dictionary<string,string>());
                info.SetValue(configObj, v, null);
            }
            else if ((mexp.Member as FieldInfo) != null)
            {
                FieldInfo info = mexp.Member as FieldInfo;
                object v = LoadByType(info.FieldType, memberData, null, value, new Dictionary<string, string>());
                info.SetValue(configObj, v);
            }
            else
            {
                throw new ConfigException(String.Format("Member to be assigned is of unknown type {0}", mexp.Member.GetType().Name));
            }
            CompletedLoad(configObj);
        }

        public string CheckedRead<T>(Expression<Func<T>> target)
        {
            MemberExpression mexp = target.Body as MemberExpression;
            if (mexp == null)
            {
                throw new ConfigException("The target to be read is not of the correct type.");
            }

            ConfigUseAttribute memberData = (ConfigUseAttribute)(mexp.Member.GetCustomAttributes(typeof(ConfigUseAttribute), false).FirstOrDefault());
            if (memberData == null)
            {
                throw new ConfigException("Attempting to read from member which has no ConfigUse attribute.");
            }

            var convertedExpr = Expression.Convert(mexp.Expression, typeof(object));
            var configGetter = Expression.Lambda<Func<object>>(convertedExpr).Compile();
            ConfigSection configObj = (ConfigSection)configGetter();
            CompletedSave(configObj);

            // like in CheckedAssign, but here get the entire object.member expression, not the sub-expression for just the object
            var convertedMemberExpr = Expression.Convert(mexp, typeof(object)); 
            var configMemberGetter = Expression.Lambda<Func<object>>(convertedMemberExpr).Compile();
            object configMemberObj = configMemberGetter();

            if ((mexp.Member as PropertyInfo) != null)
            {
                PropertyInfo info = mexp.Member as PropertyInfo;
                return SaveByTypeAsString(info.PropertyType, memberData, configMemberObj);
            }
            else if ((mexp.Member as FieldInfo) != null)
            {
                FieldInfo info = mexp.Member as FieldInfo;
                return SaveByTypeAsString(info.FieldType, memberData, configMemberObj);
            }
            else
            {
                throw new ConfigException(String.Format("Member to be serialized is of unknown type {0}", mexp.Member.GetType().Name));
            }
        }

        internal object LoadByType(Type memberType, ConfigUseAttribute memberData, IEnumerable<XElement> elements, string attrValue, Dictionary<string, string> extras)
        {
            foreach (IConfigType type in _types)
            {
                if (type.Handles(memberType))
                {
                    return type.Create(memberType, memberData, elements, attrValue, extras, this);
                }
            }

            throw new ConfigException(String.Format("The member {0} is of unhandled type {1}.", memberData.Name, memberType.Name));
        }

        internal IEnumerable<XElement> SaveByTypeAsElements(Type memberType, ConfigUseAttribute memberData, object value)
        {
            foreach (IConfigType type in _types)
            {
                if (type.Handles(memberType))
                {
                    return type.SerializeAsElements(memberType, memberData, value, this);
                }
            }

            throw new ConfigException(String.Format("The member {0} is of unhandled type {1}.", memberData.Name, memberType.Name));
        }

        internal string SaveByTypeAsString(Type memberType, ConfigUseAttribute memberData, object value)
        {
            foreach (IConfigType type in _types)
            {
                if (type.Handles(memberType))
                {
                    return type.SerializeAsString(memberType, memberData, value, this);
                }
            }

            throw new ConfigException(String.Format("The member {0} is of unhandled type {1}.", memberData.Name, memberType.Name));
        }

        internal void CheckUnusedNodes(string parentName, string unusedType, IEnumerable<string> unusedNames)
        {
            string unusedLoc = unusedType.Equals("element") ? "under" : "on";
            foreach (string name in unusedNames)
            {
                if (_options.MustUseAllValues)
                {
                    throw new ConfigException(String.Format("An unexpected {0} was found in the configuration {1} {2}: {3}", unusedType, unusedLoc, parentName, name));
                }
                else
                {
                    _logger.Trace(String.Format("Ignoring unexpected configuration {0} {1} {2}: {3}", unusedType, unusedLoc, parentName, name));
                }
            }
        }

        internal DirectoryInfo GetBaseDirectory()
        {
            return _options.BaseDirectory;
        }

        internal void EnsureDirExists(DirectoryInfo dir)
        {
            if (!dir.Exists)
            {
                if (_options.CreateMissingDirectories)
                {
                    dir.Create();
                    if (_options.OnDirectoryCreate != null)
                    {
                        _options.OnDirectoryCreate(dir);
                    }
                }
                else
                {
                    throw new ConfigException(String.Format("The directory {0} does not exist.", dir.FullName));
                }
            }
        }

        internal void CompletedLoad(ConfigSection config)
        {
            if (_options.RunPostInitialize)
            {
                config.PostInitialize(_options);
            }
        }

        internal void CompletedSave(ConfigSection config)
        {
            if (_options.RunPreFinalize)
            {
                config.PreFinalize(_options);
            }
        }

        internal bool EverythingOptional
        {
            get { return _options.EverythingOptional; }
        }

        internal string CheckForInclude(XElement element, bool allowed)
        {
            XAttribute attr = element.Attribute(INCLUDE_ATTRIBUTE);
            if (attr != null)
            {
                if (element.Attributes().Count() > 1 || element.Elements().Count() > 0)
                {
                    throw new ConfigException(String.Format("The element {0} has the {1} attribute, but it also has other attributes/children specified, which is wrong.", element.Name, INCLUDE_ATTRIBUTE));
                }

                if (!allowed)
                {
                    throw new ConfigException(String.Format("The element {0} has the {1} attribute, which is only allowed on members of type ConfigSection.", element.Name, INCLUDE_ATTRIBUTE));
                }

                return attr.Value;
            }

            return null;
        }

        internal XElement CreateIncludeElement(string name, string path)
        {
            return new XElement(name, new XAttribute(INCLUDE_ATTRIBUTE, path));
        }
    }
}
