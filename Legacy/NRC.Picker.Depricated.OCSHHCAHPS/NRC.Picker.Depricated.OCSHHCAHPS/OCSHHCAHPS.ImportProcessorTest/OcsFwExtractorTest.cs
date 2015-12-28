using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using ClientDetail = NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.ClientDetail;

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
        //    extractor.Extract(new ClientDetail(), @"C:\Users\bgoble\Documents\CodeGen\OCSBigFixedWidth.txt");
        //}
    }
}
