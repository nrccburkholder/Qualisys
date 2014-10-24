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
    public class ScheduledExportAccessTest
    {
        private UserContext user = new UserContext("UnitTest");
        private ScheduledExportAccess _scheduleAccess = new ScheduledExportAccess();

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
            ScheduledExport sched = new ScheduledExport()
            {
                RunInterval = (int)IntervalType.Weeks,
                RunIntervalCount = 2,
                DataInterval = (int)IntervalType.Months,
                DataIntervalCount = 1,
                NextRunDate = DateTime.Today.AddDays(1),
                IsActive = true,
            };

            sched.FileDefinitions = new List<FileDefinition>();
            sched.FileDefinitions.Add(new FileDefinition()
                {
                    Name = name,
                    FileType = (int)FileType.CSV,
                    ClientId = 1,
                    StudyId = 2,
                    SurveyId = 3
                });

            sched = _scheduleAccess.Save(sched, user);

            var log2 = _scheduleAccess.Find(sched.Id, user);

            Assert.AreEqual(sched.Id, log2.Id);
            Assert.AreEqual(name, log2.FileDefinitions.FirstOrDefault().Name);
        }

        [TestMethod]
        public void SaveManyAndFindMany()
        {
            var name = Guid.NewGuid().ToString();
            ScheduledExport sched = new ScheduledExport()
            {
                RunInterval = (int)IntervalType.Months,
                RunIntervalCount = 1,
                DataInterval = (int)IntervalType.Months,
                DataIntervalCount = 1,
                NextRunDate = DateTime.Today,
                IsActive = true,
            };

            sched.FileDefinitions = new List<FileDefinition>();
            sched.FileDefinitions.Add(new FileDefinition()
                {
                    Name = name,
                    FileType = (int)FileType.CSV,
                    ClientId = 1,
                    StudyId = 2,
                    SurveyId = 4
                });

            ScheduledExport sched2 = new ScheduledExport()
            {
                RunInterval = (int)IntervalType.Weeks,
                RunIntervalCount = 3,
                DataInterval = (int)IntervalType.Months,
                DataIntervalCount = 1,
                NextRunDate = DateTime.Today.AddDays(1),
                IsActive = true,
            };

            sched2.FileDefinitions = new List<FileDefinition>();
            sched2.FileDefinitions.Add(new FileDefinition()
            {
                Name = name,
                FileType = (int)FileType.CSV,
                ClientId = 1,
                StudyId = 2,
                SurveyId = 5
            });


            _scheduleAccess.SaveMany(new ScheduledExport[] { sched, sched2 }, user);

            var allActive = _scheduleAccess.FindAllActive(user);
            var manyByDay = _scheduleAccess.FindManyByDay_IncludeColumns(user);

            Assert.AreEqual(2, allActive.Length);
            Assert.AreEqual(1, manyByDay.Length);
        }
    }
}
