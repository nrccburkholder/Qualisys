using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class FileClassifier
    {
        public static FileType Classify(string fileFullName)
        {
            if (FileNameParser.IsNrcFile(fileFullName)) return FileType.NRC;

            return FileType.Unknown;
        }
    }
}
