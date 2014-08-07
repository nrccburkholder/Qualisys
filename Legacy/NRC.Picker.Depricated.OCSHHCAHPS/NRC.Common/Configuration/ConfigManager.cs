using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Xml;
using System.Xml.Linq;

using NRC.Common.Configuration.Helpers;

namespace NRC.Common.Configuration
{
    /// <summary>
    /// This is the primary configuration reading and writing class for NRC applications. In general, you should use <see cref="Load"/>, which reads from a settings.xml file 
    /// in the same directory as the executable.
    /// </summary>
    public abstract class ConfigManager
    {
        private static Logger _logger = Logger.GetLogger();

        public static string GetDefaultConfigFile()
        {
            string dir = null;

            // We use reflection here to avoid requiring this library include System.Web (which is part of the full install but
            // not the client profile, which means that any projects that include this have to switch to be the full install
            // instead of the client profile and it's just a hassle).
            // Instead, we try to load the type, and if it doesn't exist, we didn't want it anyway (we must not be part of a web server).
            try
            {
                foreach (string version in new string[] { "4.0.0.0", "2.0.0.0" })
                {
                    Type envType = Type.GetType(String.Format("System.Web.Hosting.HostingEnvironment, System.Web, Version={0}, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", version));
                    if (envType != null)
                    {
                        PropertyInfo prop = envType.GetProperty("ApplicationPhysicalPath");
                        dir = (string)prop.GetValue(null, null);
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.Trace(String.Format("Error loading HostingEnvironment.ApplicationPhysicalPath: {0}", ex.Message));
            }

            if (dir == null)
            {
                dir = new FileInfo(Assembly.GetExecutingAssembly().Location).DirectoryName;
            }

            return Path.Combine(dir, "settings.xml");
        }

        public static T Load<T>() where T : ConfigSection, new()
        {
            string config = GetDefaultConfigFile();
            return LoadFromFile<T>(config, new ConfigOptions { BaseDirectory = new FileInfo(config).Directory });
        }

        public static T Load<T>(ConfigOptions options) where T : ConfigSection, new()
        {
            return LoadFromFile<T>(GetDefaultConfigFile(), options);
        }

        public static T LoadFromString<T>(string text, ConfigOptions options) where T : ConfigSection, new()
        {
            return LoadFromString<T>(text, typeof(T), options);
        }

        public static T LoadFromString<T>(string text, Type configType, ConfigOptions options) where T : ConfigSection, new()
        {
            XDocument doc;
            try
            {
                _logger.Trace(String.Format("Loading configuration from string of {0} bytes", text.Length));
                doc = XDocument.Load(new StringReader(text));
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("Error creating configuration reader from string: {0}", ex.Message), ex);
            }

            ConfigHelper helper = new ConfigHelper(options);
            return helper.LoadFromDocument<T>(configType, doc, new Dictionary<string, string>());
        }

        public static T LoadFromFile<T>(string filename, ConfigOptions options) where T : ConfigSection, new()
        {
            XDocument doc;
            try
            {
                _logger.Trace(String.Format("Loading configuration from file: {0}", filename));
                doc = XDocument.Load(filename);
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("Error creating configuration reader from file: {0}", ex.Message), ex);
            }

            ConfigHelper helper = new ConfigHelper(options);
            return helper.LoadFromDocument<T>(typeof(T), doc, new Dictionary<string, string>());
        }

        public static T LoadFromStream<T>(Stream str, ConfigOptions options) where T : ConfigSection, new()
        {
            XDocument doc;
            try
            {
                _logger.Trace(String.Format("Loading configuration from stream"));
                doc = XDocument.Load(XmlReader.Create(str));
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("Error creating configuration reader from stream: {0}", ex.Message), ex);
            }

            ConfigHelper helper = new ConfigHelper(options);
            return helper.LoadFromDocument<T>(typeof(T), doc, new Dictionary<string, string>());
        }

        public static T LoadFromValues<T>(Dictionary<string, string> values, ConfigOptions options) where T : ConfigSection, new()
        {
            _logger.Trace(String.Format("Creating default configuration"));
            ConfigHelper helper = new ConfigHelper(options);
            return helper.LoadFromDocument<T>(typeof(T), null, values);
        }

        public static T LoadFromTemplate<T>(string filename, Dictionary<string, string> values, ConfigOptions options) where T : ConfigSection, new()
        {
            XDocument doc;
            try
            {
                _logger.Trace(String.Format("Loading configuration from template file: {0}", filename));
                doc = XDocument.Load(filename);
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("Error creating configuration reader from file: {0}", ex.Message), ex);
            }
            ConfigHelper helper = new ConfigHelper(options);
            return helper.LoadFromDocument<T>(typeof(T), doc, values);
        }

        public static void Save(ConfigSection config)
        {
            Save(config, new ConfigOptions());
        }

        public static void Save(ConfigSection config, ConfigOptions options)
        {
            SaveToFile(config, GetDefaultConfigFile(), options);
        }

        public static string SaveToString(ConfigSection config, ConfigOptions options)
        {
            try
            {
                _logger.Trace(String.Format("Saving configuration to string"));
                ConfigHelper helper = new ConfigHelper(options);
                XDocument doc = helper.SaveToDocument(config);

                using (StringWriter writer = new StringWriter())
                {
                    doc.Save(writer, SaveOptions.None);
                    return writer.ToString();
                }
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("Error writing configuration to string: {0}", ex.Message), ex);
            }
        }

        public static void SaveToFile(ConfigSection config, string filename, ConfigOptions options)
        {
            try
            {
                _logger.Trace(String.Format("Saving configuration to file"));
                ConfigHelper helper = new ConfigHelper(options);
                XDocument doc = helper.SaveToDocument(config);

                using (StreamWriter writer = new StreamWriter(File.Open(filename, FileMode.Create), new UTF8Encoding(false))) 
                {
                    doc.Save(writer, SaveOptions.None);
                }
            }
            catch (Exception ex)
            {
                throw new ConfigException(String.Format("Error writing configuration to file: {0}", ex.Message), ex);
            }
        }

        /// <summary>
        /// This method can be called to set a member on a <see cref="ConfigSection"/> object to a string value in a safe way: it takes in the string
        /// value, converts it to the appropriate type, checks to make sure it's valid (eg, if assigning to a directory, it ensures the path exists, or 
        /// creates it if that's how the options are set). Syntax to use it is like:
        ///    ConfigManager.AssignValue(() => config.SomeDouble, "83.7");
        /// Note that you don't have to specify the template type T; the compiler can intuit it.
        /// </summary>
        public static void CheckedAssign<T>(Expression<Func<T>> target, string value, ConfigOptions options)
        {
            ConfigHelper helper = new ConfigHelper(options);
            helper.CheckedAssign<T>(target, value);
        }

        /// <summary>
        /// See comments on <see cref="CheckedAssign"/> for how to call this. Returns the member, serialized as a string in config file format (so 
        /// paths are converted to relative if possible, etc).
        /// </summary>
        public static string CheckedRead<T>(Expression<Func<T>> target, ConfigOptions options)
        {
            ConfigHelper helper = new ConfigHelper(options);
            return helper.CheckedRead<T>(target);
        }
    }
}
