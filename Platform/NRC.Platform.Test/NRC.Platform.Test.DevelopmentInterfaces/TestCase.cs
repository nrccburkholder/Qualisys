using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class TestCase
    {
        public int TestCaseId { get; set; }
        public int Rank { get; set; }
        public string TestCaseDesc { get; set; }
        public int Passed { get; set; }
        public int Failed { get; set; }
        public int Blocked { get; set; }
        public int NotRun { get; set; }
        public int NA { get; set; }
        public bool IsActive { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string FixtureName { get; set; }
        public string TagString { get; set; }
        public bool IsManual { get; set; }
        public string ExpectedResult { get; set; }
        public string ActualResult { get; set; }
        public string Status { get; set; }
        public DateTime CreatedDate { get; set; }
        public List<Tag> Tags { get; set; }
        public List<Resource> Resources { get; set; }
        public List<Check> Checks { get; set; }
        public List<TestcaseStep> TestcaseSteps { get; set; }
        public FixtureInfo FixtureInfo { get; set; }
        public int FixtureInfoId { get; set; }
        public ITestFixture Fixture { get; set; }
        public TestRun TestRun { get; set; }
        public Exception Exception { get; set; }
        public DateTime? LastRunTime { get; set; }
        public Dictionary<string, object> RuntimeVariablesTable { get; set; }

        public TestCase()
        {
            Tags = new List<Tag>();
            TestcaseSteps = new List<TestcaseStep>();
            Resources = new List<Resource>();
            Checks = new List<Check>();
            RuntimeVariablesTable = new Dictionary<string, object>();
            Rank = 0;
            ExpectedResult = "";
        }

        public TestCase(string testCaseDesc, List<Check> checks, List<Resource> resources, List<Tag> tags, FixtureInfo fixtureInfo)
        {
            TestCaseId = 0;
            TestCaseDesc = testCaseDesc;
            Checks = checks;
            Resources = resources;
            FixtureInfo = fixtureInfo;
            Tags = tags;
            ExpectedResult = "";
            IsActive = true;
            CreatedDate = DateTime.Now;
            ModifiedDate = DateTime.Now;
            RuntimeVariablesTable = new Dictionary<string, object>();
        }

        public List<Resource> GetResourceValues(string resourceName)
        {
            return Resources.Where(c => c.ResourceName.Contains(resourceName)).ToList();
        }

        //allows overriding of preset test case resources
        public void SetResourceValues ( string resourceName, string resourceValue )
        {
            List<Resource> resources = Resources.Where( c => c.ResourceName.Contains( resourceName ) ).ToList();
            foreach (Resource res in resources)
            {
                res.ResourceValue = resourceValue;
            }
        }
    }
}
