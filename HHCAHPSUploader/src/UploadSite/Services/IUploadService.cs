using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public interface IUploadService
    {
        UploadResult ProcessFiles(ICollection<IFormFile> files, bool isUpdate, IPAddress clientIP);
    }
}
