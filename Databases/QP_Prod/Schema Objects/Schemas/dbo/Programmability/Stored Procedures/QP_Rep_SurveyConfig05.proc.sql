CREATE PROCEDURE QP_Rep_SurveyConfig05  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50)  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
DECLARE @intSurvey_id INT, @intStudy_id int  
SELECT @intSurvey_id=sd.Survey_id, @intStudy_id=sd.Study_id  
FROM Survey_def sd, Study s, Client c  
WHERE c.strClient_nm=@Client  
  AND s.strStudy_nm=@Study  
  AND sd.strSurvey_nm=@Survey  
  AND c.Client_id=s.Client_id  
  AND s.Study_id=sd.Study_id  
  
--Modified 11/1/2 BD added cover letter name to the results  
-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (
	SELECT 'Survey Configuration' AS SheetNameDummy, 
	       CASE WHEN bitFirstSurvey=1 THEN '' ELSE '{'+CONVERT(VARCHAR,intIntervalDays)+' days} ' END + strMailingStep_nm AS [{Delay} / Mailing Step],   
	       CASE WHEN bitSendSurvey=1 THEN 'Yes' ELSE 'No' END AS [Attach Questions?] , sc.Description [Cover Letter]  
	FROM MailingStep ms, mailingMethodology mm, Sel_Cover sc  
	WHERE ms.Methodology_id=mm.Methodology_id   
	  AND mm.Survey_id=@intSurvey_id  
	  AND ms.SelCover_id = sc.SelCover_id  
	  AND ms.Survey_id = sc.Survey_id  
	  AND mm.bitActiveMethodology=1
		)

	SELECT 'Survey Configuration' AS SheetNameDummy, 
	       CASE WHEN bitFirstSurvey=1 THEN '' ELSE '{'+CONVERT(VARCHAR,intIntervalDays)+' days} ' END + strMailingStep_nm AS [{Delay} / Mailing Step],   
	       CASE WHEN bitSendSurvey=1 THEN 'Yes' ELSE 'No' END AS [Attach Questions?] , sc.Description [Cover Letter]  
	FROM MailingStep ms, mailingMethodology mm, Sel_Cover sc  
	WHERE ms.Methodology_id=mm.Methodology_id   
	  AND mm.Survey_id=@intSurvey_id  
	  AND ms.SelCover_id = sc.SelCover_id  
	  AND ms.Survey_id = sc.Survey_id  
	  AND mm.bitActiveMethodology=1  
ELSE
	SELECT 'Survey Configuration' AS SheetNameDummy, '' AS [Attach Questions?] , '' AS [Cover Letter]  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


