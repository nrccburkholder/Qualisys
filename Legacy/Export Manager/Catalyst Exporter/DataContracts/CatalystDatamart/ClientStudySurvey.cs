
namespace Nrc.CatalystExporter.DataContracts
{
    public class ClientStudySurvey
    {
        public int ClientID { get; set; }
        public string ClientName { get; set; }
        public string Client_ID { get; set; }
        public bool ClientIsActive { get; set; }
        public bool? IsCatalystClient { get; set; }
        public string ClientGroup { get; set; }
        public string ClientGroup_id { get; set; }
        public int StudyID { get; set; }
        public string Study_ID { get; set; }
        public string StudyName { get; set; }
        public byte? FirstMonthOfFiscalYear { get; set; }
        public short? FiscalYearOffset { get; set; }
        public bool StudyIsActive { get; set; }
        public int? AssignedEmployeeID { get; set; }
        public string AssignedEmployeeFirstName { get; set; }
        public string AssignedEmployeeLastName { get; set; }
        public string AssignedEmployeeEmail { get; set; }
        public int SurveyID { get; set; }
        public string Survey_ID { get; set; }
        public string SurveyName { get; set; }
        public string SurveyType { get; set; }
        public string ReportDateType { get; set; }
        public string Country { get; set; }
        public string CahpsType { get; set; }
        public int? SurveyTypeID { get; set; }
        public int? ReportDateTypeID { get; set; }
        public int? CountryID { get; set; }
        public int? CahpsTypeID { get; set; }
        public bool SurveyIsActive { get; set; }
        public int? DataSourceID { get; set; }
        public string DataSource { get; set; }
    }
}