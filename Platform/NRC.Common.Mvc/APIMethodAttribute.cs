using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

using PostSharp.Aspects;
using PostSharp.Extensibility;
using NRC.Common;

namespace NRC.Common.Mvc
{
    [Serializable]
    [MulticastAttributeUsage(MulticastTargets.Method, PersistMetaData = true)]
    public class APIMethodAttribute: OnMethodBoundaryAspect
    {
        private static readonly Logger _logger = Logger.GetLogger();

        public string Description { get; set; }

        public APIMethodAttribute()
        {
            Description = null;
        }

        public APIMethodAttribute(string description) : this()
        {
            Description = description;
        }

        sealed override public void OnException(MethodExecutionArgs args)
        {
            LogException(args.Exception, args.Method, args.Arguments.ToArray());
            throw args.Exception; // this loses the stack trace information for our callers, but in this case it doesn't matter (there isn't a way not to lose it that I know of)
        }

        private void LogException(Exception ex, MethodBase method, params object[] values)
        {
            List<string> args = new List<string>();
            int idx = 0;
            foreach (ParameterInfo param in method.GetParameters())
            {
                object value = values[idx++];

                if (value == null)
                {
                    value = "<null>";
                }
                else if (param.ParameterType == typeof(Stream))
                {
                    value = "<stream>";
                }
                else if (param.Name.Equals("accountKey"))
                {
                    value = "****";
                }

                args.Add(param.Name + "=" + value);
            }

            if (ex.GetType() == typeof(UserException))
            {
                _logger.Info(String.Format("Bad user-supplied argument in {0} for {1}: {2}", method.Name, String.Join(", ", args), ex.Message), ex);
            }
            else
            {
                _logger.Error(String.Format("Failure in {0} for {1}: {2}", method.Name, String.Join(", ", args), ex.Message), ex);
            }
        }
    }
}
