using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

using NRC.Common.Configuration;

namespace NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor
{
    public class Settings : ConfigSection
    {
        [ConfigUse("UploadQueueDirectory")]
        public DirectoryInfo UploadQueueDirectory { get; set; }

        [ConfigUse("ImportQueueDirectory")]
        public DirectoryInfo ImportQueueDirectory { get; set; }

        [ConfigUse("AbandonedUploadsDirectory")]
        public DirectoryInfo AbandonedUploadsDirectory { get; set; }

        [ConfigUse("UploadFailureDirectory")]
        public DirectoryInfo UploadFailureDirectory { get; set; }

        [ConfigUse("ClientsDirectory")]
        public DirectoryInfo ClientsDirectory { get; set; }

        [ConfigUse("QP_DataLoadConnectionString")]
        public string QP_DataLoadConnectionString { get; set; }

        [ConfigUse("SaveXMLFiles", Default="true")]
        public bool SaveXMLFiles { get; set; }

        [ConfigUse("AddressCleanerPath", Default = @"C:\Program Files (x86)\QualiSys\Address Cleaner\AddressCleaner.exe")]
        public string AddressCleanerPath { get; set; }
    }

}
