using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class FixtureInfo
    {
        public int FixtureInfoId { get; set; }
        public string FixtureDesc { get; set; }
        public string FixtureDisplayName { get; set; }
        public string FixtureFullName { get; set; }
        public string FixtureAssemblyPath { get; set; }
        public List<TestCase> TestCases { get; set; }

        public FixtureInfo()
        {
        }

    }
}
