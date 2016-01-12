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

        private const string directFromClientFilePattern = @"^HH?[-_\s]?CAH?PS";
        private static Regex regexDirectFromClientFileTest = new Regex(directFromClientFilePattern, RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

        private static Regex regexNrcCCN = new Regex(nrcFileNamePattern, RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

        private static Regex regexDirectFromClientCCNTight = new Regex(directFromClientFilePattern + @"_+(.+?)_\[?V", RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);
        private static Regex regexDirectFromClientCCNLoose = new Regex(@"_+([-|\d|a-z]{6,})_", RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

        public static string GetCCN(string fileName)
        {
            fileName = System.IO.Path.GetFileName(fileName);

            if (IsNrcFile(fileName))
                return GetCCNFromNrcFile(fileName);
            else if (IsDirectFromClientFile(fileName))
                return GetCCNFromDirectFromClientFile(fileName);
            else
                throw new InvalidOperationException(string.Format("Can't get the CCN from file {0}.", fileName));
        }

        private static string GetCCNFromDirectFromClientFile(string fileName)
        {
            string ccn = null;

            string simpleFileName = System.IO.Path.GetFileNameWithoutExtension(fileName);

            // do some basic cleanup. this simplifies the regex
            simpleFileName = simpleFileName.Replace("__", "_");
            simpleFileName = simpleFileName.Replace("[", "").Replace("]", "");
            simpleFileName = simpleFileName.Replace("(", "").Replace(")", "");
            simpleFileName = simpleFileName.Replace(" ", "");

            Match m = regexDirectFromClientCCNTight.Match(simpleFileName);
            if (m.Success)
            {
                ccn = m.Groups[1].Value;
                ccn = ccn.Replace("-", "");
                if (ccn.ToUpper().StartsWith("M")) ccn = ccn.Replace("M", "");
                if (ccn.ToUpper().StartsWith("NOC")) ccn = ccn.Replace("NOC", "");
            }
            else
            {
                m = regexDirectFromClientCCNLoose.Match(simpleFileName);
                if (m.Success)
                {
                    ccn = m.Groups[1].Value;
                    ccn = ccn.Replace("-", "");
                    if (ccn.Length < 3)
                    {
                        // safety check.  if we get something like 1----2, we will end up with 12 and 12 cannot be a CCN
                        ccn = null;
                    }
                }
            }

            if (ccn.Length > 6)
            {
                ccn = ccn.Substring(0, 6);
            }

            return ccn;
        }

        private static string GetCCNFromNrcFile(string fileName)
        {
            string ccn = null;

            Match m = regexNrcCCN.Match(fileName);
            if (m.Success)
            {
                ccn = m.Groups[1].Value.ToString();
            }

            return ccn;
        }

        public static bool IsDirectFromClientFile(string fileName)
        {
            string name = System.IO.Path.GetFileName(fileName);
            return regexDirectFromClientFileTest.Match(name).Success;
        }

        public static bool IsNrcFile(string fileName)
        {
            string name = System.IO.Path.GetFileName(fileName);
            return regexNrcFileTest.Match(name).Success;
        }
    }
}
