using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public interface IUploadValidator
    {
        UploadResult ValidateFiles(ICollection<IFormFile> files);
    }
}
