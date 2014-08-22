using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class Check
    {
        public int CheckId { get; set; }
        public int TestCaseId { get; set; }
        public string ExpectedResult { get; set; }
        public string CheckDescription { get; set; }
        public List<Result> Results { get; set; }
        public List<Resource> Resources { get; set; }
        public ICheckComponent Component { get; set; }
        public CheckComponentInfo CheckComponentInfo { get; set; }
        public string CheckComponentName { get; set; }
        public int CheckComponentInfoId { get; set; }
        public bool DeleteThis { get; set; }

        public Check()
        {
            Results = new List<Result>();
            Resources = new List<Resource>();
            CheckId = 0;
            DeleteThis = false;
        }

        public Check(CheckComponentInfo checkInfo, List<Resource> checkResources, string expectedResult)
        {
            Resources = checkResources;
            ExpectedResult = expectedResult;
            CheckComponentInfo = checkInfo;
            CheckComponentInfoId = checkInfo.CheckComponentInfoId;
            CheckComponentName = checkInfo.ComponentDisplayName;
            DeleteThis = false;
        }
    }
}
