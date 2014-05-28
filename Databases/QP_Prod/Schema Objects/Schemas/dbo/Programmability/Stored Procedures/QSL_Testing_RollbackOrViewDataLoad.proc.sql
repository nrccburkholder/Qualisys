CREATE PROCEDURE [dbo].[QSL_Testing_RollbackOrViewDataLoad]
	@DataLoadID int,
	@ViewOnly bit = 1
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Surveys TABLE (
	SurveyDataLoad_id INT
)

DECLARE @Lithos TABLE (
    LithoCode_id INT
)

INSERT INTO @Surveys
SELECT SurveyDataLoad_id FROM DL_SurveyDataLoad WHERE DataLoad_ID = @DataLoadID

INSERT INTO @Lithos
SELECT lc.DL_LithoCode_ID
FROM @Surveys sv, DL_LithoCodes lc
WHERE sv.SurveyDataLoad_id = lc.SurveyDataLoad_id

IF (@ViewOnly = 1)
BEGIN
	SELECT * 
	FROM DL_DataLoad 
	WHERE DataLoad_ID = @DataLoadID
	
	SELECT * 
	FROM DL_SurveyDataLoad 
	WHERE DataLoad_ID = @DataLoadID
	
	SELECT lc.* 
	FROM @Surveys sv, DL_LithoCodes lc 
	WHERE sv.SurveyDataLoad_id = lc.SurveyDataLoad_id
	
	SELECT ds.* 
	FROM @Lithos lc, DL_Dispositions ds 
	WHERE lc.LithoCode_id = ds.DL_LithoCode_ID
	
    SELECT vd.*
    FROM @Surveys sv, VendorDispositionLog vd
    WHERE sv.SurveyDataLoad_id = vd.SurveyDataLoad_ID
    
	SELECT qr.* 
	FROM @Lithos lc, DL_QuestionResults qr 
	WHERE lc.LithoCode_id = qr.DL_LithoCode_ID
	
	SELECT cm.* 
	FROM @Lithos lc, DL_Comments cm 
	WHERE lc.LithoCode_id = cm.DL_LithoCode_ID
	
	SELECT he.* 
	FROM @Lithos lc, DL_HandEntry he 
	WHERE lc.LithoCode_id = he.DL_LithoCode_ID
	
	SELECT * 
	FROM DL_BadLithos
	WHERE DataLoad_ID = @DataLoadID
END
ELSE
BEGIN
    IF EXISTS(SELECT * FROM @Surveys sv, DL_LithoCodes lc WHERE sv.SurveyDataLoad_id = lc.SurveyDataLoad_id AND lc.bitSubmitted = 1)
	BEGIN
        PRINT 'Unable to delete DataLoad (' + Convert(varchar, @DataLoadID) + ') as some data has been submitted to QualiSys'
    END
    ELSE
    BEGIN
		DELETE he 
		FROM @Lithos lc, DL_HandEntry he 
		WHERE lc.LithoCode_id = he.DL_LithoCode_ID
		
		DELETE cm 
		FROM @Lithos lc, DL_Comments cm 
		WHERE lc.LithoCode_id = cm.DL_LithoCode_ID
		
		DELETE qr 
		FROM @Lithos lc, DL_QuestionResults qr 
		WHERE lc.LithoCode_id = qr.DL_LithoCode_ID
		
		DELETE ds 
		FROM @Lithos lc, DL_Dispositions ds 
		WHERE lc.LithoCode_id = ds.DL_LithoCode_ID
		
        DELETE vd
        FROM @Surveys sv, VendorDispositionLog vd
        WHERE sv.SurveyDataLoad_id = vd.SurveyDataLoad_id
        
		DELETE lc 
		FROM @Surveys sv, DL_LithoCodes lc 
		WHERE sv.SurveyDataLoad_id = lc.SurveyDataLoad_id
		
		DELETE DL_SurveyDataLoad 
		WHERE DataLoad_ID = @DataLoadID

		DELETE DL_BadLithos 
		WHERE DataLoad_ID = @DataLoadID

		DELETE DL_DataLoad 
		WHERE DataLoad_ID = @DataLoadID

		PRINT 'DataLoad (' + Convert(varchar, @DataLoadID) + ') Successfully Deleted'
	END
END

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


