using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Utilities
{
    /// <summary>
    /// File utility Functions
    /// </summary>
    public static class Files
    {
        /// <summary>
        /// Rename this file.  If the new filename already exists then append a numeric value [1].
        /// If the original filename and the new filename are the same then nothing will happen.
        /// </summary>
        /// <param name="fileName">If the path is included then this is the path that will be used
        /// if the new filename does not contain a path</param>
        /// <param name="newFileName">Path is optional</param>
        /// <param name="createDir">Create the new path if necessary</param>
        public static string RenameFile(string fileName, string newFileName, bool overwrite = false, bool createDir = true)
        {
            string path = Path.GetDirectoryName(fileName);
            string newPath = Path.GetDirectoryName(newFileName);
            if (string.IsNullOrWhiteSpace(newPath)) newPath = path;
            string finalName = Path.Combine(newPath, newFileName);

            // Check if the original and new file name are the same, then there is no need to rename
            if (fileName.Equals(finalName, StringComparison.InvariantCultureIgnoreCase))
                return fileName;

            // Create the Directory if necessary
            if (createDir && !Directory.Exists(newPath))
            {
                Directory.CreateDirectory(newPath);
            }

            if (overwrite)
            {
                File.Delete(finalName);
            }
            else
            {
                int count = 1;
                while (File.Exists(finalName))
                {
                    finalName = Path.Combine(newPath, string.Format("{0}[{1}]{2}",
                                                      Path.GetFileNameWithoutExtension(newFileName),
                                                      count++,
                                                      Path.GetExtension(newFileName)));
                }
            }
            File.Move(fileName, finalName);
            return finalName;
        }
    }
}
