using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;

namespace NRC.Miscellaneous
{
    /// <summary>
    /// Handle coniguration and runtime settings.
    /// </summary>
    public static class Settings
    {
        private static object lockObj = new object();

        /// <summary>
        /// Whether configuration file exists
        /// </summary>
        public static bool IsConfigurationPresent
        {
            get
            {
                return ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None).HasFile;
            }
        }

        /// <summary>
        /// Retrieves the setting value
        /// </summary>
        /// <param name="name">Name of the setting to read</param>
        /// <param name="default">Default value for setting. If the default value is used this value will be available going forward. The default value will need to be passed the first time the setting is read</param>
        public static string GetSetting(string name, string defaultValue)
        {
            var value = ConfigurationManager.AppSettings[name];
            if (value != null)
                return value;

            if (!string.IsNullOrEmpty(defaultValue))
            {
                lock (lockObj)
                {
                    SetSetting(name, defaultValue);
                }
                return defaultValue;
            }

            return string.Empty;
        }

        /// <summary>
        /// Either value for the name or empty string if not found.
        /// </summary>
        public static string GetSetting(string name)
        {
            return ConfigurationManager.AppSettings[name] ?? string.Empty;
        }

        /// <summary>
        /// Retrieves the setting value
        /// </summary>
        public static string[] GetArraySetting(string name)
        {
            if (name == null)
                throw new ArgumentNullException("name");
            if (name.Length == 0)
                throw new ArgumentOutOfRangeException("name");

            var value = ConfigurationManager.AppSettings[name];
            if (string.IsNullOrEmpty(value))
                return new string[0];

            return value.Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);
        }

        /// <summary>
        /// Get Dictionary Values of type string
        /// </summary>
        public static Dictionary<string, DateTime> GetDateDictionarySettings(string name, IEnumerable<KeyValuePair<string, DateTime>> defaultValues = null)
        {

            // convert default values, if any
            Dictionary<string, string> defaultValuesAsString = null;
            if ((defaultValues != null))
            {
                defaultValuesAsString = new Dictionary<string, string>();
                foreach (var kv in defaultValues)
                {
                    defaultValuesAsString.Add(kv.Key, FormatDateTime(kv.Value));
                }
            }

            // Get our Settings
            var valuesAsString = GetDictionarySettings(name, defaultValuesAsString);

            DateTime parsed;
            return valuesAsString
                .Select(kv => new KeyValuePair<string, DateTime>(kv.Key, DateTime.TryParse(kv.Value, out parsed) ? parsed : DateTime.MinValue))
                .ToDictionary(kv => kv.Key, kv => kv.Value);
        }

        /// <summary>
        /// Get Dictionary Values of type string
        /// </summary>
        public static Dictionary<string, string> GetDictionarySettings(string name, IEnumerable<KeyValuePair<string, string>> defaultValues = null)
        {
            var result = new Dictionary<string, string>();

            var prefix = name + ".";
            foreach (var key in ConfigurationManager.AppSettings.AllKeys)
            {
                if (key.StartsWith(prefix))
                {
                    result.Add(key.Substring(prefix.Length), ConfigurationManager.AppSettings[key]);
                }
                else if (key.Equals(name, StringComparison.CurrentCultureIgnoreCase))
                {
                    result.Add(name, ConfigurationManager.AppSettings[key]);
                }
            }

            if (defaultValues == null)
                return result;

            // if default values has something we don't have yet -- add to the result.
            foreach (var kv in defaultValues)
            {
                if (!result.ContainsKey(kv.Key))
                {
                    result.Add(kv.Key, kv.Value);
                }
            }

            return result;
        }

        /// <summary>
        /// Sets the value of a setting
        /// </summary>
        /// <param name="name">Name of the setting to write</param>
        /// <param name="Value">Value to write</param>
        public static void SetSetting(string name, string value)
        {
            lock (lockObj)
            {
                var conf = GetConfig();
                WriteValue(name, value, conf);
                conf.Save();
                ConfigurationManager.RefreshSection("appSettings");
            }
        }

        /// <summary>
        /// To set (and save) several settings at once, for efficiency.
        /// </summary>
        public static void SetMultipleSettings(IEnumerable<KeyValuePair<string, string>> values)
        {
            lock (lockObj)
            {
                var conf = GetConfig();
                foreach (var kv in values)
                {
                    WriteValue(kv.Key, kv.Value, conf);
                }
                conf.Save();
                ConfigurationManager.RefreshSection("appSettings");
            }
        }

        /// <summary>
        /// Sets the value of a setting
        /// </summary>
        public static void SetArraySetting(string name, string[] values)
        {
            var value = values == null ? string.Empty : string.Join(Environment.NewLine, values);
            SetSetting(name, value);
        }

        /// <summary>
        /// Saves DateTime dictionary values uniformly as a series of values prefixed with <paramref name="name"/>.
        /// </summary>
        public static void SetDictionarySettings(string name, IEnumerable<KeyValuePair<string, DateTime>> values)
        {
            var strDict = values.Select(kv => new KeyValuePair<string, string>(kv.Key, FormatDateTime(kv.Value)));
            SetDictionarySettings(name, strDict);
        }

        /// <summary>
        /// Saves dictionary values as a series of values prefixed with <paramref name="name"/>.
        /// </summary>
        public static void SetDictionarySettings(string name, IEnumerable<KeyValuePair<string, string>> values)
        {
            if (values.Count() == 1)
            {
                SetSetting(name, values.FirstOrDefault().Value);
            }
            else
            {
                SetMultipleSettings(values
                    .Select(kv => new KeyValuePair<string, string>(name + "." + kv.Key, kv.Value)));
            }
        }

        /// <summary>
        /// Pretty print all settings
        /// </summary>
        /// <returns></returns>
        new public static string ToString()
        {
            var sb = new StringBuilder();
            foreach (var key in ConfigurationManager.AppSettings.AllKeys)
            {
                sb.AppendFormat("{0}:\t{1}{2}", key, ConfigurationManager.AppSettings[key], Environment.NewLine);
            }

            return sb.ToString();
        }


        #region private

        /// <summary>
        /// Set a setting while guarding against an invalid name.
        /// </summary>
        /// <exception cref="ArgumentNullException" />
        /// <exception cref="ArgumentOutOfRangeException" />
        private static void WriteValue(string name, string value, Configuration conf)
        {
            if (name == null)
                throw new ArgumentNullException("name");
            if (name.Length == 0)
                throw new ArgumentOutOfRangeException("name");

            value = value ?? string.Empty;

            if (conf.AppSettings.Settings[name] == null)
                conf.AppSettings.Settings.Add(name, value);
            else
                conf.AppSettings.Settings[name].Value = value;
        }

        private static Configuration GetConfig()
        {
            return ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
        }

        private static string FormatDateTime(DateTime value)
        {
            return value.ToString("yyyy-MM-dd HH:mm:ss.ffff");
        }

        #endregion
    }
}

