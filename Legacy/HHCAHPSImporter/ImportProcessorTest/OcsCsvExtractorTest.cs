using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.Extractors;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;

namespace HHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class OcsCsvExtractorTest
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_ClientIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new OcsCsvExtractor();
            extractor.Extract(null, "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_FileIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new OcsCsvExtractor();
            extractor.Extract(new ClientDetail(), null);
        }

        //[TestMethod]
        //public void Extract_BigFile()
        //{
        //    var extractor = new OcsCsvExtractor();
        //    extractor.Extract(new ClientDetail(), @"C:\TestFiles\OCS\OCSBigCSV.txt");
        //}
    }
}
