using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite
{
    public interface IUploadSaver
    {
        void SaveFilesToDropFolder(string dropFolder, UploadResult result);
    }
}
