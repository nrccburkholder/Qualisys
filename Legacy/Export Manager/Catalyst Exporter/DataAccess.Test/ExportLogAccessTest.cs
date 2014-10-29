using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Nrc.CatalystExporter.Logging;
using Nrc.CatalystExporter.DataAccess;
using Nrc.CatalystExporter.DataContracts;
using System.Data.Entity;

namespace DataAccess.Test
{
    [TestClass]
    public class ExportLogAccessTest
    {
        private UserContext user = new UserContext("UnitTest");
        private ExportLogAccess _logAccess = new ExportLogAccess();

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
            ExportLog log = new ExportLog()
            {
                Location = name,
                StartDate = new DateTime(2012, 1, 1),
                EndDate = new DateTime(2012, 2, 1),
            };

            log.FileDefinitions = new List<FileDefinition>();
            log.FileDefinitions.Add(new FileDefinition()
                {
                    Name = name,
                    FileType = (int)FileType.CSV,
                    ClientId = 1,
                    StudyId = 2,
                    SurveyId = 3
                });

            log = _logAccess.Save(log, user);
            log.EndDate = new DateTime(2012, 3, 1);
            log = _logAccess.Save(log, user);

            var log2 = _logAccess.Find(log.Id, user);
            var log3 = _logAccess.Find_IncludeColumns(log.Id, user);

            Assert.AreEqual(log.Id, log2.Id);
            Assert.AreEqual(name, log2.FileDefinitions.FirstOrDefault().Name);
            Assert.AreEqual(log.Id, log3.Id);
            Assert.IsNotNull(log3.FileDefinitions.FirstOrDefault().Columns);
        }

        [TestMethod]
        public void SaveManyAndFindMany()
        {
            var name = Guid.NewGuid().ToString();
            ExportLog log = new ExportLog()
            {
                Location = name,
                StartDate = new DateTime(2012, 1, 1),
                EndDate = new DateTime(2012, 2, 1),              
            };

            log.FileDefinitions = new List<FileDefinition>();
            log.FileDefinitions.Add(new FileDefinition()
                {
                    Name = name,
                    FileType = (int)FileType.CSV,
                    ClientId = 1,
                    StudyId = 2,
                    SurveyId = 4
                });

            log = _logAccess.Save(log, user);
            log.EndDate = new DateTime(2012, 3, 1);

            ExportLog log2 = new ExportLog()
            {
                Location = name,
                StartDate = new DateTime(2012, 1, 1),
                EndDate = new DateTime(2012, 2, 1)
            };

            log2.FileDefinitions = new List<FileDefinition>();
            log2.FileDefinitions.Add(new FileDefinition()
                {
                    Name = name,
                    FileType = (int)FileType.CSV,
                    ClientId = 1,
                    StudyId = 2,
                    SurveyId = 5
                });

            _logAccess.SaveMany(new ExportLog[] { log, log2 }, user);

            var manyBySurvId = _logAccess.FindManyBySurveyIds(new int[] { 4, 5 }, user);
            var manyById = _logAccess.FindMany(manyBySurvId.Select(s => s.Id).ToArray(), user);
            var manyIncludeColumns = _logAccess.FindMany_IncludeColumns(manyBySurvId.Select(s => s.Id).ToArray(), user);

            Assert.AreEqual(2, manyById.Length);
            Assert.AreEqual(2, manyBySurvId.Length);
            Assert.AreEqual(2, manyIncludeColumns.Length);
        }
    }
}
