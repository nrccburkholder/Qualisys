CREATE FUNCTION dbo.FN_SamplePopFromLitho (@strLithoCode VARCHAR(20))
RETURNS INT
AS
BEGIN
RETURN (SELECT SamplePop_id 
	FROM SentMailing sm(NOLOCK), ScheduledMailing schm(NOLOCK) 
	WHERE strLithoCode=@strLithoCode
	AND sm.SentMail_id=schm.SentMail_id)
END


