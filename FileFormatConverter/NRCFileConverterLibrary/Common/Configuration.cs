using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRCFileConverterLibrary.Common
{
    public class ConfigurationArgs : EventArgs
    {
        public string Converter { get; set; }
        public string WatchPatch { get; set; }
        public string InProcessPatch { get; set; }
        public string ArchivePatch { get; set; }
        public string NotificationList { get; set; }
    }
}
