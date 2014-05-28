CREATE PROCEDURE SP_Rollback_Export @CutOff_id INT, @Survey_id INT
AS

IF @Survey_id<>(SELECT Survey_id FROM CutOff WHERE CutOff_id=@CutOff_id)
BEGIN
SELECT -1, 'Cutoff does not belong to the supplied survey.'
RETURN
END

INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, RollBackType, Cnt, MailingStep_id)
SELECT @Survey_id, Study_id, GETDATE(), 'Export', COUNT(*), @CutOff_id
FROM QuestionForm qf, Survey_def sd
WHERE qf.CutOff_id=@CutOff_id
AND qf.Survey_id=sd.Survey_id
GROUP BY Study_id

UPDATE QuestionForm
SET CutOff_id=NULL
WHERE CutOff_id=@CutOff_id

DELETE CutOff
WHERE CutOff_id=@CutOff_id


