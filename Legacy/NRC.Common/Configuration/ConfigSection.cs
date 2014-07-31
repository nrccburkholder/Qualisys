using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common.Configuration
{
    /// <summary>
    /// All configuration classes that are to be loaded by <see cref="ConfigManager"/> should be of this type (including ones corresponding to 
    /// nested configuration sections). See <see cref="ConfigManager"/> for more details on use.
    /// </summary>
    abstract public class ConfigSection
    {
        /// <summary>
        /// This method is called once this configuration object and its children have all been loaded; you can use it to build up other data structures using
        /// the loaded data, or to register the object somewhere.
        /// </summary>
        virtual public void PostInitialize(ConfigOptions options) { }

        /// <summary>
        /// This method is called immediately before this configuration object and its children are serialized; you can use it to transform object data into
        /// some easier-to-serialize form, or perhaps unregister the object.
        /// </summary>
        virtual public void PreFinalize(ConfigOptions options) { }

        /// <summary>
        /// If set, this indicates this object was loaded from (and hence should be saved to) a file with the given relative path to the base directory
        /// </summary>
        public string IncludePath { get; set; }
    }
}
