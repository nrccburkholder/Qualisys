using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Controllers
{
    public class ControllerBase : Controller
    {
        protected override void OnException(ExceptionContext filterContext)
        {
            if (filterContext == null)
            {
                throw new ArgumentNullException("filterContext");
            }

            // If custom errors are disabled, we need to let the normal ASP.NET exception handler         
            // execute so that the user can see useful debugging information.         
            //if (filterContext.ExceptionHandled || !filterContext.HttpContext.IsCustomErrorEnabled)         
            //{             
            //    return;         
            //}

            // TODO: What is the namespace for ExceptionType?         
            //if (!ExceptionType.IsInstanceOfType(exception))         
            //{         
            //    return;         
            //} 

            //filterContext.ExceptionHandled = true;  
            
            //this.View("Error").ExecuteResult(this.ControllerContext);

            //// TODO: What does this line do?         
            base.OnException(filterContext);          
            
            //filterContext.Result = new ViewResult         
            //{             ViewName = "Error"         
            //};         
            
            //filterContext.ExceptionHandled = true;         
            //filterContext.HttpContext.Response.Clear();         
            //filterContext.HttpContext.Response.StatusCode = 500; 
        }
    }
}