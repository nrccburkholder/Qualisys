using HHCAHPSImporter.ImportProcessor.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using static HHCAHPSImporter.ImportProcessor.Extractors.ExtractHelper;

namespace HHCAHPSImporter.ImportProcessor.Extractors
{
    internal static class UpdateRecordMerger
    {
        public static void Merge(int sampleYear, int sampleMonth, string CCN, XDocument inputXml, IMergeRecordDb db)
        {
            if (inputXml == null) throw new ArgumentNullException(nameof(inputXml));
            if (db == null) throw new ArgumentNullException(nameof(db));

            var inputRows = GetRowsElement(inputXml);
            var existingRows = db.GetMergeRecords(sampleYear, sampleMonth, CCN);
            Merge(inputRows, existingRows);
        }

        public static void UpdateMergeRecords(int sampleYear, int sampleMonth, string CCN, XDocument inputXml, IMergeRecordDb db)
        {
            if (inputXml == null) throw new ArgumentNullException(nameof(inputXml));
            if (db == null) throw new ArgumentNullException(nameof(db));

            var inputRows = GetRowsElement(inputXml);
            db.UpdateMergeRecords(sampleYear, sampleMonth, CCN, inputRows);
        }

        private static void Merge(XElement inputRows, Dictionary<string, XElement> existingRows)
        {
            foreach (var inputRow in inputRows.Elements(RowElementName))
            {
                var matchKey = GetMatchKey(inputRow);
                inputRow.Add(new XAttribute(MatchKeyAttributeName, matchKey));

                XElement existingRow;
                if (existingRows.TryGetValue(matchKey, out existingRow))
                {
                    Merge(inputRow, existingRow);
                }
            }
        }

        private static void Merge(XElement inputRow, XElement existingRow)
        {
            var existingFields = existingRow
                .Elements(FieldElementName)
                .ToDictionary(f => f.Attribute(FieldAttributeName).Value, f => f.Value);

            var fields = inputRow.Elements(FieldElementName);
            foreach (var field in fields)
            {
                string existingValue;
                if (existingFields.TryGetValue(field.Attribute(FieldAttributeName).Value, out existingValue))
                {
                    field.Value = Merge(field.Value, existingValue);
                }
            }
        }

        private static string Merge(string inputValue, string existingValue)
        {
            if (inputValue == UpdateToBlankDesignator) return "";
            if (!string.IsNullOrEmpty(inputValue)) return inputValue;
            return existingValue;
        }

        private static string GetMatchKey(XElement row)
        {
            var patientId = GetFieldValue(row, PatientIDField);
            var dateOfBirth = GetFieldValue(row, PatientDateofBirthField);

            return $"{patientId}_{dateOfBirth}";
        }
    }
}
