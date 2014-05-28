CREATE PROCEDURE SP_SYS_MoveGeneration_SS @Survey_id INT, @datGenerate DATETIME, @NewdatGenerate DATETIME, @mailingstep_id INT = NULL
AS  

IF @mailingstep_id IS NULL
	BEGIN
		SELECT DISTINCT ms.mailingstep_id, ms.survey_id, ms.strMailingstep_nm, schm.datGenerate FROM ScheduledMailing schm, MailingStep ms  
		WHERE ms.Survey_id = @Survey_id  
		AND ms.MailingStep_id = schm.MailingStep_id  
		AND datGenerate = @datGenerate  
	RETURN
	END
  
CREATE TABLE #schm (ScheduledMailing_id INT)  
  
INSERT INTO #schm  
SELECT ScheduledMailing_id  
FROM ScheduledMailing schm, MailingStep ms  
WHERE ms.Survey_id = @Survey_id  
AND ms.MailingStep_id = schm.MailingStep_id  
AND datGenerate = @datGenerate  
AND ms.mailingstep_id = @mailingstep_id
  
BEGIN TRAN  
  
UPDATE schm  
SET datGenerate = @NewdatGenerate  
FROM #schm t, ScheduledMailing schm  
WHERE t.ScheduledMailing_id = schm.ScheduledMailing_id  
  
IF @@ERROR <> 0  
BEGIN  
 ROLLBACK TRAN  
 RETURN  
END  
  
COMMIT TRAN  
  
DROP TABLE #schm


