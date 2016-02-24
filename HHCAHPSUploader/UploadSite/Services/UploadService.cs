using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using System.IO;
using System.Web;
using Microsoft.Practices.Unity;
using NRC.Common;

namespace UploadSite.Services
{
    public class UploadService : IUploadService
    {
        private readonly IUploadValidator _validator;
        private readonly IUploadSaver _saver;
        private readonly IUnzipper _unzipper;
        private readonly Logger _logger;

        public UploadService([Dependency] IUploadValidator validator, [Dependency] IUploadSaver saver, [Dependency] IUnzipper unzipper, [Dependency] Logger logger)
        {
            _validator = validator;
            _saver = saver;
            _unzipper = unzipper;
            _logger = logger;
        }

        public UploadResult ProcessFiles(ICollection<HttpPostedFileBase> files, bool isUpdate, string clientIP, string dropFolder)
        {
            var result = Flatten(files);

            _validator.ValidateFiles(result, isUpdate);
            foreach (var file in result.Files) file.FinalName = AddUpdateToFileName(file.FileName, isUpdate);
            if (result.Success) _saver.SaveFilesToDropFolder(dropFolder, result);
            LogResult(result, isUpdate, clientIP);

            return result;
        }

        private UploadResult Flatten(ICollection<HttpPostedFileBase> files)
        {
            var result = new UploadResult();

            foreach (var file in files)
            {
                var fileName = file.FileName.Trim('"');
                var extension = Path.GetExtension(fileName).ToLower();

                if (extension == ".zip")
                {
                    result.Files.AddRange(_unzipper.Unzip(file.InputStream, fileName));
                }
                else
                {
                    result.Files.Add(
                        new UploadFileResult
                        {
                            FileName = fileName,
                            OriginalName = fileName,
                            UploadData = file
                        });
                }
            }

            return result;
        }

        private string AddUpdateToFileName(string fileName, bool isUpdate)
        {
            if (!isUpdate) return fileName;
            if (fileName.ToLower().Contains("update")) return fileName;
            return "UPDATE_" + fileName;
        }

        private void LogResult(UploadResult result, bool isUpdate, string clientIP)
        {
            _logger.Info($"{clientIP} {result.Files.Count} {(isUpdate ? "update" : "regular")} files uploaded {(result.Success ? "successfully" : "unsuccessfully")}.");
            
            foreach (var file in result.Files)
            {
                if (file.Success)
                    _logger.Info($"{clientIP} File {file.OriginalName} was okay.");
                else
                    _logger.Info($"{clientIP} File {file.OriginalName} had an error. {file.Error}");
            }
        }
    }
}
