using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.Extractors;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;

namespace HHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class PtctCsvExtractorTest
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_ClientIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new PtctCsvExtractor();
            extractor.Extract(null, "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_FileIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new PtctCsvExtractor();
            extractor.Extract(new ClientDetail(), null);
        }

        //[TestMethod]
        //public void Extract_BigFile()
        //{
        //    var extractor = new PtctCsvExtractor();
        //    extractor.Extract(new ClientDetail(), @"C:\TestFiles\OCS\PTCTBigCSV.txt");
        //}
    }
}
