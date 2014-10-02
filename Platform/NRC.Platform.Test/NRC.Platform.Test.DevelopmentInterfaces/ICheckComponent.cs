using System.Collections.Generic;

namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public interface ICheckComponent
    {
        Check Check { get; set; }

        string GetActualResult(Dictionary<string, object> runtimeStateTable, Check check);

        void PerformAdditionalCheckAnalysis(Result result, Dictionary<string, object> runtimeStateTable, Check check);

        //The next two methods are at least used when creating checks, to help avoid mispelled resource names
        IEnumerable<string> GetRequiredResourceNames();//Returns a list of the resources required by this check to execute
        IEnumerable<string> GetOptionalResourceNames();//Returns a list of the additional resources that this check may sometimes need

        
    }
}
