using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessingService
{
    internal static class ZipExtractor
    {
        public static void SetFlattenedUniqueFileNames(Ionic.Zip.ZipFile zipFile, string extractDirectory)
        {
            var files = zipFile.ToList();
            var fileNames = new HashSet<string>();

            foreach (var file in files)
            {
                if (file.IsDirectory) continue;

                var flattenedName = Path.GetFileName(file.FileName);
                var uniqueName = flattenedName;
                var destination = Path.Combine(extractDirectory, uniqueName);

                var counter = 1;
                while (fileNames.Contains(uniqueName) || File.Exists(destination))
                {
                    uniqueName = $"{Path.GetFileNameWithoutExtension(flattenedName)}_{counter}{Path.GetExtension(flattenedName)}"; // new syntax for string.Format();
                    destination = Path.Combine(extractDirectory, uniqueName);
                    counter++;
                }

                fileNames.Add(uniqueName);
                file.FileName = uniqueName;
            }
        }
    }
}
