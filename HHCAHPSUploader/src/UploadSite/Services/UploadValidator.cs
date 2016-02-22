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

        public UploadResult ValidateFiles(ICollection<IFormFile> files, bool isUpdate)
        {
            var result = new UploadResult();

            foreach (var file in files)
            {
                var disposition = ContentDispositionHeaderValue.Parse(file.ContentDisposition);
                var fileName = disposition.FileName.Trim('"');

                var extension = Path.GetExtension(fileName).ToLower();

                if (extension == ".zip")
                {
                    ValidateZip(isUpdate, result, file, fileName);
                }
                else
                {
                    result.Files.Add(
                        new UploadFileResult
                        {
                            OriginalName = fileName,
                            FinalName = AddUpdateToFileName(fileName, isUpdate),
                            Error = file.Length > 0 ? GetError(fileName, isUpdate) : "The file has zero length.",
                            UploadData = file
                        });
                }
            }

            return result;
        }

        private void ValidateZip(bool isUpdate, UploadResult result, IFormFile file, string fileName)
        {
            var entryCount = 0;

            try
            {
                using (var zip = new ZipInputStream(file.OpenReadStream()))
                {
                    ZipEntry entry;
                    while ((entry = zip.GetNextEntry()) != null)
                    {
                        entryCount++;
                        if (entry.IsDirectory) continue;

                        var binaryReader = new BinaryReader(zip);
                        var fileData = binaryReader.ReadBytes((int)zip.Length);

                        result.Files.Add(
                            new UploadFileResult
                            {
                                ZipName = fileName,
                                OriginalName = fileName + "/" + entry.FileName,
                                FinalName = AddUpdateToFileName(Path.GetFileName(entry.FileName), isUpdate),
                                Error = entry.UncompressedSize > 0L ? GetError(entry.FileName, isUpdate) : "The file has zero length.",
                                ZipData = fileData
                            });
                    }
                }
            }
            catch (ZipException)
            {
                entryCount = 0;
                result.Files.RemoveAll(resultFile => resultFile.ZipName == fileName);
            }

            if (entryCount == 0)
            {
                result.Files.Add(
                    new UploadFileResult
                    {
                        ZipName = fileName,
                        OriginalName = fileName,
                        FinalName = fileName,
                        Error = "The zip file couldn't be opened."
                    });
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

        private string AddUpdateToFileName(string fileName, bool isUpdate)
        {
            if (!isUpdate) return fileName;
            if (fileName.ToLower().Contains("update")) return fileName;
            return "UPDATE_" + fileName;
        }
    }
}
