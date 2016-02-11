using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class CcnValidator
    {
        public static void ValidateFileNameCcnAgainstFileContents(string fileNameCcn, string fileContentsCcn)
        {
            if (fileNameCcn == fileContentsCcn) return;
            throw new InvalidOperationException(GetInvalidCcnMessage(fileNameCcn, fileContentsCcn));
        }

        public static void ValidateFileNameCcnAgainstFileContents(string fileNameCcn, IEnumerable<string> fileContentsCcns)
        {
            var invalidCcns = fileContentsCcns.Distinct().Where(ccn => ccn != fileNameCcn);
            if (!invalidCcns.Any()) return;
            throw new InvalidOperationException(GetInvalidCcnMessage(fileNameCcn, invalidCcns));
        }

        private static string GetInvalidCcnMessage(string fileNameCcn, string fileContentsCcn)
        {
            if (string.IsNullOrEmpty(fileContentsCcn))
                return "The CCN in the file was blank";
            else
                return $"The CCN in the file name was {fileNameCcn}, but the CCN in the file was {fileContentsCcn}";
        }

        private static string GetInvalidCcnMessage(string fileNameCcn, IEnumerable<string> fileContentsCcns)
        {
            var labeledCcns = fileContentsCcns.Select(ccn => string.IsNullOrEmpty(ccn) ? "blank" : ccn);
            return $"The CCN in the file name was {fileNameCcn}, but the file contained CCNs: {string.Join(", ", labeledCcns)}";
        }
    }
}
