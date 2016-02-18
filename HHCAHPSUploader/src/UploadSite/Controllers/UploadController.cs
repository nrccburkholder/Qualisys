using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Mvc;
using Microsoft.AspNet.Http;

namespace UploadSite.Controllers
{
    public class UploadController : Controller
    {
        private readonly IUploadService _uploadService;

        public UploadController(IUploadService uploadService)
        {
            _uploadService = uploadService;
        }

        [AcceptVerbs("GET")]
        public IActionResult Index()
        {
            return View();
        }

        [AcceptVerbs("POST")]
        public IActionResult Index(ICollection<IFormFile> files, bool isUpdate)
        {
            var result = _uploadService.ProcessFiles(files, isUpdate, Request.HttpContext.Connection.RemoteIpAddress);
            return View("Confirmation", result);
        }

        public IActionResult Error()
        {
            return View();
        }
    }
}
