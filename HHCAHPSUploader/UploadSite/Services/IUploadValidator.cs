using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace UploadSite.Services
{
    public interface IUploadValidator
    {
        void ValidateFiles(UploadResult files, bool isUpdate);
    }
}
