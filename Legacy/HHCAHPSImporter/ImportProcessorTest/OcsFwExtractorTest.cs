using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.Extractors;
using ClientDetail = HHCAHPSImporter.ImportProcessor.DAL.Generated.ClientDetail;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class OcsFwExtractorTest
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_ClientIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new OcsFwExtractor();
            extractor.Extract(null, "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_FileIsNull_ArgumentNullExceptionIsThrown()
        {
            var extractor = new OcsFwExtractor();
            extractor.Extract(new ClientDetail(), null);
        }

        //[TestMethod]
        //public void Extract_BigFile()
        //{
        //    var extractor = new OcsFwExtractor();
        //    extractor.Extract(new ClientDetail(), @"C:\TestFiles\OCS\OCSBigFixedWidth.txt");
        //}
    }
}
