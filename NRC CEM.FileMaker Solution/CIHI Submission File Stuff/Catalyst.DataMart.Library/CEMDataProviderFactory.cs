using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Catalyst.DataMart.Library
{
    internal sealed class CEMDataProviderFactory
    {

        private CEMDataProviderFactory()
        {

        }

        public static T CreateInstance<T>(string providerName)
        {
            T instance;

            string providerAssemblyName = "Catalyst.DataMart.Library.DataProvider";
            string providerTypeName = providerAssemblyName + "." + providerName;

            string type = string.Format("{0}, {1}", providerTypeName, providerAssemblyName);

            Type providerType = Type.GetType(type, true);

            try
            {
                instance = (T)Activator.CreateInstance(providerType);
                return instance;
            }
            catch(Exception ex)
            {
                throw ex.InnerException;
            }

        }
        
    }
}
