using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Telerik.JustMock;
using HHCAHPSImporter.ImportProcessor.Extractors;
using System.Xml.Linq;
using System.Linq;
using System.Collections.Generic;

namespace ImportProcessorTest
{
    [TestClass]
    public class UpdateRecordMergerTest
    {
        #region Helpers

        private static XDocument CreateInput(string patientId, string dob)
        {
            var inputXml = ExtractHelper.CreateEmptyDocument();
            var rows = ExtractHelper.GetRowsElement(inputXml);
            rows.Add(ExtractHelper.CreateTransformRow(1,
                ExtractHelper.CreateFieldElement(ExtractHelper.PatientIDField, patientId),
                ExtractHelper.CreateFieldElement(ExtractHelper.PatientDateofBirthField, dob)
                ));
            return inputXml;
        }

        private static XDocument CreateInput(string patientId, string dob, string testFieldValue)
        {
            var inputXml = CreateInput(patientId, dob);
            var row = ExtractHelper.GetRowsElement(inputXml).Elements(ExtractHelper.RowElementName).First();
            row.Add(ExtractHelper.CreateFieldElement("test", testFieldValue));
            return inputXml;
        }

        private static Dictionary<string, XElement> CreateMergeRecords(string mergeKey, string fieldValue)
        {
            var field = ExtractHelper.CreateFieldElement("test", fieldValue);
            var row = ExtractHelper.CreateTransformRow(1, field);
            row.Add(new XAttribute(ExtractHelper.MatchKeyAttributeName, mergeKey));
            var mergeRecords = new Dictionary<string, XElement>
            {
                [mergeKey] = row
            };

            return mergeRecords;
        }

        private void AssertMergedValue(string inputValue, string existingValue, string expectedValue)
        {
            var mergeRecords = CreateMergeRecords("a_10201930", existingValue);

            var db = Mock.Create<IMergeRecordDb>();
            Mock.Arrange(() => db.GetMergeRecords(Arg.AnyInt, Arg.AnyInt, Arg.AnyString)).Returns(mergeRecords);

            var inputXml = CreateInput("a", "10201930", inputValue);

            UpdateRecordMerger.Merge(10, 2015, "123456", inputXml, db);

            var inputRow = ExtractHelper.GetRowsElement(inputXml).Elements(ExtractHelper.RowElementName).First();
            Assert.AreEqual(expectedValue, ExtractHelper.GetFieldValue(inputRow, "test"));
        }

        #endregion Helpers

        #region Merge

        [TestMethod]
        public void Merge_InputFieldHasValueExistingHasValue_InputValueIsUsed()
        {
            AssertMergedValue("b", "c", "b");
        }

        [TestMethod]
        public void Merge_InputFieldHasValueExistingIsBlank_InputValueIsUsed()
        {
            AssertMergedValue("b", "", "b");
        }

        [TestMethod]
        public void Merge_InputFieldIsBlankExistingHasValue_ExistingIsUsed()
        {
            AssertMergedValue("", "c", "c");
        }

        [TestMethod]
        public void Merge_InputFieldIsBlankExistingIsBlank_BlankIsUsed()
        {
            AssertMergedValue("", "", "");
        }

        [TestMethod]
        public void Merge_InputFieldIsBlankDesignatorExistingHasValue_BlankIsUsed()
        {
            AssertMergedValue(ExtractHelper.UpdateToBlankDesignator, "c", "");
        }

        #endregion Merge
    }
}
