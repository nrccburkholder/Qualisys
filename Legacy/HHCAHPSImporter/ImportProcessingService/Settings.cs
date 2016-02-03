using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

using ImportProcessor = HHCAHPSImporter.ImportProcessor;
using NRC.Common.Configuration;

namespace HHCAHPSImporter.ImportProcessingService
{
    public class Settings : ImportProcessor.Settings
    {
        [ConfigUse("IntervalSecs")]
        public int IntervalSecs { get; set; }

        [ConfigUse("IncomingDirectory")]
        public DirectoryInfo IncomingDirectory { get; set; }

        [ConfigUse("ZipQueueDirectory")]
        public DirectoryInfo ZipQueueDirectory { get; set; }

        [ConfigUse("ZipArchiveDirectory")]
        public DirectoryInfo ZipArchiveDirectory { get; set; }

        [ConfigUse("ZipFailureDirectory")]
        public DirectoryInfo ZipFailureDirectory { get; set; }

    }
}
