using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NRC.Picker.PCLGenWatchdog.RemoteMonitoringService
{
    public class Status
    {
        public string ServerName { get; set; }
        public DateTime LastStatusCheck { get; set; }
        public bool IsPCLGenRunning { get; set; }
        public bool ErrorsDetected { get; set; }
        public string UnhandledErrorReason { get; set; }
        public DateTime LastRestartOfPCLGen { get; set; }
        public string LastRestartReason { get; set; }
        public string PrinterStatus { get; set; }
        public string LogWindowText { get; set; }
    }
}