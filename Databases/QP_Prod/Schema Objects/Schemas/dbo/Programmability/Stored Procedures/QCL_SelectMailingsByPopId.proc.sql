﻿CREATE PROCEDURE QCL_SelectMailingsByPopId  
@PopId INT,  
@StudyId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT sm.SentMail_id, sm.strLithoCode, ms.MailingStep_id, ms.strMailingStep_nm, sp.Study_id, ms.Survey_id,   
  sp.Pop_id, sm.LangId, sm.datGenerated, sm.datPrinted, sm.datMailed,   
  schm.datGenerate 'datGenerationScheduled', sm.datUndeliverable, qf.datReturned, sm.datExpire  
FROM SamplePop sp, MailingStep ms,   
  ScheduledMailing schm LEFT OUTER JOIN SentMailing sm ON (sm.ScheduledMailing_id=schm.ScheduledMailing_id)   
  LEFT OUTER JOIN QuestionForm qf ON (qf.SentMail_id=sm.SentMail_id)  
WHERE schm.SamplePop_id=sp.SamplePop_id  
AND schm.MailingStep_id=ms.MailingStep_id  
AND sp.Study_id=@StudyId  
AND sp.Pop_id=@PopId  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF

