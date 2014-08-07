using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;

namespace NRC.Common.Application
{
    public static class RecursivePropertyResolver
    {
        public static T Resolve<T>(object rootObject, string propertyPath)
        {
            return (T)Convert.ChangeType(Resolve(rootObject, propertyPath), typeof(T));
        }

        public static object Resolve(object rootObject, string propertyPath)
        {
            return propertyPath.Split('.').Aggregate(rootObject, (obj, property) => ResolveProperty(obj, property));
        }

        private static object ResolveProperty(object currentObject, string property)
        {
            // Get the type of the currentObject
            Type currentObjectType = currentObject.GetType();

            // split the property into the properyname and optionally any arguments.  if there are arguments
            // then we are dealing with either dictionary[foo] or possible AddNumbers(1,2), and thus a method and not really a property
            List<string> propertyParts = property.Split(new char[] { '[', '(' }, 2).Where(t => string.IsNullOrEmpty(t.Trim()).Equals(false)).ToList();

            string propertyName = propertyParts.First();
            string argsString = string.Empty;

            if (propertyParts.Count().Equals(2))
            {
                // if we were given dict[foo] or AddNumbers(1,2) then the argsString will have 'foo' or '1,2'
                argsString = propertyParts[1].Replace("]", "").Replace(")", "");
            }

            // if the currentObject has a property matching the propertyName then we are going to use that
            var prop = currentObjectType.GetProperty(propertyName, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
            if (prop != null)
            {
                object value = prop.GetValue(currentObject, null);
                if (value == null)
                {
                    throw new UserException(String.Format("The property {0} does not have a value assigned.", propertyName));
                }

                // if the propery is a Dictionary<string,string> then special case it.
                // TODO: Is there a better way?
                if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Dictionary<,>) && !String.IsNullOrEmpty(argsString))
                {
                    object key;
                    Type[] types = prop.PropertyType.GetGenericArguments();
                    if (types[0] == typeof(string))
                    {
                        key = argsString;
                    }
                    else
                    {
                        throw new UserException(String.Format("Dictionaries must have keys of type string, not {0}, in property strings.", types[0].Name.ToLower()));
                    }

                    MethodInfo getter = prop.PropertyType.GetMethod("GetValue");
                    return getter.Invoke(value, new object[] { key });
                }
                else
                {
                    // otherwise simply return the value of propertyName on the currentObject
                    return value;
                }
            }
            else if (currentObjectType.GetMethods().Count(t => t.Name.Equals(propertyName, StringComparison.InvariantCultureIgnoreCase)).Equals(1))
            {
                // if propertyName was not found in the list of properties on the currentObject then maybe it was a methodname and not a propery.  
                // There is probably as better to do this, mabye something like "if pattern is \s\(.*\) then we know it's a method

                // the argsString '1,2' or 'foo' and split into an list
                var args = argsString.Split(new char[] { ',' }).Where(t => string.IsNullOrEmpty(t).Equals(false)).ToList();

                // convert to a list of Objects.  I don't think we really need this.
                var inputArguments = args.Select(t => (object)t).ToList<object>();

                // Get information on the method named propertyName.  Note, at this point propertyName is really methodName.
                var methodInfo = currentObjectType.GetMethod(propertyName);

                // Get a list of the parameters
                var methodParameters = methodInfo.GetParameters();

                // convert each argument into the appropriate type
                // var theParams = inputArguments.Zip(ps, (v, t) => Convert.ChangeType(v, t.ParameterType));
                List<object> theParams = new List<object>();
                for (int i = 0; i < methodParameters.Count(); i++)
                {
                    theParams.Add(Convert.ChangeType(inputArguments[i], methodParameters[i].ParameterType));
                }

                // invoke the method with the paramters and return the value
                return methodInfo.Invoke(currentObject, theParams.ToArray<object>());
            }

            throw new UserException(String.Format("Unable to resolve property '{0}'.", property));
        }

        public static Type GetType(Type rootObjectType, string propertyPath)
        {
            return propertyPath.Split('.')
                .Aggregate
                (
                    rootObjectType,
                    (type, property) => NRC.Common.Application.RecursivePropertyResolver.ResolvePropertyType(type, property)
                );
        }

        private static Type ResolvePropertyType(Type currentObjectType, string property)
        {
            // split the property into the properyname and optionally any arguments.  if there are arguments
            // then we are dealing with either dictionary[foo] or possible AddNumbers(1,2), and thus a method and not really a property
            List<string> propertyParts = property.Split(new char[] { '[', '(' }, 2).Where(t => string.IsNullOrEmpty(t.Trim()).Equals(false)).ToList();

            string propertyName = propertyParts.First();
            string argsString = string.Empty;

            if (propertyParts.Count().Equals(2))
            {
                // if we were given dict[foo] or AddNumbers(1,2) then the argsString will have 'foo' or '1,2'
                argsString = propertyParts[1].Replace("]", "").Replace(")", "");
            }

            // if the currentObject has a property matching the propertyName then we are going to use that
            if (currentObjectType.GetProperties().Count(t => t.Name.Equals(propertyName, StringComparison.InvariantCultureIgnoreCase)).Equals(1))
            {
                var prop = currentObjectType.GetProperty(propertyName);

                return prop.PropertyType;
            }
            else if (currentObjectType.GetMethods().Count(t => t.Name.Equals(propertyName, StringComparison.InvariantCultureIgnoreCase)).Equals(1))
            {
                // if propertyName was not found in the list of properties on the currentObject then maybe it was a methodname and not a propery.  
                // There is probably as better to do this, mabye something like "if pattern is \s\(.*\) then we know it's a method

                // the argsString '1,2' or 'foo' and split into an list
                var args = argsString.Split(new char[] { ',' }).Where(t => string.IsNullOrEmpty(t).Equals(false)).ToList();

                // convert to a list of Objects.  I don't think we really need this.
                var inputArguments = args.Select(t => (object)t).ToList<object>();

                // Get information on the method named propertyName.  Note, at this point propertyName is really methodName.
                var methodInfo = currentObjectType.GetMethod(propertyName);

            }

            return null;
        }
    }
}
