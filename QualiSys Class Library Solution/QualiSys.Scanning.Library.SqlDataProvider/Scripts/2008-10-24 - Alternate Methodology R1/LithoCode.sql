---------------------------------------------------------------------------------------
--QSL_SelectLithoCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCode]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCode]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCode]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Lithos (DL_LithoCode_ID      INT,
                      SurveyDataLoad_ID    INT,
                      DL_Error_ID          INT,
                      TranslationCode      VARCHAR(10),
                      strLithoCode         VARCHAR(50),
                      bitIgnore            BIT,
                      bitSubmitted         BIT,
                      bitExtracted         BIT,
                      bitSkipDuplicate     BIT,
                      bitDispositionUpdate BIT,
                      DateCreated          DATETIME,
                      SentMail_id          INT, 
					  LangID               INT,
					  datExpire            DATETIME,
					  QuestionForm_id      INT,
					  SamplePop_id         INT,
					  Survey_id            INT,
					  datReturned          DATETIME,
					  UnusedReturn_id      INT,
					  datResultsImported   DATETIME,
					  SampleSet_id         INT,
					  Study_id             INT,
					  Pop_id               INT,
					  OtherStepImported    BIT)

INSERT INTO #Lithos
SELECT lc.DL_LithoCode_ID, lc.SurveyDataLoad_ID, lc.DL_Error_ID, lc.TranslationCode, lc.strLithoCode, lc.bitIgnore, 
       lc.bitSubmitted, lc.bitExtracted, lc.bitSkipDuplicate, lc.bitDispositionUpdate, lc.DateCreated, 
       sm.SentMail_id, sm.LangID, sm.datExpire, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datReturned, 
       qf.UnusedReturn_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id, 0
FROM ((DL_LithoCodes lc LEFT JOIN SentMailing sm ON lc.strLithoCode = sm.strLithoCode)
                        LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id)
                        LEFT JOIN SamplePop sp ON qf.SamplePop_id = sp.SamplePop_id
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

SELECT DL_LithoCode_ID, SurveyDataLoad_ID, DL_Error_ID, TranslationCode, strLithoCode, bitIgnore,
       bitSubmitted, bitExtracted, bitSkipDuplicate, bitDispositionUpdate, DateCreated, SentMail_id, LangID, 
       datExpire, QuestionForm_id, SamplePop_id, Survey_id, datReturned, UnusedReturn_id, datResultsImported, 
       SampleSet_id, Study_id, Pop_id, OtherStepImported 
FROM #Lithos

DROP TABLE #Lithos

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoAllCodes
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoAllCodes]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoAllCodes]
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoCodesByError_ID
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCodesByErrorId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCodesByErrorId]
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoCodesBySurveyDataLoad_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCodesBySurveyDataLoadId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCodesBySurveyDataLoadId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCodesBySurveyDataLoadId]
@SurveyDataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Lithos (DL_LithoCode_ID      INT,
                      SurveyDataLoad_ID    INT,
                      DL_Error_ID          INT,
                      TranslationCode      VARCHAR(10),
                      strLithoCode         VARCHAR(50),
                      bitIgnore            BIT,
                      bitSubmitted         BIT,
                      bitExtracted         BIT,
                      bitSkipDuplicate     BIT,
                      bitDispositionUpdate BIT,
                      DateCreated          DATETIME,
                      SentMail_id          INT, 
					  LangID               INT,
					  datExpire            DATETIME,
					  QuestionForm_id      INT,
					  SamplePop_id         INT,
					  Survey_id            INT,
					  datReturned          DATETIME,
					  UnusedReturn_id      INT,
					  datResultsImported   DATETIME,
					  SampleSet_id         INT,
					  Study_id             INT,
					  Pop_id               INT,
					  OtherStepImported    BIT)

INSERT INTO #Lithos
SELECT lc.DL_LithoCode_ID, lc.SurveyDataLoad_ID, lc.DL_Error_ID, lc.TranslationCode, lc.strLithoCode, lc.bitIgnore, 
       lc.bitSubmitted, lc.bitExtracted, lc.bitSkipDuplicate, lc.bitDispositionUpdate, lc.DateCreated, 
       sm.SentMail_id, sm.LangID, sm.datExpire, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datReturned, 
       qf.UnusedReturn_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id, 0
FROM ((DL_LithoCodes lc LEFT JOIN SentMailing sm ON lc.strLithoCode = sm.strLithoCode)
                        LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id)
                        LEFT JOIN SamplePop sp ON qf.SamplePop_id = sp.SamplePop_id
WHERE lc.SurveyDataLoad_ID = @SurveyDataLoad_ID

UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

SELECT DL_LithoCode_ID, SurveyDataLoad_ID, DL_Error_ID, TranslationCode, strLithoCode, bitIgnore,
       bitSubmitted, bitExtracted, bitSkipDuplicate, bitDispositionUpdate, DateCreated, SentMail_id, LangID, 
       datExpire, QuestionForm_id, SamplePop_id, Survey_id, datReturned, UnusedReturn_id, datResultsImported, 
       SampleSet_id, Study_id, Pop_id, OtherStepImported 
FROM #Lithos

DROP TABLE #Lithos

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertLithoCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertLithoCode]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_InsertLithoCode]
GO
CREATE PROCEDURE [dbo].[QSL_InsertLithoCode]
@SurveyDataLoad_ID INT,
@DL_Error_ID INT,
@TranslationCode VARCHAR(10), 
@strLithoCode VARCHAR(50),
@bitIgnore BIT,
@bitSubmitted BIT,
@bitExtracted BIT,
@bitSkipDuplicate BIT,
@bitDispositionUpdate BIT,
@DateCreated DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_LithoCodes (SurveyDataLoad_ID, DL_Error_ID, TranslationCode, strLithoCode, bitIgnore, bitSubmitted, bitExtracted, bitSkipDuplicate, bitDispositionUpdate, DateCreated)
VALUES (@SurveyDataLoad_ID, @DL_Error_ID, @TranslationCode, @strLithoCode, @bitIgnore, @bitSubmitted, @bitExtracted, @bitSkipDuplicate, @bitDispositionUpdate, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateLithoCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateLithoCode]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_UpdateLithoCode]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateLithoCode]
@DL_LithoCode_ID INT,
@SurveyDataLoad_ID INT,
@DL_Error_ID INT,
@TranslationCode VARCHAR(10), 
@strLithoCode VARCHAR(50),
@bitIgnore BIT,
@bitSubmitted BIT,
@bitExtracted BIT,
@bitSkipDuplicate BIT,
@bitDispositionUpdate BIT,
@DateCreated DATETIME
AS

SET NOCOUNT ON

UPDATE [dbo].DL_LithoCodes SET
    SurveyDataLoad_ID = @SurveyDataLoad_ID,
    DL_Error_ID = @DL_Error_ID,
    TranslationCode = @TranslationCode, 
    strLithoCode = @strLithoCode,
    bitIgnore = @bitIgnore,
    bitSubmitted = @bitSubmitted,
    bitExtracted = @bitExtracted,
    bitSkipDuplicate = @bitSkipDuplicate,
    bitDispositionUpdate = @bitDispositionUpdate,
    DateCreated = @DateCreated
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteLithoCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteLithoCode]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_DeleteLithoCode]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteLithoCode]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_LithoCodes
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoCodeAdditionalInfo
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCodeAdditionalInfo]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCodeAdditionalInfo]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCodeAdditionalInfo]
    @strLithoCode VARCHAR(10)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Lithos (SentMail_id        INT, 
					  LangID             INT,
					  datExpire          DATETIME,
					  QuestionForm_id    INT,
					  SamplePop_id       INT,
					  Survey_id          INT,
					  datReturned        DATETIME,
					  UnusedReturn_id    INT,
					  datResultsImported DATETIME,
					  SampleSet_id       INT,
					  Study_id           INT,
					  Pop_id             INT,
					  OtherStepImported  BIT)

INSERT INTO #Lithos
SELECT sm.SentMail_id, sm.LangID, sm.datExpire, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datReturned, 
       qf.UnusedReturn_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id, 0 
FROM (SentMailing sm (NOLOCK) LEFT JOIN QuestionForm qf (NOLOCK) ON sm.SentMail_id = qf.SentMail_id)
                              LEFT JOIN SamplePop sp (NOLOCK) ON qf.SamplePop_id = sp.SamplePop_Id
WHERE sm.strLithoCode = @strLithoCode

UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

SELECT SentMail_id, LangID, datExpire, QuestionForm_id, SamplePop_id, Survey_id, datReturned,
       UnusedReturn_id, datResultsImported, SampleSet_id, Study_id, Pop_id, 
       OtherStepImported 
FROM #Lithos

DROP TABLE #Lithos

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_DeleteFutureMailings
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteFutureMailings]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_DeleteFutureMailings]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteFutureMailings]
@SentMailID INT,
@SamplePopID INT,
@DispositionID INT,
@DispositionDate DATETIME,
@ReceiptTypeID INT,
@UserName VARCHAR(42)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

--Delete any ungenerated steps for this samplepop_id    
DELETE ScheduledMailing    
WHERE SamplePop_id = @SamplePopID    
  AND SentMail_id IS NULL    

--Insert the disposition
EXEC dbo.QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @UserName, @DispositionDate

SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_TakeOffCallList
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_TakeOffCallList]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_TakeOffCallList]
GO
CREATE PROCEDURE [dbo].[QSL_TakeOffCallList]
@SentMailID INT,
@SamplePopID INT,
@DispositionID INT,
@DispositionDate DATETIME,
@ReceiptTypeID INT,
@UserName VARCHAR(42)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

DECLARE @StudyID INT
DECLARE @PopID INT

--Get the Study and Pop IDs
SELECT @StudyID = Study_id, @PopID = Pop_id
FROM SamplePop
WHERE SamplePop_id = @SamplePopID

--Add this to the TOCL table
IF NOT EXISTS(SELECT * FROM TOCL WHERE Study_id = @StudyID AND Pop_id = @PopID)
BEGIN
    INSERT INTO TOCL (Study_id, Pop_id, datTOCL_dat)
    VALUES (@StudyID, @PopID, @DispositionDate)
END

--Insert the disposition
EXEC dbo.QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @UserName, @DispositionDate

SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SaveDispositionToQualiSys
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SaveDispositionToQualiSys]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SaveDispositionToQualiSys]
GO
CREATE PROCEDURE [dbo].[QSL_SaveDispositionToQualiSys]
@LithoCodeID INT,
@VendorDispositionID INT,
@LithoCode VARCHAR(10),
@SentMailID INT,
@SamplePopID INT,
@DispositionDate DATETIME,
@ReceiptTypeID INT,
@UserName VARCHAR(42),
@DispositionID INT,
@ActionID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

DECLARE @VendorID INT
DECLARE @SurveyDataLoadID INT

SELECT @SurveyDataLoadID = lc.SurveyDataLoad_ID, @VendorID = dl.Vendor_ID
FROM DL_LithoCodes lc, DL_SurveyDataLoad sd, DL_DataLoad dl
WHERE lc.SurveyDataLoad_ID = sd.SurveyDataLoad_ID
  AND sd.DataLoad_ID = dl.DataLoad_ID
  AND lc.DL_LithoCode_ID = @LithoCodeID

--Check to see if this disposition already exists
IF NOT EXISTS(SELECT * FROM DispositionLog WHERE SentMail_id = @SentMailID AND Disposition_id = @DispositionID AND datLogged = @DispositionDate)
BEGIN
	--Insert this record into the VendorDispositionLog
	INSERT INTO VendorDispositionLog (Vendor_ID, DL_LithoCode_ID, DispositionDate, VendorDisposition_ID, DateCreated, SurveyDataLoad_ID)
	VALUES (@VendorID, @LithoCodeID, @DispositionDate, @VendorDispositionID, GetDate(), @SurveyDataLoadID)

	--Determine which procedure to call based on the action
	IF @ActionID = 1		--Take Off Call List
	BEGIN
		EXEC QSL_TakeOffCallList @SentMailID, @SamplePopID, @DispositionID, @DispositionDate, @ReceiptTypeID, @UserName
	END
	ELSE IF @ActionID = 5	--Cancel Mailings
	BEGIN
		EXEC QSL_DeleteFutureMailings @SentMailID, @SamplePopID, @DispositionID, @DispositionDate, @ReceiptTypeID, @UserName
	END
	ELSE					--All Others
	BEGIN
		EXEC QCL_LogDisposition @SentMailID, @SamplePopID, @DispositionID, @ReceiptTypeID, @UserName, @DispositionDate
	END
END

SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SaveLithoCodeToQualiSys
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SaveLithoCodeToQualiSys]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SaveLithoCodeToQualiSys]
GO
CREATE PROCEDURE [dbo].[QSL_SaveLithoCodeToQualiSys]
@SentMailID INT,
@QuestionFormID INT,
@DateReturned DATETIME,
@BatchNumber VARCHAR(8),
@ReceiptTypeID INT
AS

SET NOCOUNT ON

--Update the SentMailing record
UPDATE SentMailing
SET datUndeliverable = NULL
WHERE SentMail_ID = @SentMailID

--Update the QuestionForm record
UPDATE QuestionForm
SET datReturned = @DateReturned, 
    datResultsImported = GetDate(), 
    strSTRBatchNumber = @BatchNumber, 
    intSTRLineNumber = NULL,
    ReceiptType_id = @ReceiptTypeID
WHERE QuestionForm_id = @QuestionFormID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SaveQuestionResultToQualiSys
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SaveQuestionResultToQualiSys]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SaveQuestionResultToQualiSys]
GO
CREATE PROCEDURE [dbo].[QSL_SaveQuestionResultToQualiSys]
@QuestionFormID INT,
@SampleUnitID INT,
@QstnCore INT,
@ResponseVal INT
AS

SET NOCOUNT ON

INSERT INTO QuestionResult (QuestionForm_Id, SampleUnit_Id, QstnCore, intResponseVal) 
VALUES (@QuestionFormID, @SampleUnitID, @QstnCore, @ResponseVal)

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoCodePrevFinalDispoCount
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCodePrevFinalDispoCount]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCodePrevFinalDispoCount]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCodePrevFinalDispoCount]
@DL_LithoCode_ID INT,
@LithoCode VARCHAR(50)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Count(*) AS QtyRec
FROM DL_LithoCodes lc, DL_Dispositions ds
WHERE lc.DL_LithoCode_ID = ds.DL_LithoCode_ID
  AND ds.IsFinal = 1
  AND lc.bitSubmitted = 1
  AND lc.strLithoCode = @LithoCode
  AND lc.DL_LithoCode_ID <> @DL_LithoCode_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_Testing_GetQualiSysDataByLithoCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_Testing_GetQualiSysDataByLithoCode]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_Testing_GetQualiSysDataByLithoCode]
GO
CREATE PROCEDURE [dbo].[QSL_Testing_GetQualiSysDataByLithoCode]
@LithoCode VARCHAR(10)
AS

--SentMailing and QuestionForm changes
SELECT sm.strLithoCode, sm.SentMail_id, qf.QuestionForm_id, qf.Survey_id, 
       sm.datMailed, sm.datUndeliverable, sm.datExpire, qf.datUnusedReturn, 
       qf.UnusedReturn_id, qf.datReturned, qf.datResultsImported, sm.LangID, 
       qf.strSTRBatchNumber, qf.ReceiptType_id
FROM SentMailing sm, QuestionForm qf
WHERE sm.SentMail_id = qf.SentMail_id
  AND sm.strLithoCode = @LithoCode

--QuestionResult changes
SELECT sm.strLithoCode, sm.SentMail_id, qr.*
FROM SentMailing sm, QuestionForm qf, QuestionResult qr
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.QuestionForm_id = qr.QuestionForm_id
  AND sm.strLithoCode = @LithoCode

--Comments Changes
SELECT qf.strLithoCode, qf.SentMail_id, qf.QuestionForm_id, qf.Survey_id, qc.QstnCore, qc.strCmntText, qb.Batch_id, qb.strBatchName, qb.BatchType_id, qb.datEntered, qb.strEnteredBy 
FROM QDEBatch qb, QDEForm qf, QDEComments qc
WHERE qb.Batch_id = qf.Batch_id
  AND qf.Form_id = qc.Form_id
  AND qf.strLithoCode = @LithoCode

--Dispositions
SELECT sm.strLithoCode, dl.* 
FROM SentMailing sm, DispositionLog dl
WHERE sm.SentMail_id = dl.SentMail_id
  AND sm.strLithoCode = @LithoCode

--HandEntries
DECLARE @StudyID INT
DECLARE @Sql VARCHAR(8000)

SELECT @StudyID = sp.Study_id
FROM SentMailing sm, QuestionForm qf, SamplePop sp
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sm.strLithoCode = @LithoCode

SET @Sql = 'SELECT sm.strLithoCode, sm.SentMail_id, qf.QuestionForm_id, qf.SamplePop_id, po.* ' +
           'FROM SentMailing sm, QuestionForm qf, SamplePop sp, s' + CONVERT(varchar, @StudyID) + '.Population po ' +
           'WHERE sm.SentMail_id = qf.SentMail_id ' +
           '  AND qf.SamplePop_id = sp.SamplePop_id ' +
           '  AND sp.Pop_id = po.Pop_id ' +
           '  AND sm.strLithoCode = ''' + @LithoCode + ''''
EXEC (@Sql)
GO
---------------------------------------------------------------------------------------
--QSL_Testing_RollbackOrViewDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_Testing_RollbackOrViewDataLoad]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_Testing_RollbackOrViewDataLoad]
GO
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
GO

