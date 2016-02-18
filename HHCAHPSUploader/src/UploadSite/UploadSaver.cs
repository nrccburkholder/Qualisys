using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite
{
    public class UploadSaver : IUploadSaver
    {
        public void SaveFilesToDropFolder(string dropFolder, UploadResult result)
        {
            foreach (var file in result.Files)
            {
                var path = System.IO.Path.Combine(dropFolder, file.Name);
                file.Data.SaveAs(path);
            }
        }
    }
}
