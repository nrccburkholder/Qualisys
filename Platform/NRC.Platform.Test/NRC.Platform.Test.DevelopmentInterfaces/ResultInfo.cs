
namespace NRC.Platform.Test.DevelopmentInterfaces
{
    public class ResultInfo
    {

        public int AdditionalResultInfoId { get; set; }
        public int ResultId { get; set; }
        public string AdditionalResultInfoLabel { get; set; }
        public string AdditionalResultInfo { get; set; }
        public Result Result { get; set; }

        public ResultInfo(AdditionalResultLabel additionalResultInfoLabel, string additionalResultInfo)
        {
            AdditionalResultInfoLabel = additionalResultInfoLabel.ToString("g");
            AdditionalResultInfo = additionalResultInfo;
        }

        public ResultInfo() { }
        
        public enum AdditionalResultLabel
        {
            PassOrFail,
            ResultToBeDeletedNote,//This is for results used in testing the harness, fixtures, or checks that should not be reserved
            Miscellaneous //This is so people don't misuse pre-existing tags
            //These should be types like "Performance", etc.
        }

    }
}
