using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class FileNameParser
    {
        private const string nrcFileNamePattern = @"OCS([a-z0-9]+)_";
        private static Regex regexNrcFileTest = new Regex(nrcFileNamePattern, RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

        private const string directFromClientFilePattern = @"HH?[-_\s]?CAH?PS_([a-z0-9]+)";
        private static Regex regexDirectFromClientFileTest = new Regex(directFromClientFilePattern, RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

        public static string GetCCN(string fileName)
        {
            fileName = System.IO.Path.GetFileName(fileName);
            var source = GetFileSource(fileName);

            switch (source)
            {
                case FileSource.NRC:
                    return GetCCNFromNrcFile(fileName);
                case FileSource.DirectFromClient:
                    return GetCCNFromDirectFromClientFile(fileName);
                default:
                    throw new InvalidOperationException(string.Format("Can't get the CCN from file {0}.", fileName));
            }
        }

        private static string GetCCNFromDirectFromClientFile(string fileName)
        {
            var m = regexDirectFromClientFileTest.Match(fileName);
            if (m.Success)
            {
                return m.Groups[1].Value.ToString();
            }

            return null;
        }

        private static string GetCCNFromNrcFile(string fileName)
        {
            var m = regexNrcFileTest.Match(fileName);
            if (m.Success)
            {
                return m.Groups[1].Value.ToString();
            }

            return null;
        }

        public static FileSource GetFileSource(string fileName)
        {
            fileName = System.IO.Path.GetFileName(fileName);

            if (regexNrcFileTest.Match(fileName).Success)
                return FileSource.NRC;
            else if (regexDirectFromClientFileTest.Match(fileName).Success)
                return FileSource.DirectFromClient;
            else return FileSource.Unknown;
        }
    }
}
