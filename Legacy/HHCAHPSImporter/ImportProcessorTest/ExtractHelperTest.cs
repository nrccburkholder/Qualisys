using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HHCAHPSImporter.ImportProcessor.Extractors;
using HHCAHPSImporter.ImportProcessor.DAL.Generated;
using System.Xml.Linq;
using System.Linq;
using System.Collections.Generic;

namespace HHCAHPS.ImportProcessorTest
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

        private static void AssertGetLinesForFixedWidth(string fileContents, params string[] expectedResult)
        {
            var lines = ExtractHelper.GetLinesForFixedWidthFile(fileContents).ToList();
            CollectionAssert.AreEqual(expectedResult, lines);
        }

        private static void AssertAddTrailingCommas(string fileContents, string expectedResult)
        {
            var result = ExtractHelper.AddTrailingCommas(fileContents);
            Assert.AreEqual(expectedResult, result);
        }

        private static void AssertNullableDateTimeToString(DateTime? date, string expectedResult)
        {
            var result = date.ToString("MMddyyyy");
            Assert.AreEqual(expectedResult, result);
        }

        private static void AssertConvertDateFormat(string value, string expectedResult)
        {
            var result = ExtractHelper.ConvertDateFormat(value);
            Assert.AreEqual(expectedResult, result);
        }

        private static void AssertColumnsWithData(string line, int expectedCount)
        {
            var count = ExtractHelper.ColumnsWithData(line);
            Assert.AreEqual(expectedCount, count);
        }

        private static void AssertIsBlankCsvLine(string line, bool expectedResult)
        {
            var result = ExtractHelper.IsBlankCsvLine(line);
            Assert.AreEqual(expectedResult, result);
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

        #region GetLinesForFixedWidthFile

        [TestMethod]
        public void GetLinesForFixedWidthFile_OneLine_ThatLineIsReturned()
        {
            AssertGetLinesForFixedWidth("a", "a");
        }

        [TestMethod]
        public void GetLinesForFixedWidthFile_TwoLinesSeparatedByNewLineChar_TwoLinesReturned()
        {
            AssertGetLinesForFixedWidth("a\nb", "a", "b");
        }

        [TestMethod]
        public void GetLinesForFixedWidthFile_TwoLinesSeparatedByReturnAndNewLineChars_ReturnCharStrippedOut()
        {
            AssertGetLinesForFixedWidth("a\r\nb", "a", "b");
        }

        [TestMethod]
        public void GetLinesForFixedWidthFile_TwoLinesSeparatedByNewLineAndReturnChars_ReturnCharIsStrippedOut()
        {
            AssertGetLinesForFixedWidth("a\n\rb", "a", "b");
        }

        #endregion GetLinesForFixedWidthFile

        #region AddTrailingCommas

        [TestMethod]
        public void AddTrailingCommas_LinesEndWithReturnNewLine_LinesEndWithCommaNewLine()
        {
            AssertAddTrailingCommas("a\r\nb", "a,\nb,");
        }

        [TestMethod]
        public void AddTrailingCommas_LinesEndWithNewLineReturn_LinesEndWithCommaNewLine()
        {
            AssertAddTrailingCommas("a\n\rb", "a,\nb,");
        }

        [TestMethod]
        public void AddTrailingCommas_LinesEndWithNewLine_LinesEndWithCommaNewLine()
        {
            AssertAddTrailingCommas("a\nb", "a,\nb,");
        }

        #endregion AddTrailingCommas

        #region NullableDateTimeToString

        [TestMethod]
        public void NullableDateTimeToString_DateIsNull_ReturnsEmptyString()
        {
            AssertNullableDateTimeToString(null, "");
        }

        [TestMethod]
        public void NullableDateTimeToString_DateIsNotNull_ReturnsFormattedDate()
        {
            AssertNullableDateTimeToString(new DateTime(2015, 1, 2), "01022015");
        }

        #endregion NullableDateTimeToString

        #region ConvertDateFormat

        [TestMethod]
        public void ConvertDateFormat_01022015_Returns01022015()
        {
            AssertConvertDateFormat("01022015", "01022015");
        }

        [TestMethod]
        public void ConvertDateFormat_1022015_Returns01022015()
        {
            AssertConvertDateFormat("1022015", "01022015");
        }

        [TestMethod]
        public void ConvertDateFormat_01Slash02Slash2015_Returns01022015()
        {
            AssertConvertDateFormat("01/02/2015", "01022015");
        }

        [TestMethod]
        public void ConvertDateFormat_1Slash2Slash2015_Returns01022015()
        {
            AssertConvertDateFormat("1/2/2015", "01022015");
        }

        [TestMethod]
        public void ConvertDateFormat_20150102_Returns01022015()
        {
            AssertConvertDateFormat("20150102", "01022015");
        }

        #endregion ConvertDateFormat

        #region ColumnsWithData

        [TestMethod]
        public void ColumnsWithData_OneWithNonWhitespace_ReturnsOne()
        {
            AssertColumnsWithData("a", 1);
        }

        [TestMethod]
        public void ColumnsWithData_TwoWithNonWhitespace_ReturnsTwo()
        {
            AssertColumnsWithData("a,b", 2);
        }

        [TestMethod]
        public void ColumnsWithData_TwoWithNothing_ReturnsZero()
        {
            AssertColumnsWithData(",", 0);
        }

        [TestMethod]
        public void ColumnsWithData_OneWithWhitespace_ReturnsZero()
        {
            AssertColumnsWithData(" ", 0);
        }

        [TestMethod]
        public void ColumnsWithData_TwoWithWhitespace_ReturnsZero()
        {
            AssertColumnsWithData(" ,   ", 0);
        }

        [TestMethod]
        public void ColumnsWithData_ColumnHasQuotedComma_ReturnsOne()
        {
            AssertColumnsWithData("\"a,b\"", 1);
        }

        #endregion ColumnsWithData

        #region IsBlankCsvLine

        [TestMethod]
        public void IsBlankCsvLine_EmptyLine_ReturnsTrue()
        {
            AssertIsBlankCsvLine("", true);
        }

        [TestMethod]
        public void IsBlankCsvLine_WhitespaceLine_ReturnsTrue()
        {
            AssertIsBlankCsvLine(" ", true);
        }

        [TestMethod]
        public void IsBlankCsvLine_OnlyCommas_ReturnsTrue()
        {
            AssertIsBlankCsvLine(",,", true);
        }

        [TestMethod]
        public void IsBlankCsvLine_OneNonWhitespace_ReturnsFalse()
        {
            AssertIsBlankCsvLine("a", false);
        }

        [TestMethod]
        public void IsBlankCsvLine_OneNonWhitespaceOneEmpty_ReturnsFalse()
        {
            AssertIsBlankCsvLine("a,", false);
        }

        #endregion IsBlankCsvLine
    }
}
