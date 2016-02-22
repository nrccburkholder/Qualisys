using Ionic.Zip;
using Microsoft.AspNet.Http;
using Microsoft.Net.Http.Headers;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public class UploadValidator : IUploadValidator
    {
        private const string fileNamePattern = @"HH?[-_\s]?CAH?PS_([0-9]{5,6})[^0-9]";
        private static Regex regexFileName = new Regex(fileNamePattern, RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);
        private static HashSet<string> allowedExtensions = new HashSet<string> { ".txt", ".csv", ".zip" };

        public void ValidateFiles(UploadResult files, bool isUpdate)
        {
            var result = new UploadResult();

            foreach (var file in files.Files)
            {
                if (!file.Success) continue;
                file.Error = file.IsZeroLength ? "The file has zero length." : GetError(file.FileName, isUpdate);
            }
        }

        private string GetError(string fileName, bool isUpdate)
        {
            var extension = Path.GetExtension(fileName).ToLower();
            if (!allowedExtensions.Contains(extension)) return "The file has an invalid extension.";
            if (!regexFileName.IsMatch(fileName)) return "The CCN couldn't be found in the file name.";

            var hasUpdateInFileName = fileName.ToLower().Contains("update");
            if (hasUpdateInFileName && !isUpdate) return "The file name has 'update' in it but 'These are update files' was not checked. If this is not an update file, then remove the word 'update' from the file name.";

            return null;
        }
    }
}
