using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRC.Common.Configuration;

namespace NRC.Platform.FileCopyService
{
    class Configuration : ConfigSection
    {
        [ConfigUse("ServiceName")]
        public string serviceName = "NRC.Platform.FileCopyService";

        [ConfigUse("IntervalSecs")]
        public int intervalSecs = 60;

        [ConfigUse("DirectorySyncTask")]
        public List<DirectorySyncTask> dirsToMove = new List<DirectorySyncTask>();
    }
}
