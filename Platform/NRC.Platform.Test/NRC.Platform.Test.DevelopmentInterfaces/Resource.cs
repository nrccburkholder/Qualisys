
namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class Resource
    {

        public int ResourceId { get; set; }
        public int? TestCaseId { get; set; }
        public int? CheckId { get; set; }
        public string ResourceDesc { get; set; }
        public string ResourceName { get; set; }
        public string ResourceValue { get; set; }
        public TestCase TestCase { get; set; }
        public Check Check { get; set; }
        public bool DeleteThis { get; set; }

        public Resource(string resourceDesc, string resourceName, string resourceValue)
            : this()
        {
            ResourceDesc = resourceDesc;
            ResourceName = resourceName;
            ResourceValue = resourceValue;
            DeleteThis = false;
        }

        public Resource() 
        {
            TestCaseId = null;
            CheckId = null;
            DeleteThis = false;
        }
    }
}
