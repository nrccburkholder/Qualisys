using System.Web.Mvc;

using NRC.Common.Configuration;

using NRC.Picker.SamplingService.Mailer;
using NRC.Picker.SamplingService.Store;
using NRC.Picker.SamplingService.Store.Models;

namespace NRC.Picker.SamplingService.Web.Controllers
{
    [HandleError]
    public class ReportController : Controller
    {
        private static readonly Configuration _config;

        static ReportController()
        {
            _config = ConfigManager.Load<Configuration>();
        }

        public ActionResult Report(int id)
        {
            Dataset dataset = new Dataset(id, _config.SampleCountThreshold);
            ViewData["output"] = ReportMailer.LoadTemplate(dataset, null);
            return View();
        }
    }
}
