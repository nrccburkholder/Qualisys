using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System.Xml.Linq;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class ExtractHelperTest
    {
        private XDocument XDocWithRoot()
        {
            return new XDocument(new XElement("root"));
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void SetRootAttributes_XmlIsNull_ArgumentNullExceptionIsThrown()
        {
            ExtractHelper.SetRootAttributes(null, new ClientDetail(), "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void SetRootAttributes_ClientIsNull_ArgumentNullExceptionIsThrown()
        {
            ExtractHelper.SetRootAttributes(XDocWithRoot(), null, "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void SetRootAttributes_FileNameIsNull_ArgumentNullExceptionIsThrown()
        {
            ExtractHelper.SetRootAttributes(XDocWithRoot(), new ClientDetail(), null);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void SetRootAttributes_NoRoot_InvalidOperationExceptionIsThrown()
        {
            ExtractHelper.SetRootAttributes(new XDocument(), new ClientDetail(), "file.csv");
        }

        [TestMethod]
        public void SetRootAttributes_SourceFileIsSet()
        {
            var xml = ExtractHelper.SetRootAttributes(XDocWithRoot(), new ClientDetail(), "file.csv");
            Assert.AreEqual("file.csv", xml.Root.Attribute("sourcefile").Value);
        }

        [TestMethod]
        public void SetRootAttributes_ClientIdIsSet()
        {
            var xml = ExtractHelper.SetRootAttributes(XDocWithRoot(), new ClientDetail { Client_id = 1 }, "file.csv");
            Assert.AreEqual("1", xml.Root.Attribute("client_id").Value);
        }

        [TestMethod]
        public void SetRootAttributes_StudyIdIsSet()
        {
            var xml = ExtractHelper.SetRootAttributes(XDocWithRoot(), new ClientDetail { Study_id = 1 }, "file.csv");
            Assert.AreEqual("1", xml.Root.Attribute("study_id").Value);
        }

        [TestMethod]
        public void SetRootAttributes_SurveyIdIsSet()
        {
            var xml = ExtractHelper.SetRootAttributes(XDocWithRoot(), new ClientDetail { Survey_id = 1 }, "file.csv");
            Assert.AreEqual("1", xml.Root.Attribute("survey_id").Value);
        }

        [TestMethod]
        public void SetRootAttributes_ContractedLanguagesIsSet()
        {
            var xml = ExtractHelper.SetRootAttributes(XDocWithRoot(), new ClientDetail { Languages = "A,B,C" }, "file.csv");
            Assert.AreEqual("A,B,C", xml.Root.Attribute("ContractedLanguages").Value);
        }
    }
}
