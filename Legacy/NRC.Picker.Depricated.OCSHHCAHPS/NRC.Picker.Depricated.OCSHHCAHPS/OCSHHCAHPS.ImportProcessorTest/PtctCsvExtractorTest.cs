using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;

namespace OCSHHCAHPS.ImportProcessorTest
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
