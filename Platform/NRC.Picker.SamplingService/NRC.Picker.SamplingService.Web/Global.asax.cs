using System.Web.Mvc;
using System.Web.Routing;

using NRC.Common;

namespace NRC.Picker.SamplingService.Web
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Index",
                "",
                new { controller = "Status", action = "Index" }
            );

            routes.MapRoute(
                "Report",
                "Report/{id}",
                new { controller = "Report", action = "Report" }
            );
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RegisterRoutes(RouteTable.Routes);

            Logger.GetLogger("SamplingServiceWeb");
        }
    }
}