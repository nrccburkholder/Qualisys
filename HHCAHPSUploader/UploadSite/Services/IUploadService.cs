using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;

namespace UploadSite.Services
{
    public interface IUploadService
    {
        UploadResult ProcessFiles(ICollection<HttpPostedFileBase> files, bool isUpdate, string clientIP, string dropFolder);
    }
}
