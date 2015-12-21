using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using System.Linq;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class OcsFwParserTest
    {
        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Extract_FileContentsAreNull_ArgumentNullExceptionIsThrown()
        {
            var parser = new OcsFwParser();
            parser.Parse(null);
        }

        [TestMethod]
        public void Extract_HasRootElement()
        {
            var parser = new OcsFwParser();
            var xml = parser.Parse("");

            Assert.AreEqual("root", xml.Elements().First().Name);
        }
    }
}
