using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Nrc.CatalystExporter.DataAccess;
using Nrc.CatalystExporter.Logging;
using System.Data.Entity;
using Nrc.CatalystExporter.DataContracts;

namespace DataAccess.Test
{
    [TestClass]
    public class ColumnDefintionAccessTest
    {
        private UserContext user = new UserContext("UnitTest");
        private ColumnDefinitionAccess _columnAccess = new ColumnDefinitionAccess();

        [TestInitialize]
        public void Startup()
        {
            //Start fresh each test
            System.Data.Entity.Database.SetInitializer<CatalystExportContext>(new DropCreateDatabaseAlways<CatalystExportContext>());
        }


        [TestMethod]
        public void SaveAndFind()
        {
            FileDefinitionAccess _fileAccess = new FileDefinitionAccess();
            var fileDef = new FileDefinition()
            {
                ClientId = 1,
                StudyId = 2,
                SurveyId = 3,
                FileType = 0,
                Delimiter = ",",
                Name = ""
            };
            fileDef = _fileAccess.Save(fileDef, user);

            var name = Guid.NewGuid().ToString();
            var col = new ColumnDefinition()
            {
                ColumnOrder = 0,
                FieldName = name,
                FileDefinitionId = fileDef.Id
            };

            col = _columnAccess.Save(col, user);

            var col2 = _columnAccess.Find(col.Id, user);

            Assert.AreEqual(col.Id, col2.Id);
            Assert.AreEqual(name, col2.FieldName);
        }

        [TestMethod]
        public void SaveManyAndFindMany()
        {
            FileDefinitionAccess _fileAccess = new FileDefinitionAccess();
            var fileDef = new FileDefinition()
            {
                ClientId = 1,
                StudyId = 2,
                SurveyId = 3,
                FileType = 0,
                Delimiter = ",",
                Name = ""
            };
            fileDef = _fileAccess.Save(fileDef, user);

            var name = Guid.NewGuid().ToString();
            var col = new ColumnDefinition()
            {
                ColumnOrder = 0,
                FieldName = name,
                FileDefinitionId = fileDef.Id
            };
            var col2 = new ColumnDefinition()
            {
                ColumnOrder = 1,
                FieldName = name,
                FileDefinitionId = fileDef.Id
            };

            _columnAccess.SaveMany(new ColumnDefinition[] { col, col2 }, user);

            var manyByLogId = _columnAccess.FindManyByFileDefinitionId(fileDef.Id, user);
            var manyById = _columnAccess.FindMany(manyByLogId.Select(s => s.Id).ToArray(), user);

            Assert.AreEqual(2, manyByLogId.Length);
            Assert.AreEqual(2, manyById.Length);
        }
    }
}
