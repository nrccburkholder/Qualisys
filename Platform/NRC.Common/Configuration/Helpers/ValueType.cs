using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace NRC.Common.Configuration.Helpers
{
    internal class ValueType : IConfigType
    {
        private static Dictionary<Type, Func<string, ConfigUseAttribute, ConfigHelper, object>> _creators = new Dictionary<Type, Func<string, ConfigUseAttribute, ConfigHelper, object>>();
        private static Dictionary<Type, Func<object, ConfigUseAttribute, ConfigHelper, string>> _serializers = new Dictionary<Type, Func<object, ConfigUseAttribute, ConfigHelper, string>>();

        public static readonly Regex _macroRegex = new Regex(@"###(.*?)###", RegexOptions.Singleline);

        public ValueType()
        {
            InitializeConverters();
        }

        public bool Handles(Type memberType)
        {
            return _creators.ContainsKey(memberType) || memberType.IsEnum;
        }

        public object Create(Type memberType, ConfigUseAttribute memberData, IEnumerable<XElement> elements, string attrValue, Dictionary<string, string> extras, ConfigHelper helper)
        {
            string value = null;

            if (elements != null)
            {
                if (elements.Count() != 1)
                {
                    throw new ConfigException(String.Format("The element {0} is configured to only appear one time.", memberData.Name));
                }

                XElement element = elements.FirstOrDefault();
                helper.CheckForInclude(element, false);

                Match m = _macroRegex.Match(element.Value);
                if (m.Success)
                {
                    value = extras[m.Groups[1].Value];
                }
                else
                {
                    value = element.Value;
                }
            }
            else if (attrValue != null)
            {
                value = attrValue;
            }
            else if (memberData.ExtraName != null && extras.ContainsKey(memberData.ExtraName))
            {
                value = extras[memberData.ExtraName];
            }

            if (String.IsNullOrEmpty(value))
            {
                if ((memberData.IsOptional || helper.EverythingOptional) && (memberData.Default != null))
                {
                    value = memberData.Default;
                }
                else
                {
                    throw new ConfigException(String.Format("The member {0} is not optional, but has no value set in the configuration.", memberData.Name));
                }
            }

            value = String.IsNullOrEmpty(value) ? "" : value.Trim();

            try
            {
                return (memberType.IsEnum) ? Enum.Parse(memberType, value, true) : _creators[memberType](value, memberData, helper);
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("An error occurred parsing {0}: {1}", value, ex.Message));
            }
        }

        public IEnumerable<XElement> SerializeAsElements(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper)
        {
            return new XElement[] { new XElement(memberData.Name, new XText(SerializeAsString(memberType, memberData, value, helper))) };
        }

        public string SerializeAsString(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper)
        {
            return memberType.IsEnum ? value.ToString() : _serializers[memberType](value, memberData, helper);
        }

        private void InitializeConverters()
        {
            _creators[typeof(string)] = ((a, m, o) => a);
            _creators[typeof(bool)] = ((a, m, o) => Boolean.Parse(a));
            _creators[typeof(DateTime)] = ((a, m, o) => DateTime.Parse(a));
            _creators[typeof(int)] = ((a, m, o) => Int32.Parse(a));
            _creators[typeof(short)] = ((a, m, o) => Int16.Parse(a));
            _creators[typeof(long)] = ((a, m, o) => Int64.Parse(a));
            _creators[typeof(float)] = ((a, m, o) => Single.Parse(a));
            _creators[typeof(double)] = ((a, m, o) => Double.Parse(a));
            _creators[typeof(decimal)] = ((a, m, o) => Decimal.Parse(a));
            _creators[typeof(DirectoryInfo)] = ParseDirectory;
            _creators[typeof(FileInfo)] = ParseFile;
            _creators[typeof(Uri)] = ParseUri;
            _creators[typeof(Version)] = ((a, m, o) => String.IsNullOrEmpty(a) ? null : new Version(a));

            _serializers[typeof(string)] = ((a, m, o) => a == null ? "" : (string)a);
            _serializers[typeof(bool)] = ((a, m, o) => ((bool)a).ToString().ToLower());
            _serializers[typeof(DateTime)] = ((a, m, o) => ((DateTime)a).ToString("r"));
            _serializers[typeof(int)] = ((a, m, o) => ((int)a).ToString());
            _serializers[typeof(short)] = ((a, m, o) => ((short)a).ToString());
            _serializers[typeof(long)] = ((a, m, o) => ((long)a).ToString());
            _serializers[typeof(float)] = ((a, m, o) => ((float)a).ToString());
            _serializers[typeof(double)] = ((a, m, o) => ((double)a).ToString());
            _serializers[typeof(decimal)] = ((a, m, o) => ((decimal)a).ToString());
            _serializers[typeof(DirectoryInfo)] = StringifyPath;
            _serializers[typeof(FileInfo)] = StringifyPath;
            _serializers[typeof(Uri)] = ((a, m, o) => a == null ? "" : a.ToString());
            _serializers[typeof(Version)] = ((a, m, o) => a == null ? "" : a.ToString());
        }

        private static DirectoryInfo ParseDirectory(string value, ConfigUseAttribute memberData, ConfigHelper helper)
        {
            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            DirectoryInfo basedir = helper.GetBaseDirectory();
            string path = basedir != null ? Path.Combine(basedir.FullName, value) : value;
            DirectoryInfo ret = new DirectoryInfo(path);
            helper.EnsureDirExists(ret);
            return ret;
        }

        private static FileInfo ParseFile(string value, ConfigUseAttribute memberData, ConfigHelper helper)
        {
            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            DirectoryInfo basedir = helper.GetBaseDirectory();
            string path = basedir != null ? Path.Combine(basedir.FullName, value) : value;
            FileInfo ret = new FileInfo(path);
            helper.EnsureDirExists(ret.Directory);
            return ret;
        }

        private static Uri ParseUri(string value, ConfigUseAttribute memberData, ConfigHelper helper)
        {
            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            return new Uri(value);
        }

        private static string StringifyPath(object o, ConfigUseAttribute memberData, ConfigHelper helper)
        {
            if (o == null)
            {
                return "";
            }

            FileSystemInfo path = o as FileSystemInfo;
            if (path == null)
            {
                throw new ConfigException(String.Format("Path object is of unexpected type {0}", o.GetType().Name));
            }

            DirectoryInfo basedir = helper.GetBaseDirectory();
            if (basedir == null || !path.FullName.StartsWith(basedir.FullName))
            {
                return path.FullName;
            }
            else
            {
                string name = path.FullName.Replace(basedir.FullName, "");
                if (name.StartsWith("\\"))
                {
                    name = name.Substring(1);
                }
                return name;
            }
        }
    }
}
