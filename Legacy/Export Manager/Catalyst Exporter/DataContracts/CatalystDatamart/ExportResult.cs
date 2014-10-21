using System;
using System.Collections.Generic;

namespace Nrc.CatalystExporter.DataContracts
{
    public class ExportResult
    {
        //v_ClientStudySurvey sv
        public int CatalystClientId { get; set; }
        public string QualisysClientId { get; set; }
        public int CatalystStudyId { get; set; }
        public string QualisysStudyId { get; set; }
        public int CatalystSurveyId { get; set; }
        public string QualisysSurveyId { get; set; }
        //SampleUnit su
        public int CatalystSampleUnitId { get; set; }
        //DataSourceKey - SampleUnit suKey
        public string QualisysSampleUnitId { get; set; }
        //SamplePopulation sp
        public int CatalystSamplePopulationId { get; set; }
        public string QualisysSamplePopulationId { get; set; } //DataSourceKey - SamplePopulation spKey
        public int SampleSetID { get; set; }
        public int DispositionID { get; set; }
        public int CahpsDispositionID { get; set; }
        public bool IsCahpsDispositionComplete { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string City { get; set; }
        public string Province { get; set; }
        public string PostalCode { get; set; }
        public bool? IsMale { get; set; }
        public string Gender { get; set; }
        public int? Age { get; set; }
        public int? LanguageID { get; set; }
        public DateTime? AdmitDate { get; set; }
        public DateTime? DischargeDate { get; set; }
        public DateTime? ServiceDate { get; set; }
        public DateTime? ReportDate { get; set; }
        //QuestionForm qf
        public DateTime? SurveyReturnDate { get; set; }
        //ResponseBubble rb
        public int? QuestionNumber { get; set; }
        public int? ResponseValues { get; set; }
        //LocalizedText - SurveyQuestion sqLT
        public string QuestionLabel { get; set; }
        //LocalizedText - ScaleItem siLT
        public string ScaleLabel { get; set; }
        //SurveyQuestion sq
        public string Section { get; set; }
        //QuestionSet qs
        public string Dimension { get; set; }
        //ResponseComment rc
        public string UnmaskedResponse { get; set; }
        public string MaskedResponse { get; set; }
        public string LithoCode { get; set; }
        public string UnitName { get; set; }

        public int? DaysFromFirstMailing { get; set; }
        public int? DaysFromCurrentMailing { get; set; }

        public DateTime? ExpirationDate { get; set; }
        public DateTime? UndeliverableDate { get; set; }
        public DateTime? SampleDate { get; set; }
                
        public string CahpsDispLabel { get; set; }        

        public string MedicareProviderNumber { get; set; }

        public bool? HCAHPS { get; set; }
        public bool? HHCAHPS { get; set; }

        public string HCAHPSReportable { get; set; }

        public int? HHCAHPSDisp { get; set; }
                

        //For use in Raw export to determine which fields are question data
        public static List<string> QuestionDataPropertyNames()
        {
            return new List<string>(new string[] 
            { 
                "QuestionNumber", 
                "ResponseValues", 
                "QuestionLabel", 
                "ScaleLabel", 
                "Section", 
                "Dimension" 
            });
        }
        //For use in Raw export to determine which fields are comment data
        public static List<string> CommentDataPropertyNames()
        {
            return new List<string>(new string[] 
            { 
                "UnmaskedResponse", 
                "MaskedResponse" 
            });
        }
    }

    public enum ExportDateType
    {
        Report_Date = 0,
        Return_Date = 1
    }
}
