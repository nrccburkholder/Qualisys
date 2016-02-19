using Microsoft.AspNet.Http;
using Microsoft.Net.Http.Headers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public class UploadValidator : IUploadValidator
    {
        private const string fileNamePattern = @"HH?[-_\s]?CAH?PS_([0-9]{5,6})[^0-9]";
        private static Regex regexFileName = new Regex(fileNamePattern, RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

        public UploadResult ValidateFiles(ICollection<IFormFile> files)
        {
            var result = new UploadResult();

            foreach (var file in files)
            {
                var disposition = ContentDispositionHeaderValue.Parse(file.ContentDisposition);

                result.Files.Add(
                    new UploadFileResult
                    {
                        Name = disposition.FileName.Trim('"'),
                        Error = file.Length > 0 ? GetError(disposition.FileName) : "The file has zero length.",
                        Data = file
                    });
            }

            return result;
        }

        private string GetError(string fileName)
        {
            if (!regexFileName.IsMatch(fileName)) return "The CCN couldn't be found in the file name.";
            
            if (fileName.Contains("HHCAHPS_Version1.2_OCFW.zip")) return "The zip file couldn't be opened.";
            if (fileName.Contains(".exe")) return "The file has an invalid extension.";

            return null;
        }
    }
}
