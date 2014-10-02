using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Common.Configuration
{
    /// <summary>
    /// An instance of this class can be passed to the <see cref="ConfigManager"/> class's Load methods to specify options on
    /// how to load and process the configuration information.
    /// </summary>
    public class ConfigOptions
    {
        /// <summary>
        /// The current (latest) version of the configuration file.
        /// </summary>
        public string CurrentVersion = "1.0.0";

        /// <summary>
        /// If true, unknown elements in the configuration file are errors rather than being ignored.
        /// </summary>
        public bool MustUseAllValues = false;

        /// <summary>
        /// If non-null, this method is run on the document before processing, taking the version of the document as an argument;
        /// the intent is that it will inspect the version and perform any necessary changes to the document to bring it up to the
        /// current version.
        /// </summary>
        public Action<XDocument, string> VersionTransformer = null;

        /// <summary>
        /// If non-null, relative directories and file paths are allowed in the configuration, and are taken as relative to
        /// this directory (and are expanded on read, and abbreviated on write, such that the configuration only has relative paths,
        /// but the object has absolute ones).
        /// </summary>
        public DirectoryInfo BaseDirectory;

        /// <summary>
        /// If true, DirectoryInfo/FileInfo values that refer to directories that don't exist will have those directories created;
        /// otherwise, having the directory not exist is an error.
        /// </summary>
        public bool CreateMissingDirectories = false;

        /// <summary>
        /// If defined, this action is called on a directory object when it is created (see <see cref="CreateMissingDirectories"/>).
        /// </summary>
        public Action<DirectoryInfo> OnDirectoryCreate = null;

        /// <summary>
        /// If true (the default), the PostInitialize function on the configuration objects will be run at the conclusion of object creation/assignment.
        /// </summary>
        public bool RunPostInitialize = true;

        /// <summary>
        /// If true (the default), the PreFinalize function on the configuration objects will be run immediately before object serialization.
        /// </summary>
        public bool RunPreFinalize = true;

        /// <summary>
        /// If true, all values are treated as having IsOptional set -- that is, the default value will always be used if there is one. Generally this
        /// should only be set during initial creation of the configuration file.
        /// </summary>
        public bool EverythingOptional = false;

        public ConfigOptions()
        {
        }
    }
}
