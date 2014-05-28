CREATE  PROCEDURE WebPref_PopulateNRCSurveyPin
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON 

DECLARE @sql VARCHAR(8000), @BarCode VARCHAR(20), @Litho VARCHAR(20)

-- BEGIN TRANSACTION 
	
SELECT TOP 1 @Litho=Litho, @BarCode=BarCode FROM WebSurveyQueue WHERE bitPopulatedValues=1 AND bitProcessed=0
WHILE @@ROWCOUNT>0
BEGIN

	SELECT @sql='EXEC DMZSQL.newNRCADX.dbo.nrcSurveyPin_Insert '''+SurveyGUID+''', '''+@BarCode+''', NULL, '''+dbo.fn_WebPrefXML(@BarCode)+''''
	FROM WebSurveyQueue q, WebSurveyGUID g
	WHERE q.Litho=@Litho
	AND q.Survey_id=g.Survey_id

	EXEC (@sql)

	IF @@ERROR<>0
	BEGIN
		RETURN
	END

	BEGIN TRANSACTION
	
	UPDATE WebSurveyQueue SET bitProcessed=1 WHERE Litho=@Litho AND bitPopulatedValues=1
	
	IF @@ERROR<>0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	COMMIT TRANSACTION	
	
	SELECT TOP 1 @Litho=Litho, @BarCode=BarCode FROM WebSurveyQueue WHERE bitPopulatedValues=1 AND bitProcessed=0

END

-- COMMIT TRANSACTION

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


