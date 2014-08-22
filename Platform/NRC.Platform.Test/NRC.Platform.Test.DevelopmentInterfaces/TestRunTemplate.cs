using System;
using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class TestRunTemplate
    {

        public int TestRunTemplateId { get; set; }
        public string TestRunTemplateDescription { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public bool ANDTags { get; set; }
        public List<Tag> Tags { get; set; }
        public List<TestCase> TestCases { get; set; }
        public string TagList;
        public string TestcaseList;

        public TestRunTemplate()
        {
            Tags = new List<Tag>();
            TestCases = new List<TestCase>();
            ANDTags = false;
        }
    }
}
