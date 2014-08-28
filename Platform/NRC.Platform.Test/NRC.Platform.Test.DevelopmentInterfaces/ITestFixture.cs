using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public interface ITestFixture
    {
        TestCase Testcase { get; set; }

        void SetupTest(Dictionary<string, object> runtimeStateTable);
        void ExecuteTest(Dictionary<string, object> runtimeStateTable);
        void CleanupTest(Dictionary<string, object> runtimeStateTable);

        //The next two methods are at least used when creating test cases, to help avoid mispelled resource names
        IEnumerable<string> GetRequiredResourceNames();//Returns a list of the resources required by this fixture to execute any test
        IEnumerable<string> GetOptionalResourceNames();//Returns a list of the additional resources that this fixture may need for some tests
    }
}
