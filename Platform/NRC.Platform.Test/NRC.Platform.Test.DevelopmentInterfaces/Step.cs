using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public partial class Step
    {
        public int StepId { get; set; }
        public string StepName { get; set; }
        public string StepDescription { get; set; }
        public int StepOrder { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int NumberTestCases { get; set; }

        public Step(string name, string StepString) : this()
        {
            StepName = name;
            StepDescription = StepString;
            NumberTestCases = 0;
            StepOrder = 0;
        }

        public Step()
        {
        }
    }
}
