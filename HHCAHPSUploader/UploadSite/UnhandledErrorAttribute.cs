using NRC.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UploadSite.App_Start;

namespace UploadSite
{
    public class UnhandledErrorAttribute : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            var logger = (Logger)UnityConfig.GetConfiguredContainer().Resolve(typeof(Logger), null);
            logger.Error(filterContext.Exception.Message, filterContext.Exception);

            base.OnException(filterContext);
        }
    }
}