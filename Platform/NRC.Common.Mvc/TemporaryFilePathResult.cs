using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

using System.Web.Mvc;

namespace NRC.Common.Mvc
{
    /// <summary>
    /// This class is like the built-in FilePathResult, but it deletes the file after outputting it.
    /// </summary>
    public class TemporaryFilePathResult: FilePathResult
    {
        private static Logger _logger = Logger.GetLogger();

        public TemporaryFilePathResult(string fileName, string contentType, string downloadName) : base(fileName, contentType)
        {
            this.FileDownloadName = downloadName;
        }

        public override void ExecuteResult(ControllerContext context)
        {
            base.ExecuteResult(context);
            try
            {
                context.HttpContext.Response.Flush();
                File.Delete(this.FileName);
            }
            catch (Exception ex)
            {
                _logger.Error(String.Format("Unable to delete file {0} after output: {1}", this.FileName, ex.Message), ex);
            }
        }
    }
}
