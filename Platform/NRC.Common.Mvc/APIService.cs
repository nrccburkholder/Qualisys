using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NRC.Common.Mvc
{
    public class APIService
    {
        private static Dictionary<Type, object> _typeSamples = new Dictionary<Type, object>();
        private static Dictionary<string, string> _paramDescriptions = new Dictionary<string, string>();
        private static Dictionary<string, object> _paramSamples = new Dictionary<string, object>();

        public void SetSampleForType(Type type, object sample)
        {
            _typeSamples[type] = sample;
        }

        public object GetSampleForType(Type type)
        {
            if (_typeSamples.ContainsKey(type))
            {
                return _typeSamples[type];
            }

            if (type.IsGenericType && (type.GetGenericTypeDefinition() == typeof(List<>) || type.GetGenericTypeDefinition() == typeof(IEnumerable<>)))
            {
                object innerSample = GetSampleForType(type.GetGenericArguments()[0]);
                if (innerSample != null)
                {
                    // ok to return a List<object> here, since it's just going to be serialized; it doesn't have to be the exact type of list
                    List<object> lst = new List<object>();
                    lst.Add(innerSample);
                    return lst;
                }
            }

            return null;
        }

        public void SetParameter(string parameter, string description, object sample)
        {
            SetParameter(null, parameter, description, sample);
        }

        public void SetParameter(string method, string parameter, string description, object sample)
        {
            _paramDescriptions[(method == null) ? parameter : method + "." + parameter] = description;
            _paramSamples[(method == null) ? parameter : method + "." + parameter] = sample;
        }

        public string GetDescriptionForParameter(string method, string parameter)
        {
            string exact = method + "." + parameter;
            if (_paramDescriptions.ContainsKey(exact))
            {
                return _paramDescriptions[exact];
            }
            return _paramDescriptions.ContainsKey(parameter) ? _paramDescriptions[parameter] : null;
        }

        public object GetSampleForParameter(string method, string parameter)
        {
            string exact = method + "." + parameter;
            if (_paramSamples.ContainsKey(exact))
            {
                return _paramSamples[exact];
            }
            return _paramSamples.ContainsKey(parameter) ? _paramSamples[parameter] : null;
        }
    }
}
