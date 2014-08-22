using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public partial  class Tag
    {

        public int TagId { get; set; }
        public string Tag1 { get; set; }
        public int NumberTestCases { get; set; }
        public List<TestCase> TestCases { get; set; }
        public List<TestRunTemplate> TestRunTemplates { get; set; }

        public Tag(string tagString) : this()
        {
            Tag1 = tagString;
        }

        public Tag()
        {
            TestCases = new List<TestCase>();
            TestRunTemplates = new List<TestRunTemplate>();
        }

        public enum PriorityTag
        {
            Pri0, //Very important
            Pri1, //Important
            Pri2 //Not so important
        }

    }
}
