using System.Linq;
using System.Web.Mvc;

using NRC.Picker.SamplingService.Store;

namespace NRC.Picker.SamplingService.Web.Controllers
{
    [HandleError]
    public class StatusController : Controller
    {
        public ActionResult Index()
        {
            ViewData["queuedDatasets"] = QualisysAdapter.GetQueuedDatasets();
            return View();
        }
    }
}
