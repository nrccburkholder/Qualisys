using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Http;
using Microsoft.Extensions.OptionsModel;
using Microsoft.Extensions.Logging;
using System.Net;
using System.IO;
using Microsoft.Net.Http.Headers;

namespace UploadSite.Services
{
    public class UploadService : IUploadService
    {
        private readonly IUploadValidator _validator;
        private readonly IUploadSaver _saver;
        private readonly IUnzipper _unzipper;
        private readonly FileDropSettings _fileDropSettings;
        private readonly ILogger<UploadService> _logger;

        public UploadService(IUploadValidator validator, IUploadSaver saver, IUnzipper unzipper, IOptions<FileDropSettings> fileDropSettings, ILogger<UploadService> logger)
        {
            _validator = validator;
            _saver = saver;
            _unzipper = unzipper;
            _fileDropSettings = fileDropSettings.Value;
            _logger = logger;
        }

        public UploadResult ProcessFiles(ICollection<IFormFile> files, bool isUpdate, IPAddress clientIP)
        {
            var result = Flatten(files);

            _validator.ValidateFiles(result, isUpdate);
            foreach (var file in result.Files) file.FinalName = AddUpdateToFileName(file.FileName, isUpdate);
            if (result.Success) _saver.SaveFilesToDropFolder(_fileDropSettings.Path, result);
            LogResult(result, isUpdate, clientIP);

            return result;
        }

        private UploadResult Flatten(ICollection<IFormFile> files)
        {
            var result = new UploadResult();

            foreach (var file in files)
            {
                var disposition = ContentDispositionHeaderValue.Parse(file.ContentDisposition);
                var fileName = disposition.FileName.Trim('"');
                var extension = Path.GetExtension(fileName).ToLower();

                if (extension == ".zip")
                {
                    result.Files.AddRange(_unzipper.Unzip(file.OpenReadStream(), fileName));
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

        private void LogResult(UploadResult result, bool isUpdate, IPAddress clientIP)
        {
            var uploadDate = DateTime.Now;

            _logger.LogInformation($"{uploadDate} {clientIP} {result.Files.Count} {(isUpdate ? "update" : "regular")} files uploaded {(result.Success ? "successfully" : "unsuccessfully")}.");

            foreach (var file in result.Files)
            {
                if (file.Success)
                    _logger.LogInformation($"{uploadDate} {clientIP} File {file.OriginalName} was okay.");
                else
                    _logger.LogInformation($"{uploadDate} {clientIP} File {file.OriginalName} had an error. {file.Error}");
            }
        }
    }
}
