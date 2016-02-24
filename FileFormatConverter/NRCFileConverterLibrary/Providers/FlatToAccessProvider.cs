using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using NRCFileConverterLibrary.Common;

namespace NRCFileConverterLibrary.Providers
{
    public class FlatToAccessProvider : AbstractProvider
    {

        public override string ConvertTheFile(string processPath)
        {
            return FileConverter.FromCsvToAccess(processPath, PrimaryKey);
        }

        public override void Validate()
        {
            ValidateFolder(InputPath, "InputPath");
            ValidateFolder(InProcessPath, "InProcessPath");
            ValidateFolder(OutPath, "OutPath");
            ValidateFolder(ArchivePath, "ArchivePath");
        }
       

        private void ValidateFolder(string path, string Pathname)
        {
            if (!Directory.Exists(path))
            {
                throw new ProviderException(string.Format("Invalid {0} '{1}'.", Pathname, path));
            }
        }
    }
}
