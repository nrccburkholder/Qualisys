﻿using System.Web;
using System.Web.Mvc;

namespace UploadSite
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new UnhandledErrorAttribute());
            filters.Add(new RequireHttpsAttribute());
        }
    }
}
