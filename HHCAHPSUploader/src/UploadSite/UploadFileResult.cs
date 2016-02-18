using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite
{
    public class UploadFileResult
    {
        public bool Success => string.IsNullOrEmpty(Error);
        public string Name { get; set; }
        public string Error { get; set; }
        public IFormFile Data { get; set; }
    }
}
