using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public class UploadSaver : IUploadSaver
    {
        public void SaveFilesToDropFolder(string dropFolder, UploadResult result)
        {
            foreach (var file in result.Files)
            {
                file.FinalName = GetUniqueName(dropFolder, file.FinalName);
                var path = Path.Combine(dropFolder, file.FinalName);

                if (file.IsZip)
                {
                    File.WriteAllBytes(path, file.ZipData);
                }
                else
                {
                    file.UploadData.SaveAs(path);
                }
            }
        }

        private string GetUniqueName(string dropFolder, string fileName)
        {
            var uniqueFileName = fileName;
            var fileNameWithoutExtension = Path.GetFileNameWithoutExtension(fileName);
            var extension = Path.GetExtension(fileName);
            var path = Path.Combine(dropFolder, fileName);
            var counter = 2;
            while (File.Exists(path))
            {
                uniqueFileName = $"{fileNameWithoutExtension}_{counter}{extension}";
                path = Path.Combine(dropFolder, uniqueFileName);
                counter++;
            }

            return uniqueFileName;
        }
    }
}
