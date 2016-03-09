using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public class UploadResult
    {
        public bool Success => Files.All(file => file.Success) && !NoFiles;
        public bool NoFiles => !Files.Any();
        public List<UploadFileResult> Files { get; set; } = new List<UploadFileResult>();
        public IEnumerable<UploadFileResult> ErrorFiles => Files.Where(file => !file.Success);
    }
}
