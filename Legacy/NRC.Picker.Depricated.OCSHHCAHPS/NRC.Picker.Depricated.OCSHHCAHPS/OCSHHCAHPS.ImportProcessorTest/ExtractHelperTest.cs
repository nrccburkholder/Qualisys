using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.Extractors;
using NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated;
using System.Xml.Linq;
using System.Linq;
using System.Collections.Generic;

namespace OCSHHCAHPS.ImportProcessorTest
{
    [TestClass]
    public class ExtractHelperTest
    {
        #region Helpers

        private static void AssertAttribute(IEnumerable<XAttribute> attributes, string name, string value)
        {
            var attribute = attributes.FirstOrDefault(a => a.Name == name);
            Assert.IsNotNull(attribute);
            Assert.AreEqual(value, attribute.Value);
        }

        #endregion Helpers

        #region CreateEmptyDocument

        [TestMethod]
        public void CreateEmptyDocument_ReturnsDocument()
        {
            var xml = ExtractHelper.CreateEmptyDocument();
            Assert.IsNotNull(xml);
        }

        [TestMethod]
        public void CreateEmptyDocument_HasRoot()
        {
            var xml = ExtractHelper.CreateEmptyDocument();
            Assert.IsNotNull(xml.Root);
            Assert.AreEqual(ExtractHelper.RootElementName, xml.Root.Name);
        }

        [TestMethod]
        public void CreateEmptyDocument_HasMetadataElement()
        {
            var xml = ExtractHelper.CreateEmptyDocument();
            Assert.IsNotNull(xml.Root.Element(ExtractHelper.MetadataElementName));
        }

        [TestMethod]
        public void CreateEmptyDocument_HasRowsElement()
        {
            var xml = ExtractHelper.CreateEmptyDocument();
            Assert.IsNotNull(xml.Root.Element(ExtractHelper.RowsElementName));
        }

        #endregion CreateEmptyDocument

        #region CreateRootAttributes

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void CreateRootAttributes_ClientIsNull_ArgumentNullExceptionIsThrown()
        {
            ExtractHelper.CreateRootAttributes(null, "file.csv");
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void CreateRootAttributes_FileNameIsNull_ArgumentNullExceptionIsThrown()
        {
            ExtractHelper.CreateRootAttributes(new ClientDetail(), null);
        }

        [TestMethod]
        public void CreateRootAttributes_SourceFileIsSet()
        {
            var attributes = ExtractHelper.CreateRootAttributes(new ClientDetail(), "file.csv");
            AssertAttribute(attributes, ExtractHelper.SourceFileAttributeName, "file.csv");
        }

        [TestMethod]
        public void CreateRootAttributes_ClientIdIsSet()
        {
            var attributes = ExtractHelper.CreateRootAttributes(new ClientDetail { Client_id = 1 }, "file.csv");
            AssertAttribute(attributes, ExtractHelper.ClientIdAttributeName, "1");
        }

        [TestMethod]
        public void CreateRootAttributes_StudyIdIsSet()
        {
            var attributes = ExtractHelper.CreateRootAttributes(new ClientDetail { Study_id = 1 }, "file.csv");
            AssertAttribute(attributes, ExtractHelper.StudyIdAttributeName, "1");
        }

        [TestMethod]
        public void CreateRootAttributes_SurveyIdIsSet()
        {
            var attributes = ExtractHelper.CreateRootAttributes(new ClientDetail { Survey_id = 1 }, "file.csv");
            AssertAttribute(attributes, ExtractHelper.SurveyIdAttributeName, "1");
        }

        [TestMethod]
        public void CreateRootAttributes_ContractedLanguagesIsSet()
        {
            var attributes = ExtractHelper.CreateRootAttributes(new ClientDetail { Languages = "A,B,C" }, "file.csv");
            AssertAttribute(attributes, ExtractHelper.ContractedLanguagesAttributeName, "A,B,C");
        }

        #endregion CreateRootAttributes

        #region CreateTransformRow

        [TestMethod]
        public void CreateTransformRow_ReturnsRElement()
        {
            var row = ExtractHelper.CreateTransformRow(1);
            Assert.IsNotNull(row);
            Assert.AreEqual(ExtractHelper.RowElementName, row.Name);
        }

        [TestMethod]
        public void CreateTransformRow_IdIsSet()
        {
            var row = ExtractHelper.CreateTransformRow(1);
            var id = row.Attribute(ExtractHelper.IdAttributeName);
            Assert.IsNotNull(id);
            Assert.AreEqual("1", id.Value);
        }

        [TestMethod]
        public void CreateTransformRow_FieldsAreAdded()
        {
            var row = ExtractHelper.CreateTransformRow(1, new XElement("a"));
            var fields = row.Elements();
            Assert.AreEqual(1, fields.Count());
            Assert.AreEqual("a", fields.First().Name);
        }

        #endregion

        #region CreateFieldElement

        [TestMethod]
        public void CreateFieldElement_NvElementIsCreated()
        {
            var field = ExtractHelper.CreateFieldElement("a", "");
            Assert.IsNotNull(field);
            Assert.AreEqual(ExtractHelper.FieldElementName, field.Name);
        }

        [TestMethod]
        public void CreateFieldElement_NvValueIsSet()
        {
            var field = ExtractHelper.CreateFieldElement("a", "b");
            Assert.AreEqual("b", field.Value);
        }

        [TestMethod]
        public void CreateFieldElement_NAttributeIsSet()
        {
            var field = ExtractHelper.CreateFieldElement("a", "b");
            var attribute = field.Attribute(ExtractHelper.FieldAttributeName);
            Assert.IsNotNull(attribute);
            Assert.AreEqual("a", attribute.Value);
        }

        #endregion CreateFieldElement

        #region GetMetadataElement

        [TestMethod]
        public void GetMetadataElement_HasMetadataElement_ReturnsMetadataElement()
        {
            var xml =
                new XDocument(
                    new XElement(ExtractHelper.RootElementName,
                        new XElement(ExtractHelper.MetadataElementName)
                ));

            var element = ExtractHelper.GetMetadataElement(xml);
            Assert.IsNotNull(element);
            Assert.AreEqual(ExtractHelper.MetadataElementName, element.Name);
        }

        #endregion GetMetadataElement

        #region GetRowsElement

        [TestMethod]
        public void GetRowsElement_HasRowsElement_ReturnsRowsElement()
        {
            var xml =
                new XDocument(
                    new XElement(ExtractHelper.RootElementName,
                        new XElement(ExtractHelper.RowsElementName)
                ));

            var element = ExtractHelper.GetRowsElement(xml);
            Assert.IsNotNull(element);
            Assert.AreEqual(ExtractHelper.RowsElementName, element.Name);
        }

        #endregion GetRowsElement
    }
}
