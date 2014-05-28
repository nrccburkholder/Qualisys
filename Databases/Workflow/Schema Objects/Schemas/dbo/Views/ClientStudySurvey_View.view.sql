CREATE VIEW ClientStudySurvey_View  
AS  
SELECT c.Client_ID, 
       c.strClient_NM,
       s.Study_ID,
       s.strStudy_NM,
       sd.Survey_ID, 
       sd.strSurvey_NM
  FROM QP_Prod.dbo.Client c, 
       QP_Prod.dbo.Study s, 
       QP_Prod.dbo.Survey_Def sd
 WHERE c.Client_ID = s.Client_ID
   AND s.Study_ID = sd.Study_ID


