CREATE PROCEDURE WebPref_ReGenerateSurvey @Litho VARCHAR(20), @Disposition_id INT, @LangID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @sql VARCHAR(8000), @SamplePop_id VARCHAR(20), @Pop_id VARCHAR(20), @Study_id VARCHAR(20)

SELECT @SamplePop_id=LTRIM(STR(sp.SamplePop_id)), @Pop_id=LTRIM(STR(Pop_id)), @Study_id=LTRIM(STR(Study_id))
FROM SentMailing sm, ScheduledMailing schm, SamplePop sp
WHERE sm.strLithoCode=@Litho
AND sm.SentMail_id=schm.SentMail_id
AND schm.SamplePop_id=sp.SamplePop_id

--Change the langid is necessary
IF @LangID IS NOT NULL
BEGIN

	SELECT @sql='UPDATE S'+@Study_id+'.Population SET LangID='+LTRIM(STR(@LangID))+' WHERE Pop_id='+@Pop_id
	EXEC (@sql)

END

--Check to see if they have a regenerate scheduled to generate.  If they do, exit the proc.
IF EXISTS (SELECT * FROM ScheduledMailing WHERE SamplePop_id=CONVERT(INT,@SamplePop_id) AND SentMail_id IS NULL AND OverRideItem_id IS NOT NULL)
BEGIN
	SELECT 1
	RETURN
END

BEGIN TRANSACTION 

--Now to schedule another generation.
DECLARE @ORI INT

INSERT INTO OverRideItem (intIntervalDays)
SELECT 0

SELECT @ORI=SCOPE_IDENTITY()

IF @@ERROR<>0 
BEGIN
	ROLLBACK TRANSACTION
	SELECT -1
END

INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, Methodology_id, datGenerate)
SELECT MIN(ms.MailingStep_id), @SamplePop_id, @ORI, schm.Methodology_id, GETDATE()
FROM ScheduledMailing schm, MailingStep ms
WHERE schm.SamplePop_id=@SamplePop_id
AND schm.Methodology_id=ms.Methodology_id
AND ms.bitFirstSurvey=1
GROUP BY schm.Methodology_id

IF @@ERROR<>0 
BEGIN
	ROLLBACK TRANSACTION
	SELECT -1
END

--Log it
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)
SELECT @Litho,@Disposition_id,GETDATE(),'Regenerate Form'

COMMIT TRANSACTION
SELECT 1

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


