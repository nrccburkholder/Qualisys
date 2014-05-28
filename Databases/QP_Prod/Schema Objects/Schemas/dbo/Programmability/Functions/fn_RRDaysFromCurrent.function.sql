CREATE FUNCTION dbo.fn_RRDaysFromCurrent (@QuestionForm_id INT)
RETURNS INT
AS
BEGIN

RETURN (SELECT DATEDIFF(DAY,CONVERT(DATETIME,CONVERT(VARCHAR(10),datMailed,120)),datReturned)
FROM QuestionForm qf(NOLOCK), SentMailing sm(NOLOCK)
WHERE qf.QuestionForm_id=@QuestionForm_id
AND qf.SentMail_id=sm.SentMail_id)

END


