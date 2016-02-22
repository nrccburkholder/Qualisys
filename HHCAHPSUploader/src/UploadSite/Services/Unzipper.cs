using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Http;
using Ionic.Zip;
using System.IO;

namespace UploadSite.Services
{
    public class Unzipper : IUnzipper
    {
        public IEnumerable<UploadFileResult> Unzip(Stream uploadData, string fileName)
        {
            var entryCount = 0;
            var files = new List<UploadFileResult>();

            try
            {
                using (var zip = new ZipInputStream(uploadData))
                {
                    ZipEntry entry;
                    while ((entry = zip.GetNextEntry()) != null)
                    {
                        entryCount++;
                        if (entry.IsDirectory) continue;

                        var zipData = new MemoryStream();
                        zip.CopyTo(zipData);

                        files.Add(
                            new UploadFileResult
                            {
                                ZipName = fileName,
                                FileName = fileName,
                                OriginalName = fileName + "/" + entry.FileName,
                                ZipData = zipData.ToArray()
                            });
                    }
                }
            }
            catch (ZipException ex) when (ex.Message == "Missing password.")
            {
                entryCount = 0;
                files.Clear();

                files.Add(
                    new UploadFileResult
                    {
                        ZipName = fileName,
                        OriginalName = fileName,
                        FinalName = fileName,
                        Error = "The zip file couldn't be open because it is password protected."
                    });

                return files;
            }
            catch (ZipException)
            {
                entryCount = 0;
                files.Clear();
            }

            if (entryCount == 0)
            {
                files.Add(
                    new UploadFileResult
                    {
                        ZipName = fileName,
                        OriginalName = fileName,
                        FinalName = fileName,
                        Error = "The zip file couldn't be opened."
                    });
            }

            return files;
        }
    }
}
