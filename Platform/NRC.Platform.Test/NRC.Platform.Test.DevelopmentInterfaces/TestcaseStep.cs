using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public partial class TestcaseStep
    {
        public int TestcaseStepId { get; set; }
        public int TestCaseId { get; set; }
        public string StepName { get; set; }
        public string StepDescription { get; set; }
        public int StepOrder { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string CreatedBy { get; set; }
        public string ModifiedBy { get; set; }
        public bool DeleteThis { get; set; }
        public bool Done { get; set; }

        public TestcaseStep(string desc, int order) : this()
        {
            StepDescription = desc;
            StepOrder = order;
            CreatedDate = DateTime.Now;
            ModifiedDate = DateTime.Now;
            DeleteThis = false;
            Done = false;
        }

        public TestcaseStep()
        {
            TestcaseStepId = 0;
            StepOrder = 1;
            StepName = "";
            StepDescription = "";
            CreatedDate = DateTime.Now;
            ModifiedDate = DateTime.Now;
            DeleteThis = false;
            Done = false;
        }
    }
}
