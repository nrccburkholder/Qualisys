CREATE FUNCTION dbo.fn_RRDaysFromFirst (@QuestionForm_id INT)
RETURNS INT
AS
BEGIN

RETURN (SELECT DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),MIN(datMailed),120)),datReturned)
FROM QuestionForm qf(NOLOCK), ScheduledMailing schm(NOLOCK), ScheduledMailing schm2(NOLOCK), SentMailing sm(NOLOCK)
WHERE qf.QuestionForm_id=@QuestionForm_id
AND qf.SentMail_id=schm.SentMail_id
AND schm.SamplePop_id=schm2.SamplePop_id
AND schm2.SentMail_id=sm.SentMail_id
GROUP BY qf.datReturned)

END


