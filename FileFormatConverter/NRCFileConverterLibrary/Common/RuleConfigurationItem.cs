using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NRCFileConverterLibrary.Common
{
    /// <summary>
    ///This class holds the configuration information required for File conversion.
    /// </summary>
    public class RuleConfigurationItem
    {
        /// <summary>
        /// Name of the rule.
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// The input file type(s). Multiple file type are seperated bet '|.'
        /// </summary>
        public string FileType { get; set; }
        /// <summary>
        /// The Provider used by this Rule.
        /// </summary>
        public string Provider { get; set; }
        /// <summary>
        /// This is the input path for the app to watch. Once a file is dropped the file is processed.
        /// </summary>
        public string InputPath { get; set; }
        /// <summary>
        /// This is holding location for the files being processed.
        /// </summary>
        public string InProcessPath { get; set; }
        /// <summary>
        /// Once the processing is done the original file is moved to this folders for Archiving.
        /// </summary>
        public string ArchivePath { get; set; }
        /// <summary>
        /// This points to the primary keycolumn name.
        /// </summary>
        public string PrimaryKey { get; set; }
        /// <summary>
        /// This location where the output file is created.
        /// </summary>
        public string OutPath { get; set; }

    }
}
