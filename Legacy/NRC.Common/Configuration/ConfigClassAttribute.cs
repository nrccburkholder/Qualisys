using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common.Configuration
{
    /// <summary>
    /// This acts like the <see cref="ConfigUseAttribute"/> class, but applies to the top-level object when reading/serializing. The name value of this class, if
    /// set, specifies the name of the root element in the configuration file.
    /// </summary>
    [AttributeUsage(AttributeTargets.Class)]
    public class ConfigClassAttribute : ConfigUseAttribute
    {
        public ConfigClassAttribute()
        {
        }

        public ConfigClassAttribute(string name)
        {
            this.Name = name;
        }
    }
}
