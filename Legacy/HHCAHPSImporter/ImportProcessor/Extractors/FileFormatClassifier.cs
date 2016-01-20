using HHCAHPSImporter.ImportProcessor.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class FileFormatClassifier
    {
        public static FileFormat Classify(string fileName, QP_DataLoadManager dataLoadManager)
        {
            var source = FileNameParser.GetFileSource(fileName);

            switch (source)
            {
                case FileSource.NRC:
                    return FileFormat.NRC;
                case FileSource.DirectFromClient:
                    var ccn = FileNameParser.GetCCN(fileName);
                    var clientFormat = dataLoadManager.GetClientFormatFromCCN(ccn);

                    if (clientFormat == null) throw new InvalidOperationException($"Can't get the file format for file {fileName} because there is no mapping of CCN to file format in the ClientFormat table.");

                    return (FileFormat)Enum.Parse(typeof(FileFormat), clientFormat.Format);
                default:
                    throw new InvalidOperationException($"Can't get the file format for file {fileName} because the file name is not in a recognized format.");
            }
        }
    }
}
