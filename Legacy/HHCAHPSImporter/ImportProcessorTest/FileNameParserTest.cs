using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.Extractors;

namespace ImportProcessorTest
{
    [TestClass]
    public class FileNameParserTest
    {
        [TestMethod]
        public void GetCCN_NrcFile_ReturnsCCN()
        {
            var ccn = FileNameParser.GetCCN(@"56014_15990_OCS240053_HHCAHPS_52014_09242015.csv");
            Assert.AreEqual("240053", ccn);
        }

        [TestMethod]
        public void GetCCN_NrcFileWithFullPathContainingConflictingMatch_ReturnsCCN()
        {
            var ccn = FileNameParser.GetCCN(@"C:\OCS123456_\56014_15990_OCS240053_HHCAHPS_52014_09242015.csv");
            Assert.AreEqual("240053", ccn);
        }

        [TestMethod]
        public void GetCCN_DirectFromClientFile_ReturnsCCN()
        {
            var ccn = FileNameParser.GetCCN(@"HHCAHPS_240053_13_09242015.csv");
            Assert.AreEqual("240053", ccn);
        }

        [TestMethod]
        public void GetCCN_DirectFromClientFileWithFullPathContainingConflictingMatch_ReturnsCCN()
        {
            var ccn = FileNameParser.GetCCN(@"C:\HHCAHPS_123456_\HHCAHPS_240053_13_09242015.csv");
            Assert.AreEqual("240053", ccn);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void GetCCN_NotNrcOrDirectFromClientFile_ThrowsInvalidOperationException()
        {
            FileNameParser.GetCCN(@"blah");
        }

        [TestMethod]
        public void IsNrcFile_NrcFile_ReturnsTrue()
        {
            var result = FileNameParser.IsNrcFile(@"56014_15990_OCS240053_HHCAHPS_52014_09242015.csv");
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void IsNrcFile_DirectFromClientFile_ReturnsFalse()
        {
            var result = FileNameParser.IsNrcFile(@"HHCAHPS_240053_13_09242015.csv");
            Assert.IsFalse(result);
        }

        [TestMethod]
        public void IsNrcFile_NrcFileWithFullPath_ReturnsTrue()
        {
            var result = FileNameParser.IsNrcFile(@"C:\HHCAHPS_123456_\56014_15990_OCS240053_HHCAHPS_52014_09242015.csv");
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void IsDirectFromClientFile_NrcFile_ReturnsFalse()
        {
            var result = FileNameParser.IsDirectFromClientFile(@"56014_15990_OCS240053_HHCAHPS_52014_09242015.csv");
            Assert.IsFalse(result);
        }

        [TestMethod]
        public void IsDirectFromClientFile_DirectFromClientFile_ReturnsTrue()
        {
            var result = FileNameParser.IsDirectFromClientFile(@"HHCAHPS_240053_13_09242015.csv");
            Assert.IsTrue(result);
        }

        [TestMethod]
        public void IsDirectFromClientFile_DirectFromClientFileWithOCSPath_ReturnsTrue()
        {
            var result = FileNameParser.IsDirectFromClientFile(@"C:\OCS_123456_\HHCAHPS_240053_13_09242015.csv");
            Assert.IsTrue(result);
        }
    }
}
