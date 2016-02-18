using Microsoft.AspNet.Http;
using Microsoft.Net.Http.Headers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Service
{
    public class UploadValidator : IUploadValidator
    {
        public UploadResult ValidateFiles(ICollection<IFormFile> files)
        {
            var result = new UploadResult();

            foreach (var file in files)
            {
                var disposition = ContentDispositionHeaderValue.Parse(file.ContentDisposition);

                if (file.Length > 0)
                {
                    var fileResult = new UploadFileResult
                    {
                        Name = disposition.FileName.Trim('"'),
                        Error = GetError(disposition.FileName),
                        Data = file
                    };

                    result.Files.Add(fileResult);
                }
                else
                {
                    var fileResult = new UploadFileResult
                    {
                        Name = disposition.FileName.Trim('"'),
                        Error = "The file has zero length.",
                        Data = file
                    };

                    result.Files.Add(fileResult);
                }
            }

            return result;
        }

        private string GetError(string fileName)
        {
            if (fileName.Contains("HHCAHPS_Version1.2_OCFW.txt")) return "The CCN couldn't be found in the file name.";
            if (fileName.Contains("HHCAHPS_Version1.2_OCFW.zip")) return "The zip file couldn't be opened.";
            if (fileName.Contains(".exe")) return "The file has an invalid extension.";

            return null;
        }
    }
}
