CREATE PROCEDURE WebPref_DelFutureMailings @Litho VARCHAR(20), @Disposition_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @SamplePop_id INT

SELECT @SamplePop_id=SamplePop_id
FROM SentMailing sm, ScheduledMailing schm
WHERE sm.strLithoCode=@Litho
AND sm.SentMail_id=schm.SentMail_id

BEGIN TRANSACTION

DELETE ScheduledMailing
WHERE SamplePop_id=@SamplePop_id
AND SentMail_id IS NULL

IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	SELECT -1
	RETURN
END

--Log it
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)
SELECT @Litho,@Disposition_id,GETDATE(),'Deleted Future Mailings'

IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	SELECT -1
	RETURN
END

COMMIT TRANSACTION
SELECT 1

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


