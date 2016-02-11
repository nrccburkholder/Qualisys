using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using HHCAHPSImporter.ImportProcessor.Extractors;

namespace HHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class CmsCsvExtractorTest
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_ClientIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new CmsCsvExtractor();
            extractor.Extract(null, "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_FileIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new CmsCsvExtractor();
            extractor.Extract(new ClientDetail(), null);
        }

        //[TestMethod]
        //public void Extract_BigFile()
        //{
        //    var extractor = new CmsCsvExtractor();
        //    extractor.Extract(new ClientDetail(), @"C:\TestFiles\OCS\CMSBigCSV.txt");
        //}
    }
}
