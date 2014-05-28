CREATE  PROCEDURE QCL_SelectFormGenJobsByDate    
@StartDate DATETIME,    
@EndDate DATETIME    
AS    
    
CREATE TABLE #Queue      
(Client_id INT,      
 strClient_Nm VARCHAR(60),      
 Study_id INT,      
 strStudy_nm VARCHAR(42),      
 Survey_id INT,      
 strSurvey_nm VARCHAR(42),      
 MailingStep_id INT,    
 strMailingStep_nm VARCHAR(42),      
 Priority_flg INT,   
 SurveyType VARCHAR(25),   
 Total INT,      
 datGenerate DATETIME,    
 bitFormGenRelease BIT)      
  
-- Make sure to include entire day  
SET @EndDate = DATEADD(hh,23,@EndDate)  
      
INSERT INTO #Queue (Survey_id, MailingStep_id, strMailingStep_nm, Total, datGenerate)      
SELECT ms.Survey_id, schm.MailingStep_id, ms.strMailingStep_nm, COUNT(*), schm.datGenerate    
FROM   ScheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK)      
WHERE  schm.SentMail_id IS NULL       
   AND schm.datGenerate BETWEEN @StartDate AND @EndDate    
   AND ms.MailingStep_id=schm.MailingStep_id       
   AND schm.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError      
      WHERE ScheduledMailing_id IS NOT NULL)      
GROUP BY ms.Survey_id, schm.MailingStep_id, ms.strMailingStep_nm, schm.datGenerate    
      
UPDATE t    
SET Client_id=c.Client_id, strClient_nm=c.strClient_nm, Study_id=s.Study_id, strStudy_nm=s.strStudy_nm,    
strSurvey_nm=sd.strSurvey_nm, Priority_flg=sd.Priority_flg, bitFormGenRelease=sd.bitFormGenRelease,  
SurveyType=LEFT(st.SurveyType_dsc,15)  
FROM #Queue t, Survey_def sd, Study s, Client c, SurveyType st    
WHERE t.Survey_id=sd.Survey_id    
AND sd.Study_id=s.Study_id    
AND s.Client_id=c.Client_id   
AND sd.SurveyType_id=st.SurveyType_id   
    
SELECT * FROM #Queue ORDER BY strClient_nm, strStudy_nm, strSurvey_nm, strMailingStep_nm    
    
DROP TABLE #Queue


