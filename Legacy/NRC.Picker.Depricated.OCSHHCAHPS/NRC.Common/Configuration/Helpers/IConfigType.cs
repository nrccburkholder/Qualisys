using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace NRC.Common.Configuration.Helpers
{
    interface IConfigType
    {
        bool Handles(Type memberType);
        object Create(Type memberType, ConfigUseAttribute memberData, IEnumerable<XElement> elements, string attrValue, Dictionary<string, string> extras, ConfigHelper helper);
        string SerializeAsString(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper);
        IEnumerable<XElement> SerializeAsElements(Type memberType, ConfigUseAttribute memberData, object value, ConfigHelper helper);
    }
}
