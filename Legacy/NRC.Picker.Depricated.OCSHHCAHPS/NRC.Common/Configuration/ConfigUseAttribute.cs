using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common.Configuration
{
    public enum XmlType { Any, Element, Attribute, Text };

    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property)]
    public class ConfigUseAttribute: Attribute, ICloneable
    {
        /// <summary>
        /// The name of this element in the configuration file.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Whether the element can be left out of the configuration file. If this is true, then the <see cref="Default"/> property must be set (non-null) also.
        /// </summary>
        public bool IsOptional { get; set; }

        /// <summary>
        /// The default value for this element, used in two situations: when a configuration file is created from scratch, and when the element
        /// <see cref="IsOptional"/> and is not supplied in the configuration file.
        /// </summary>
        public string Default { get; set; }

        /// <summary>
        /// If set, this refers to the name of nested children within the corresponding configuration element. Currently it is only useful (and only used)
        /// when the member is of type List<>, and the configuration is written like this:
        /// 
        ///   <foo>some other element</foo>
        ///   <enclosing>
        ///     <string>value</string>
        ///     <string>value</string>
        ///     <string>value</string>
        ///   </enclosing>
        ///   
        /// rather than like
        ///   
        ///   <foo>some other element</foo>
        ///   <string>value</string>
        ///   <string>value</string>
        ///   <string>value</string>
        ///   
        /// To parse the former xml, you will want to define this attribute like
        ///   [ConfigUseAttribute(Name="enclosing", ChildName="string")]
        /// </summary>
        public string ChildName { get; set; }

        /// <summary>
        /// If MultipleNames is set on an object member, this indicates the names of the member may be any of the
        /// specified array, ignoring its name property (the name property is still required and used for internal
        /// display purposes). If MultipleNames is set on a list member, this indicates the names of the list items
        /// may be any of the specified array (if ChildName is set, it is still considered to be a nested list,
        /// but the value of ChildName is ignored).
        /// </summary>
        public string[] MultipleNames { get; set; }

        /// <summary>
        /// The expected type of the member in xml (element, attribute, or text). Currently this only affects how the config file is serialized, not how it's parsed.
        /// </summary>
        public XmlType XmlType { get; set; }

        /// <summary>
        /// If set, and the xml provides no value for this item when loading it, then the extras hash will be checked using this name.
        /// </summary>
        public string ExtraName { get; set; }

        /// <summary>
        /// If true, then an instance of this element will be created even when there is no section for it in the xml (this is only useful for objects and lists, to 
        /// let them create the object with children that have default values).
        /// </summary>
        public bool CreateAlways { get; set; }

        /// <summary>
        /// If true, then this element (if an object type) or the children of this element (if a list type) are expected to provide the customType attribute
        /// to specify the actual type to use (which must inherit from the one specified on the object for this element).
        /// </summary>
        public bool CustomType { get; set; }

        /// <summary>
        /// If MultipleNames is specified, you may also specify this attribute to give a corresponding type for each name -- the types must
        /// be a valid subclass of the type the member is declared with.
        /// </summary>
        public Type[] MultipleTypes { get; set; }

        public ConfigUseAttribute()
        {
        }

        public ConfigUseAttribute(string name)
        {
            this.Name = name;
        }

        // just does a shallow copy, but that's fine, everything on this class is value types
        public object Clone()
        {
            return this.MemberwiseClone();
        }
    }
}
