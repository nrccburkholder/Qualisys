CREATE PROCEDURE QCL_AllowDeleteSurvey  
@SurveyId INT  
AS  
  
IF EXISTS (SELECT * 
           FROM SampleSet
           WHERE Survey_id=@SurveyID)
SELECT 0  
ELSE
SELECT 1


