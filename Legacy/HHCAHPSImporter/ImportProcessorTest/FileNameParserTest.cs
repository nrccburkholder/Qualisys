using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.Extractors;

namespace ImportProcessorTest
{
    [TestClass]
    public class FileNameParserTest
    {
        #region Helpers

        private static void AssertGetCCN(string fileName, string expected)
        {
            var ccn = FileNameParser.GetCCN(fileName);
            Assert.AreEqual(expected, ccn);
        }

        private static void AssertGetFileSource(string fileName, FileSource expected)
        {
            var result = FileNameParser.GetFileSource(fileName);
            Assert.AreEqual(expected, result);
        }

        #endregion Helpers

        #region GetCCN
        
        [TestMethod]
        public void GetCCN_NrcFile_ReturnsCCN()
        {
            AssertGetCCN(@"56014_15990_OCS240053_HHCAHPS_52014_09242015.csv", "240053");
        }

        [TestMethod]
        public void GetCCN_NrcFileWithFullPathContainingConflictingMatch_ReturnsCCN()
        {
            AssertGetCCN(@"C:\OCS123456_\56014_15990_OCS240053_HHCAHPS_52014_09242015.csv", "240053");
        }

        [TestMethod]
        public void GetCCN_DirectFromClientFile_ReturnsCCN()
        {
            AssertGetCCN(@"HHCAHPS_240053_13_09242015.csv", "240053");
        }

        [TestMethod]
        public void GetCCN_DirectFromClientFileWithUploadIdPrefix_ReturnsCCN()
        {
            AssertGetCCN(@"8888_HHCAHPS_240053_13_09242015.csv", "240053");
        }

        [TestMethod]
        public void GetCCN_DirectFromClientFileWithFullPathContainingConflictingMatch_ReturnsCCN()
        {
            AssertGetCCN(@"C:\HHCAHPS_123456_\HHCAHPS_240053_13_09242015.csv", "240053");
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void GetCCN_NotNrcOrDirectFromClientFile_ThrowsInvalidOperationException()
        {
            FileNameParser.GetCCN(@"blah");
        }

        #endregion GetCCN

        #region GetFileSource

        [TestMethod]
        public void GetFileSource_NrcFile_ReturnsNRC()
        {
            AssertGetFileSource(@"56014_15990_OCS240053_HHCAHPS_52014_09242015.csv", FileSource.NRC);
        }

        [TestMethod]
        public void GetFileSource_DirectFromClientFile_ReturnsDirectFromClient()
        {
            AssertGetFileSource(@"HHCAHPS_240053_13_09242015.csv", FileSource.DirectFromClient);
        }

        [TestMethod]
        public void GetFileSource_NrcFileWithFullPath_ReturnsNRC()
        {
            AssertGetFileSource(@"C:\HHCAHPS_123456_\56014_15990_OCS240053_HHCAHPS_52014_09242015.csv", FileSource.NRC);
        }

        [TestMethod]
        public void GetFileSource_DirectFromClientFileWithUploadIdPrefix_ReturnsDirectFromClient()
        {
            AssertGetFileSource(@"8888_HHCAHPS_240053_13_09242015.csv", FileSource.DirectFromClient);
        }

        [TestMethod]
        public void GetFileSource_DirectFromClientFileWithOCSPath_ReturnsDirectFromClient()
        {
            AssertGetFileSource(@"C:\OCS_123456_\HHCAHPS_240053_13_09242015.csv", FileSource.DirectFromClient);
        }

        #endregion GetFileSource
    }
}
