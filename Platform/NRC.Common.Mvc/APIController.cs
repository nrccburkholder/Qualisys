using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

using Failure = NRC.Common.Web.Failure;
using FailureType = NRC.Common.Web.FailureType;
using IPTranslator = NRC.Common.Networking.IPTranslator;

namespace NRC.Common.Mvc
{
    public class APIController<T> : Controller where T : APIService, new()
    {
        protected const string USER_IP_PARAM = "remoteIP";

        protected static readonly Logger _logger = Logger.GetLogger();
        protected static readonly T _service = new T();
        protected static Dictionary<string, MethodInfo> _methods = new Dictionary<string, MethodInfo>();
        protected static Dictionary<string, APIMethodAttribute> _methodData = new Dictionary<string, APIMethodAttribute>();
        protected static Dictionary<Type, Func<string, HttpRequestBase, object>> _parsers = new Dictionary<Type, Func<string, HttpRequestBase, object>>();

        static APIController()
        {
            foreach (MethodInfo method in typeof(T).GetMethods())
            {
                if (!method.DeclaringType.IsSubclassOf(typeof(APIService)))
                {
                    continue;
                }

                APIMethodAttribute methodData = (APIMethodAttribute)(method.GetCustomAttributes(typeof(APIMethodAttribute), false).FirstOrDefault());
                if (methodData == null)
                {
                    _logger.Trace(String.Format("No {0} attribute specified for method {1}, not doing anything.", typeof(APIMethodAttribute).Name, method.Name));
                    continue;
                }

                _methods[method.Name] = method;
                _methodData[method.Name] = methodData;
            }

            _parsers[typeof(string)] = ((a, r) => a);
            _parsers[typeof(bool)] = ((a, r) => Boolean.Parse(a));
            _parsers[typeof(DateTime)] = ((a, r) => DateTime.Parse(a));
            _parsers[typeof(int)] = ((a, r) => Int32.Parse(a));
            _parsers[typeof(short)] = ((a, r) => Int16.Parse(a));
            _parsers[typeof(long)] = ((a, r) => Int64.Parse(a));
            _parsers[typeof(float)] = ((a, r) => Single.Parse(a));
            _parsers[typeof(double)] = ((a, r) => Double.Parse(a));
            _parsers[typeof(decimal)] = ((a, r) => Decimal.Parse(a));
            _parsers[typeof(Guid)] = ((a, r) => Guid.Parse(a));
            _parsers[typeof(Stream)] = ((a, r) => (r.Files != null && r.Files.Count > 0) ? r.Files[0].InputStream : null);
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult Translate(string method)
        {
            try
            {
                if (!_methods.ContainsKey(method))
                {
                    throw new UserException(String.Format("Unknown api method: {0}", method));
                }

                MethodInfo methodObj = _methods[method];
                List<object> args = new List<object>();
                foreach (ParameterInfo p in methodObj.GetParameters())
                {
                    if (p.Name.Equals(USER_IP_PARAM))
                    {
                        args.Add(IPTranslator.Translate(Request.UserHostAddress));
                    }
                    else if (p.ParameterType.IsGenericType && p.ParameterType.GetGenericTypeDefinition() == typeof(Dictionary<,>))
                    {
                        args.Add(ParseDictionaryType(p));
                    }
                    else if (p.ParameterType.IsGenericType && p.ParameterType.GetGenericTypeDefinition() == typeof(Nullable<>))
                    {
                        args.Add(ParseNullableType(p));
                    }
                    else
                    {
                        args.Add(ParseType(p.ParameterType, p.Name));
                    }
                }

                // Use the newtonsoft serializer here so we can get more control over how it's serialized; specifically, so
                // we can force it to serialize enums as strings instead of ints
                ContentResult ret = new ContentResult();
                ret.ContentType = "application/json";
                List<JsonConverter> cvts = new List<JsonConverter>();
                cvts.Add(new StringEnumConverter());
                ret.Content = JsonConvert.SerializeObject(methodObj.Invoke(_service, args.ToArray()), Formatting.Indented, new JsonSerializerSettings { Converters = cvts });
                return ret;
            }
            catch (Exception exRaw)
            {
                return Json(HandleException(exRaw));
            }
        }

        private object ParseDictionaryType(ParameterInfo param)
        {
            string value = Request.Form.Get(param.Name);

            if (String.IsNullOrEmpty(value))
            {
                return null;
            }

            try
            {
                return JsonConvert.DeserializeObject(value, param.ParameterType, new JsonSerializerSettings { MissingMemberHandling = MissingMemberHandling.Error });
            }
            catch (Exception)
            {
                var args = param.ParameterType.GetGenericArguments();
                throw new UserException(String.Format("The parameter {0} must be a dictionary of type {1} => {2}.", param.Name, args[0].Name.ToLower(), args[1].Name.ToLower()));
            }
        }

        private object ParseNullableType(ParameterInfo param)
        {
            if (String.IsNullOrEmpty(Request.Form.Get(param.Name)))
            {
                return null;
            }

            Type genericArg = (param.ParameterType.GetGenericArguments())[0]; // if memberType is Nullable<X>, genericArg is X

            return Activator.CreateInstance(param.ParameterType, new object[] { ParseType(genericArg, param.Name) });
        }

        private object ParseType(Type type, string name)
        {
            if (_parsers.ContainsKey(type))
            {
                try
                {
                    return _parsers[type](Request.Form.Get(name) ?? "", Request);
                }
                catch (Exception)
                {
                    throw new UserException(String.Format("The parameter {0} must be of type {1}.", name, type.Name.ToLower()));
                }
            }
            else if (type.IsEnum)
            {
                try
                {
                    return Enum.Parse(type, Request.Form.Get(name), true);
                }
                catch (Exception)
                {
                    // fallback: try it as a number:
                    try
                    {
                        int num = Int32.Parse(Request.Form.Get(name));
                        return Convert.ChangeType(num, type);
                    }
                    catch (Exception)
                    {
                        throw new UserException(String.Format("The parameter {0} must have one of the following values: {1}.", name, String.Join(", ", Enum.GetNames(type))));
                    }
                }
            }
            else
            {
                throw new Exception(String.Format("The parameter {0} is of unknown type {1}.", name, type.Name));
            }
        }

        private Failure HandleException(Exception ex)
        {
            if (ex.GetType() == typeof(TargetInvocationException) && ex.InnerException != null)
            {
                ex = ex.InnerException;
            }

            if (ex.GetType() == typeof(UserException))
            {
                return new Failure(ex.Message, FailureType.External);
            }
            else
            {
                _logger.Error(String.Format("An unexpected error occurred in the REST API: {0}", ex.Message), ex);
                return new Failure("An internal error occurred.", FailureType.Internal);
            }
        }

        public ActionResult Describe()
        {
            APIDescription model = new APIDescription(_methods, _methodData, _service, (p) => p.Equals(USER_IP_PARAM));
            string viewName = DescriptionViewName();
            return (viewName != null) ? View(viewName, model) : View(new APIDescriptionView(), model);
        }

        // override this method to provide a view that will be used instead of the default method view
        protected virtual string DescriptionViewName()
        {
            return null;
        }
    }
}
