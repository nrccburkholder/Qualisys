using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Mvc;
using Microsoft.AspNet.Http;
using Microsoft.Net.Http.Headers;
using Microsoft.Extensions.Logging;

namespace UploadSite.Controllers
{
    public class UploadController : Controller
    {
        private readonly ILogger<UploadController> _logger;

        public UploadController(ILogger<UploadController> logger)
        {
            _logger = logger;
        }

        [AcceptVerbs("GET")]
        public IActionResult Index()
        {
            _logger.LogInformation("Page accessed.");
            return View();
        }

        [AcceptVerbs("POST")]
        public IActionResult Index(ICollection<IFormFile> files, bool isUpdate)
        {
            var result = new UploadResult();

            foreach (var file in files)
            {
                var disposition = ContentDispositionHeaderValue.Parse(file.ContentDisposition);

                if (file.Length > 0)
                {
                    var fileResult = new UploadFileResult
                    {
                        Name = disposition.FileName,
                        Error = GetError(disposition.FileName)
                    };

                    result.Files.Add(fileResult);
                }
                else
                {
                    var fileResult = new UploadFileResult
                    {
                        Name = disposition.FileName,
                        Error = "The file has zero length."
                    };

                    result.Files.Add(fileResult);
                }
            }

            LogResult(result, isUpdate);

            return View("Confirmation", result);
        }

        private void LogResult(UploadResult result, bool isUpdate)
        {
            var uploadDate = DateTime.Now;
            var clientIP = Request.HttpContext.Connection.RemoteIpAddress;

            _logger.LogInformation($"{uploadDate} {clientIP} {result.Files.Count} {(isUpdate ? "update" : "regular")} files uploaded {(result.Success ? "successfully" : "unsuccessfully")}.");

            foreach (var file in result.Files)
            {
                if (file.Success)
                    _logger.LogInformation($"{uploadDate} {clientIP} File {file.Name} was okay.");
                else
                    _logger.LogInformation($"{uploadDate} {clientIP} File {file.Name} had an error. {file.Error}");
            }
        }

        public string GetError(string fileName)
        {
            if (fileName.Contains("HHCAHPS_Version1.2_OCFW.txt")) return "The CCN couldn't be found in the file name.";
            if (fileName.Contains("HHCAHPS_Version1.2_OCFW.zip")) return "The zip file couldn't be opened.";
            if (fileName.Contains(".exe")) return "The file has an invalid extension.";

            return null;
        }

        public IActionResult Error()
        {
            return View();
        }
    }

    public class UploadResult
    {
        public bool Success => Files.All(file => file.Success);
        public IList<UploadFileResult> Files { get; set; } = new List<UploadFileResult>();
        public IEnumerable<UploadFileResult> ErrorFiles => Files.Where(file => !file.Success);
    }

    public class UploadFileResult
    {
        public bool Success => string.IsNullOrEmpty(Error);
        public string Name { get; set; }
        public string Error { get; set; }
    }
}
