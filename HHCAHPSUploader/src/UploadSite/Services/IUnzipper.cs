using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public interface IUnzipper
    {
        IEnumerable<UploadFileResult> Unzip(Stream uploadData, string fileName);
    }
}
