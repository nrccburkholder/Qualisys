CREATE PROCEDURE sp_OffTR_SendThankYous
    @strLithoCode   varchar(10),
    @intSamplePopID int

AS

INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, Methodology_id, datGenerate) 
SELECT DISTINCT ms.MailingStep_id, @intSamplePopID, ms.Methodology_id, getdate() 
FROM MailingStep ms, SentMailing sm 
WHERE sm.strLithoCode = @strLithoCode 
  AND sm.Methodology_id = ms.Methodology_id 
  AND ms.bitThankYouItem = 1


