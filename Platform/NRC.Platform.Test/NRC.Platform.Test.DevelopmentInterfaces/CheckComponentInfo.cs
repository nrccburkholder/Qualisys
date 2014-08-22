using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class CheckComponentInfo
    {

        public int CheckComponentInfoId { get; set; }
        public string ComponentDesc { get; set; }
        public string ComponentDisplayName { get; set; }
        public string ComponentTypeName { get; set; }
        public string ComponentAssemblyPath { get; set; }
        public List<Check> Checks { get; set; }

    }
}
