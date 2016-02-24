using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NRCFileConverterLibrary.Common;
using NRCFileConverterLibrary.Providers;

namespace NRCFileConverterLibrary.Factory
{
    /// <summary>
    /// This factory class creates  appropriate File Conversion Provider.
    /// </summary>
    static class ProviderFactory 
    {
        public static IProvider Create(RuleConfigurationItem configuration)
        {
            IProvider provider = null;
            switch (configuration.Provider)
            {
                case "FlatToAccessProvider":
                    provider = new FlatToAccessProvider
                    {
                        Name = configuration.Name,
                        FileType = configuration.FileType,
                        InputPath = configuration.InputPath,
                        InProcessPath = configuration.InProcessPath,
                        ArchivePath = configuration.ArchivePath,
                        PrimaryKey = configuration.PrimaryKey,
                        OutPath = configuration.OutPath
                    };
                    break;
                default:
                    throw new FactoryException(string.Format("The specfied provider :{0} is invalid", configuration.Provider));
            }
            return provider;
        }
    }
}
