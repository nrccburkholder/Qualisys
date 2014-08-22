using System.Web.Mvc;
using System.Web.Routing;

using NRC.Common;

namespace NRC.Platform.Mailer
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            // Translate automatically unpacks arguments from JSON into our desired parameter list
            routes.MapRoute("Service", "Service/{method}", new { controller = "Service", action = "Translate", method = "" });
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RegisterRoutes(RouteTable.Routes);

            Logger logger = Logger.GetLogger("NRC.Platform.Mailer");

            logger.Info(string.Format("Starting Mailer Web Service on host '{0}'", System.Environment.MachineName));
        }
    }
}