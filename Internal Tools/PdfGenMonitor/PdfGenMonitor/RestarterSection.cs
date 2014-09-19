using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace PdfGenMonitor
{
    public sealed class RestarterSection : ConfigurationSection
    {
        [ConfigurationProperty("monitoredLogFilePath", DefaultValue = "C:\\PDFGen\\PDFGen.log", IsRequired = true)]
        public string MonitoredLogFilePath
        {
            get 
            { 
                return (string)this["monitoredLogFilePath"]; 
            }
            set
            {
                this["monitoredLogFilePath"] = value;
            }
        }

        [ConfigurationProperty("maxLogFileAgeAllowed", DefaultValue = "120", IsRequired = true)]
        public int MaxLogFileAgeAllowed
        {
            get 
            { 
                return (int)this["maxLogFileAgeAllowed"]; 
            }
            set
            {
                this["maxLogFileAgeAllowed"] = value;
            }
        }

        [ConfigurationProperty("terminatedProcessName", DefaultValue = "PDFGen", IsRequired = true)]
        public string TerminatedProcessName
        {
            get 
            {
                return (string)this["terminatedProcessName"]; 
            }
            set
            {
                this["terminatedProcessName"] = value;
            }
        }

        [ConfigurationProperty("restartedApplicationPath", DefaultValue = "C:\\PDFGen\\PDFGen.exe", IsRequired = true)]
        public string RestartedApplicationPath
        {
            get 
            { 
                return (string)this["restartedApplicationPath"]; 
            }
            set
            {
                this["restartedApplicationPath"] = value;
            }
        }

        [ConfigurationProperty("logFileDestinationPath", DefaultValue = "C:\\PDFGenMonitor\\Logs", IsRequired = true)]
        public string LogFileDestinationPath
        {
            get 
            {
                string path = (string)this["logFileDestinationPath"];
                return path.TrimEnd(new[] { '\\' });
            }
            set
            {
                this["logFileDestinationPath"] = value.TrimEnd(new[] { '\\' });
            }
        }
    }
}
