CREATE PROCEDURE SP_SYS_MoveGeneration @Survey_id INT, @datGenerate DATETIME, @NewdatGenerate DATETIME
AS

CREATE TABLE #schm (ScheduledMailing_id INT)

INSERT INTO #schm
SELECT ScheduledMailing_id
FROM ScheduledMailing schm, MailingStep ms
WHERE ms.Survey_id = @Survey_id
AND ms.MailingStep_id = schm.MailingStep_id
AND datGenerate = @datGenerate

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


