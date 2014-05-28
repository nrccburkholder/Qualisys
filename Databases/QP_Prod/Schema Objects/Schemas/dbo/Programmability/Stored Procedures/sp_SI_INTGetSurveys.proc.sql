-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets all of the surveys that have been 
--              marked returned but have not been transferred by survey ID.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetSurveys] 

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT strClient_Nm, strSurvey_Nm, Convert(varchar, Survey_id) + strTemplateCode + 
       Right('00' + Convert(varchar, LangID), 2) AS Survey_id, Count(*) AS QtySurveys 
FROM (SELECT SM.strLithoCode, CL.strClient_nm, SD.strSurvey_nm, QF.Survey_id, 
             SM.PaperConfig_id, SM.LangID, Max(PCS.intSheet_Num) AS intSheet_Num 
      FROM SentMailing SM (NOLOCK), Survey_def SD (NOLOCK), Study ST (NOLOCK), 
           Client CL (NOLOCK), QuestionForm QF (NOLOCK), PaperConfigSheet PCS (NOLOCK) 
      WHERE SM.SentMail_id = QF.SentMail_id 
        AND QF.Survey_id = SD.Survey_id 
        AND SD.Study_id = ST.Study_id 
        AND ST.Client_id = CL.Client_id 
        AND QF.datReturned > '1/1/1900' 
        AND QF.datResultsImported IS NULL 
        AND SM.PaperConfig_id = PCS.PaperConfig_id 
      GROUP BY SM.strLithoCode, CL.strClient_nm, SD.strSurvey_nm, QF.Survey_id, 
               SM.PaperConfig_id, SM.LangID 
     ) QRY, PaperConfigSheet PCS (NOLOCK), PaperSize PS (NOLOCK) 
WHERE QRY.PaperConfig_id = PCS.PaperConfig_id 
  AND QRY.intSheet_num = PCS.intSheet_Num 
  AND PCS.PaperSize_id = PS.PaperSize_id 
GROUP BY strClient_Nm, strSurvey_Nm, Convert(varchar, Survey_id) + strTemplateCode + 
         Right('00' + Convert(varchar, LangID), 2) 
ORDER BY QtySurveys DESC 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


