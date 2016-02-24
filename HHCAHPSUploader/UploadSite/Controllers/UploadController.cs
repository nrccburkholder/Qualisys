using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using UploadSite.Services;

namespace UploadSite.Controllers
{
    public class UploadController : Controller
    {
        private readonly IUploadService _uploadService;

        public UploadController([Dependency] IUploadService uploadService)
        {
            _uploadService = uploadService;
        }

        [AcceptVerbs("GET")]
        public ActionResult Index()
        {
            return View();
        }

        [AcceptVerbs("POST")]
        public ActionResult Index(ICollection<HttpPostedFileBase> files, bool? isUpdate)
        {
            var dropFolder = System.Web.Configuration.WebConfigurationManager.AppSettings["DropFolder"];
            var result = _uploadService.ProcessFiles(files, isUpdate ?? false, Request.ServerVariables["REMOTE_ADDR"], dropFolder);
            return View("Confirmation", result);
        }

        public ActionResult Error()
        {
            return View();
        }
    }
}
