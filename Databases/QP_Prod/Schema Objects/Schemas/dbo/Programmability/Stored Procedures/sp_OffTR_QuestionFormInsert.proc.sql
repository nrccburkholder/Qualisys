/*
   MODIFIED 9/19/13 DG Added call to CalcCAHPSSupplemental
*/
CREATE PROCEDURE sp_OffTR_QuestionFormInsert
    @strLithoCode varchar(10)

AS
declare @QF int

INSERT INTO QuestionForm (SentMail_id, SamplePop_id, Survey_id)
SELECT sm.SentMail_id, sc.SamplePop_id, ms.Survey_id
FROM SentMailing sm, ScheduledMailing sc, MailingStep ms
WHERE sm.SentMail_id = sc.SentMail_id
  AND sc.MailingStep_id = ms.MailingStep_id
  AND sm.strLithoCode = @strLithoCode

set @QF=scope_identity()
exec dbo.CalcCAHPSSupplemental @QF


