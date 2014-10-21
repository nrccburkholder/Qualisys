using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Nrc.CatalystExporter.Logging;
using Nrc.CatalystExporter.DataAccess;
using System.Data.Entity;
using Nrc.CatalystExporter.DataContracts;

namespace DataAccess.Test
{
    [TestClass]
    public class FileDefinitionAccessTest
    {
        private UserContext user = new UserContext("UnitTest");
        private FileDefinitionAccess _fileAccess = new FileDefinitionAccess();

        [TestInitialize]
        public void Startup()
        {
            //Start fresh each test
            System.Data.Entity.Database.SetInitializer<CatalystExportContext>(new DropCreateDatabaseAlways<CatalystExportContext>());
        }

        [TestMethod]
        public void SaveAndFind()
        {
            var name = Guid.NewGuid().ToString();
            var fileDef = new FileDefinition()
            {
                Name = name,
                FileType = (int)FileType.CSV,
                ClientId = 1,
                StudyId = 2,
                SurveyId = 3
            };

            fileDef = _fileAccess.Save(fileDef, user);

            var log2 = _fileAccess.Find(fileDef.Id, user);

            Assert.AreEqual(fileDef.Id, log2.Id);
            Assert.AreEqual(name, log2.Name);
        }

        [TestMethod]
        public void SaveManyAndFindMany()
        {
            var name = Guid.NewGuid().ToString();
            var fileDef = new FileDefinition()
            {
                Name = name,
                FileType = (int)FileType.CSV,
                ClientId = 1,
                StudyId = 2,
                SurveyId = 4
            };
            var fileDef2 = new FileDefinition()
            {
                Name = name,
                FileType = (int)FileType.CSV,
                ClientId = 1,
                StudyId = 2,
                SurveyId = 5
            };

            _fileAccess.SaveMany(new FileDefinition[] { fileDef, fileDef2 }, user);

            var many = _fileAccess.FindMany(new long[] { fileDef.Id, fileDef2.Id }, user);

            Assert.AreEqual(2, many.Length);
        }
    }
}
