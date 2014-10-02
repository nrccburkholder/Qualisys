using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace NRC.Common.Mvc
{
    // This is basically a super-hacky workaround; the issue is that I want to use a view (or a partial view, really, since it's just the middle of the page), but I want to
    // define it in this assembly rather than in the assembly of the main web project. You can do this by defining a custom view engine, but that seems overkill just for
    // one view. So the solution is to write something that implements the view interface but isn't really a control, it just outputs the html "manually".
    class APIDescriptionView: IView
    {
        public void Render(ViewContext viewContext, TextWriter writer)
        {
            APIDescription model = (APIDescription)viewContext.ViewData.Model;

            writer.WriteLine("<div class=\"methods\">");
            if (model.Methods.Count == 0)
            {
                writer.WriteLine("<i>No methods are available.</i>");
                writer.WriteLine("</div>");
                return;
            }

            foreach (MethodDescription method in model.Methods)
            {
                writer.WriteLine("<div class=\"method\">");
                
                writer.WriteLine("<div class=\"method-main\">");
                writer.Write(String.Format("<b>{0}</b>", method.Name));
                if (method.Description != null)
                {
                    writer.Write(String.Format(": {0}", method.Description));
                }
                writer.WriteLine();
                writer.WriteLine("</div>");

                writer.WriteLine("<div class=\"method-parameters\">");
                writer.WriteLine("Parameters:");
                if (method.Parameters.Count > 0)
                {
                    foreach (ParameterDescription param in method.Parameters)
                    {
                        writer.WriteLine("<div class=\"parameter\">");
                        writer.Write(String.Format("{0} ({1})", param.Name, param.Type));
                        if (param.Description != null)
                        {
                            writer.Write(String.Format(": {0}", param.Description));
                        }
                        if (param.Sample != null)
                        {
                            writer.Write(String.Format(" Example: <div class=\"parameter-example\">{0}</div>", param.Sample));
                        }
                        writer.WriteLine();
                        writer.WriteLine();
                        writer.WriteLine("</div>");
                    }
                }
                else
                {
                    writer.WriteLine("<div class=\"parameter\">");
                    writer.WriteLine(" <i>This method takes no parameters.</i>");
                    writer.WriteLine("</div>");
                }
                writer.WriteLine("</div>");

                writer.WriteLine("<div class=\"method-return\">");
                writer.WriteLine("Returns:");
                if (method.ReturnType != null)
                {
                    writer.WriteLine("<div class=\"method-return-type\">");
                    writer.Write(method.ReturnType);
                    if (method.SampleReturn != null)
                    {
                        writer.Write(String.Format(": <div class=\"method-return-example\">{0}</div>", method.SampleReturn));
                    }
                    writer.WriteLine();
                    writer.WriteLine("</div>");
                }
                else
                {
                    writer.WriteLine("<div class=\"method-return-type\">");
                    writer.WriteLine("<i>nothing</i>");
                    writer.WriteLine("</div>");
                }
                writer.WriteLine("</div>");

                writer.WriteLine("</div>");
            }

            writer.WriteLine("</div>");
        }
    }
}
