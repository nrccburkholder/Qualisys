CREATE PROCEDURE [dbo].[QCL_SelectMailingByLitho]  
@Litho VARCHAR(10)    
AS    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
SET NOCOUNT ON      
    
SELECT sm.SentMail_id, sm.strLithoCode, ms.MailingStep_id, ms.strMailingStep_nm, sp.Study_id, ms.Survey_id,     
  sp.Pop_id, sm.LangId, sm.datGenerated, sm.datPrinted, sm.datMailed,     
  schm.datGenerate 'datGenerationScheduled', sm.datUndeliverable, qf.datReturned  , sm.datExpire  
FROM SentMailing sm LEFT OUTER JOIN QuestionForm qf ON (qf.SentMail_id=sm.SentMail_id),     
  ScheduledMailing schm, SamplePop sp, MailingStep ms    
WHERE sm.strLithoCode=@Litho    
AND sm.ScheduledMailing_id=schm.ScheduledMailing_id    
AND schm.SamplePop_id=sp.SamplePop_id    
AND schm.MailingStep_id=ms.MailingStep_id    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF


