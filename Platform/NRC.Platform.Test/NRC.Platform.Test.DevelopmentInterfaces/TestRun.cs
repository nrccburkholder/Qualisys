using System;
using System.Text;
using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class TestRun
    {
        public int TestRunId { get; set; }
        public int TestRunTemplateId { get; set; }
        public string TestRunDesc { get; set; }
        public string AppEnv { get; set; }
        public string Browser { get; set; }
        public string MachineName { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public bool IsInProgress { get; set; }
        public bool HasManual { get; set; }
        public bool ManualDone { get; set; }
        public string Tag { get; set; }
        public string TestCaseId { get; set; }
        public int CaseIndex { get; set; }
        public int TotalTestCases { get; set; }
        public int PassedCases { get; set; }
        public int FailedCases { get; set; }
        public int BlockedCases { get; set; }
        public int NACases { get; set; }
        public int NotRunCases { get; set; }
        public int PassPercent { get; set; }
        public int FailPercent { get; set; }
        public int NoResultPercent { get; set; }
        public int TagId { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public TestRunTemplate TestRunTemplate { get; set; }
        public List<TestCase> TestCases { get; set; }
        public List<Result> Results { get; set; }
        public int ScreenShotLevel { get; set; }
        public string RemoteNode { get; set; }
        //public IEnumerable<TestRun> TestRuns { get; set; }

        public TestRun(bool isInProgress)
        {
            CreateDate = DateTime.Now;
            ModifiedDate = DateTime.Now;
            IsInProgress = isInProgress;
        }

        public TestRun()
        {
        }

        public string GetResultHTML()
        {
            StringBuilder sb = new StringBuilder();
            string s = @"<div class='cluetip' 
                title='Failed: " + FailedCases.ToString() + 
                ", Passed: " + PassedCases.ToString() +
                ", Blocked: " + BlockedCases.ToString() +
                ", N/A: " + NACases.ToString() +
                ", Not Run: " + NotRunCases.ToString() + 
                "' rel='/TestRuns/GetTestcaseList?strid=" + TestRunId.ToString() + "' style='width:98%;cursor:help'>";
            sb.Append(s);

            // passed cases
            int percent = (PassedCases * 100) / TotalTestCases;
            if (percent > 0)
            {
                sb.Append("<div class='status pass' style='width:" + percent + "%;'>" + percent + "%</div>");
            }

            // na cases
            percent = (NACases * 100) / TotalTestCases;
            if (percent > 0)
            {
                sb.Append("<div class='status na' style='width:" + percent + "%;'>" + percent + "%</div>");
            }

            // blocked cases
            percent = (BlockedCases * 100) / TotalTestCases;
            if (percent > 0)
                {
                sb.Append("<div class='status block' style='width:" + percent + "%;'>" + percent + "%</div>");
                }

            // failed cases
            percent = (int)Math.Round((double)(FailedCases * 100) / TotalTestCases, MidpointRounding.ToEven);
            if (percent > 0)
                {
                sb.Append("<div class='status fail' style='width:" + percent + "%;'>" + percent + "%</div>");
                }

            // notrun cases
            percent = (NotRunCases * 100) / TotalTestCases;
            if (percent > 0)
            {
                sb.Append("<div class='status notrun' style='width:" + percent + "%;'>" + percent + "%</div>");
            }

            sb.Append("</div>");

            return sb.ToString();
        }

        public string GetTestcaseHTML()
        {
            StringBuilder sb = new StringBuilder();
            if (IsInProgress)
                sb.Append("<img class='inprogress' src='../../Content/Images/running.gif' onclick='ManualStop(" + TestRunId.ToString() + ")' />");

            sb.Append(CaseIndex.ToString());
            if (CaseIndex != TotalTestCases)
                sb.Append("/" + TotalTestCases.ToString());

            return sb.ToString();
        }

        public string GetTestRunDescriptionHTML()
        {
            StringBuilder sb = new StringBuilder();
            if (HasManual && !ManualDone)
                sb.Append(TestRunDesc + "<img class='manual' src='../../Content/Images/manual.jpg' onclick='ManualCases(" + TestRunId.ToString() + ")' title='Click to run manual test case(s) that are part of this testrun'/>");
            else
                sb.Append(TestRunDesc);
            return sb.ToString();
        }
    }
}

