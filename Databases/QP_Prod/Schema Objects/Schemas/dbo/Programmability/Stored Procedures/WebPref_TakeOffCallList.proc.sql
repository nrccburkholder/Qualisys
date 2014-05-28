CREATE PROCEDURE WebPref_TakeOffCallList @Litho VARCHAR(20), @Disposition_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRANSACTION

INSERT INTO TOCL (Study_id, Pop_id, datTOCL_dat)
SELECT Study_id, Pop_id, GETDATE()
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp
WHERE sm.strLithoCode=@Litho
AND sm.SentMail_id=schm.SentMail_id
AND schm.SamplePop_id=sp.SamplePop_id

IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	SELECT -1
	RETURN
END

--Log it
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)
SELECT @Litho,@Disposition_id,GETDATE(),'Added to TOCL'

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


