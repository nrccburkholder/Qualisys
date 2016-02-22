using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Http;
using Microsoft.Extensions.OptionsModel;
using Microsoft.Extensions.Logging;
using System.Net;

namespace UploadSite.Services
{
    public class UploadService : IUploadService
    {
        private readonly IUploadValidator _validator;
        private readonly IUploadSaver _saver;
        private readonly FileDropSettings _fileDropSettings;
        private readonly ILogger<UploadService> _logger;

        public UploadService(IUploadValidator validator, IUploadSaver saver, IOptions<FileDropSettings> fileDropSettings, ILogger<UploadService> logger)
        {
            _validator = validator;
            _saver = saver;
            _fileDropSettings = fileDropSettings.Value;
            _logger = logger;
        }

        public UploadResult ProcessFiles(ICollection<IFormFile> files, bool isUpdate, IPAddress clientIP)
        {
            var result = _validator.ValidateFiles(files, isUpdate);
            if (result.Success) _saver.SaveFilesToDropFolder(_fileDropSettings.Path, result);
            LogResult(result, isUpdate, clientIP);

            return result;
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
