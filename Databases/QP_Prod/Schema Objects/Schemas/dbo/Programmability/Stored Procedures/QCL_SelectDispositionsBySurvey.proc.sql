/********************************************************************************************************/  
/*										                        */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns two  	*/  
/* datasets.  The first dataset contains the dispositions and actions available for the survey. 	*/  
/* The second returns the client name, study name, survey name, and employee email for the survey. 	*/  
/*                        										*/  
/* Date Created:  10/11/2005                    							*/  
/*                        										*/  
/* Created by:  Brian Dohmen                    							*/  
/*                        										*/  
/********************************************************************************************************/  
CREATE PROCEDURE [dbo].[QCL_SelectDispositionsBySurvey]  
    @SurveyID INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
DECLARE @CountryID INT, @DispositionListID INT  
  
--Get the disposition list tied to the survey  
SELECT @DispositionListID=DispositionList_id  
FROM DispositionListSurvey  
WHERE Survey_id=@SurveyID  

  --Get the Country so we can get the appropriate default list  
  SELECT @CountryID=numParam_Value  
  FROM QualPro_Params  
  WHERE strParam_nm='Country'  
  
IF @DispositionListID IS NULL  
BEGIN  
--check for non-default cases, such as ACOCAHPS which has its own Disposition List
	declare @SurveyType_id int
	declare @SurveyType_dsc varchar(50)

	select @SurveyType_id = SurveyType_id from survey_def where Survey_id = @SurveyID
	select @SurveyType_dsc = SurveyType_dsc from surveytype where surveytype_id = @SurveyType_id
	 SELECT TOP 1 @DispositionListID=DispositionList_id  
	  FROM DispositionList  
	  WHERE Country_id=@CountryID  
	  AND bitDefault=0  
	  AND charindex(@SurveyType_dsc, strDispositionList_nm) > 0
	  ORDER BY DispositionList_id  
--end check for non-default cases
END
  
--If there is not a list tied to the survey, we will need to get   
--  the default list for the country  
IF @DispositionListID IS NULL  
BEGIN  
  
  --Get the default List  
  SELECT TOP 1 @DispositionListID=DispositionList_id  
  FROM DispositionList  
  WHERE Country_id=@CountryID  
  AND bitDefault=1  
  ORDER BY DispositionList_id  
  
END  
  
--If there are multiple languages for the survey, select all   
--  dispositions from the list.    
IF (SELECT COUNT(*) FROM SurveyLanguage WHERE Survey_id=@SurveyID)>1  
  
  SELECT d.Disposition_id, strDispositionLabel, Action_id  
  FROM Disposition d, DispositionListDef dl  
  WHERE dl.DispositionList_id=@DispositionListID  
  AND dl.Disposition_id=d.Disposition_id  
  
ELSE  
  
  --Select all dispositions except the additional language  
  SELECT d.Disposition_id, strDispositionLabel, Action_id  
  FROM Disposition d, DispositionListDef dl  
  WHERE dl.DispositionList_id=@DispositionListID
  AND dl.Disposition_id=d.Disposition_id  
  AND Action_id<>3  
  
--Now to get the second dataset.  
SELECT strClient_nm, strStudy_nm, strSurvey_nm, strEmail  
FROM Survey_def sd, Study s, Client c, Employee e  
WHERE sd.Survey_id=@SurveyID  
AND sd.Study_id=s.Study_id  
AND s.Client_id=c.Client_id  
AND s.ADEmployee_id=e.Employee_id  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


