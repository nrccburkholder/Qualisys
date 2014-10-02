using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class RunEnvironment
    {
        public int EId { get; set; }
        public string EnvName { get; set; }
        public string EnvDesc { get; set; }

        public RunEnvironment()
        {
        }
        public RunEnvironment(string name, string desc)
        {
            EnvName = name;
            EnvDesc = desc;
        }
    }
}
