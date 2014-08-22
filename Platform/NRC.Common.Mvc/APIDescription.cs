using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;

namespace NRC.Common.Mvc
{
    public class APIDescription
    {
        public APIDescription(Dictionary<string, MethodInfo> methods, Dictionary<string, APIMethodAttribute> methodData, APIService service,
            Func<string, bool> hideParam)
        {
            Methods = methods.Keys.Select(a => DescribeSingleMethod(methods[a], methodData[a], service, hideParam)).OrderBy(a => a.Name).ToList();
        }

        public List<MethodDescription> Methods { get; set; }

        private MethodDescription DescribeSingleMethod(MethodInfo method, APIMethodAttribute methodData, APIService service, Func<string, bool> hideParam)
        {
            MethodDescription ret = new MethodDescription();
            ret.Name = method.Name;
            ret.Description = methodData.Description;
            ret.ReturnType = FormatType(method.ReturnType);
            ret.SampleReturn = SerializeSample(service.GetSampleForType(method.ReturnType));
            ret.Parameters = new List<ParameterDescription>();

            foreach (ParameterInfo p in method.GetParameters())
            {
                if (hideParam(p.Name))
                {
                    continue;
                }

                ParameterDescription param = new ParameterDescription();
                param.Name = p.Name;
                param.Description = service.GetDescriptionForParameter(method.Name, p.Name);
                param.Type = FormatType(p.ParameterType);
                param.Sample = SerializeSample(service.GetSampleForParameter(method.Name, p.Name));
                ret.Parameters.Add(param);
            }

            return ret;
        }

        private string FormatType(Type type)
        {
            if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Nullable<>))
            {
                return FormatType(type.GetGenericArguments()[0]) + " (optional)";
            }
            else if (type.IsGenericType && (type.GetGenericTypeDefinition() == typeof(List<>) || type.GetGenericTypeDefinition() == typeof(IEnumerable<>)))
            {
                return "list of " + FormatType(type.GetGenericArguments()[0]);
            }
            else if (type == typeof(Stream))
            {
                return "a file attached to the request";
            }
            else if (type.IsEnum)
            {
                return "a value from " + String.Join(", ", Enum.GetNames(type));
            }
            else if (type.IsPrimitive || type == typeof(DateTime))
            {
                return Regex.Replace(type.Name.ToLower(), @".*\.", "");
            }
            else
            {
                return Regex.Replace(type.Name, @".*\.", "");
            }
        }

        private string SerializeSample(object sample)
        {
            return (sample == null) ? null : new JavaScriptSerializer().Serialize(sample);
        }
    }

    public class MethodDescription
    {
        public string Name;
        public string Description;
        public string ReturnType;
        public string SampleReturn;
        public List<ParameterDescription> Parameters;
    }

    public class ParameterDescription
    {
        public string Name;
        public string Description;
        public string Type;
        public string Sample;
    }
}
