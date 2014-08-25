using System;
using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class Result
    {

        public int ResultId { get; set; }
        public int TestRunId { get; set; }
        public int TestCaseId { get; set; }
        public string TestCaseDescription { get; set; }
        public int CheckId { get; set; }
        public bool Passed { get; set; }
        public int RunStatusId { get; set; }
        public string RunStatus { get; set; }
        public string ExpectedResult { get; set; }
        public string ActualResult { get; set; }
        public string Browser { get; set; }
        public string Node { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public List<ResultInfo> ResultInfos { get; set; }
        public TestCase TestCase { get; set; }
        public Check Check { get; set; }
        public TestRun TestRun { get; set; }

        public Result(TestRun run, TestCase testcase, Check check, string actualResult)
        {
            TestCase = testcase;
            Check = check;
            TestRun = run;
            ActualResult = actualResult;
            CreatedDate = DateTime.Now;
            ModifiedDate = DateTime.Now;
            ResultInfos = new List<ResultInfo>();
        }

        public Result() { }

        public void AddInformation(ResultInfo.AdditionalResultLabel resultLabel, string resultInformation)
        {
            ResultInfos.Add(new ResultInfo(resultLabel, resultInformation));
        }

    }
}
