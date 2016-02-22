using Ionic.Zip;
using Microsoft.AspNet.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public class UploadFileResult
    {
        public bool Success => string.IsNullOrEmpty(Error);
        public bool IsZip => !string.IsNullOrEmpty(ZipName);
        public string ZipName { get; set; }
        public string OriginalName { get; set; }
        public string FinalName { get; set; }
        public string Error { get; set; }
        public IFormFile UploadData { get; set; }
        public byte[] ZipData { get; set; }
    }
}
