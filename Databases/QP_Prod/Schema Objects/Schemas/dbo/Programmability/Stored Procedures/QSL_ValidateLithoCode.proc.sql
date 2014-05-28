CREATE PROCEDURE [dbo].[QSL_ValidateLithoCode]
    @LithoCode VARCHAR(10)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare the required variables
DECLARE @QuestionFormID INT
DECLARE @DateExpired DATETIME
DECLARE @DateUndeliverable DATETIME
DECLARE @DateReturned DATETIME
DECLARE @UnusedReturnID INT
DECLARE @OtherStepImported BIT

--Create required temp tables
CREATE TABLE #Lithos (QuestionForm_id    INT, 
                      datExpire          DATETIME, 
                      datUndeliverable   DATETIME, 
					  datReturned        DATETIME, 
					  UnusedReturn_id    INT, 
					  OtherStepImported  BIT 
					 )

--Insert the information for the specified LithoCode in to the temp table
INSERT INTO #Lithos (QuestionForm_id, datExpire, datUndeliverable, datReturned, UnusedReturn_id)
SELECT qf.QuestionForm_id, sm.datExpire, sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id
FROM SentMailing sm (NOLOCK) LEFT JOIN QuestionForm qf (NOLOCK) ON sm.SentMail_id = qf.SentMail_id 
WHERE sm.strLithoCode = @LithoCode

--Determine if another step was already returned for the specified LithoCode
UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

--Determine the result to be returned
IF NOT EXISTS(SELECT * FROM #Lithos)
BEGIN
	--The specified LithoCode does not exist
    SELECT 'LithoCode (' + @LithoCode + ') Not Found'
END
ELSE
BEGIN
    --Select the information for the specified LithoCode
    SELECT @QuestionFormID    = QuestionForm_id, 
           @DateExpired       = datExpire, 
           @DateUndeliverable = datUndeliverable, 
           @DateReturned      = datReturned, 
           @UnusedReturnID    = UnusedReturn_id,
           @OtherStepImported = OtherStepImported
    FROM #Lithos
    
    IF @QuestionFormID IS NULL
    BEGIN
        --No QuestionForm record was found
        SELECT 'No QuestionForm Record Exists For LithoCode (' + @LithoCode + ')'
    END
    ELSE IF @DateExpired IS NOT NULL AND @DateExpired <= GETDATE()
    BEGIN
        --The specified LithoCode is already expired
        SELECT 'LithoCode (' + @LithoCode + ') Expired On ' + CONVERT(VARCHAR, @DateExpired, 101)
    END
    ELSE IF @DateUndeliverable IS NOT NULL
    BEGIN
        --The specified LithoCode has already been marked as undeliverable
        SELECT 'LithoCode (' + @LithoCode + ') Was Marked As Undeliverable On ' + CONVERT(VARCHAR, @DateUndeliverable, 101)
    END
    ELSE IF @DateReturned IS NOT NULL
    BEGIN
        --The specified LithoCode has already been marked as returned
        SELECT 'LithoCode (' + @LithoCode + ') Was Marked As Returned On ' + CONVERT(VARCHAR, @DateReturned, 101)
    END
    ELSE IF @OtherStepImported IS NOT NULL AND @OtherStepImported = 1
    BEGIN
        --A different mailing step has already been returned for the specified LithoCode
        SELECT 'LithoCode (' + @LithoCode + ') Has Had A Different Mailing Step Returned'
    END
    ELSE IF @UnusedReturnID IS NOT NULL
    BEGIN
        --We have an unused return value so determine what to do with it
        IF @UnusedReturnID = 1
        BEGIN
            --A different mailing step has already been returned for the specified LithoCode
            SELECT 'LithoCode (' + @LithoCode + ') Has Had A Different Mailing Step Returned'
        END
        ELSE IF @UnusedReturnID = 2
        BEGIN
            --The specified LithoCode is already expired
            SELECT 'LithoCode (' + @LithoCode + ') Expired On ' + CONVERT(VARCHAR, @DateExpired, 101)
        END
        ELSE IF @UnusedReturnID = 3
        BEGIN
            --The specified LithoCode has already been scanned into the system
            SELECT 'LithoCode (' + @LithoCode + ') Has Already Been Scanned'
        END
        ELSE
        BEGIN
            --All is good
            SELECT ''
        END
    END
    ELSE
    BEGIN
        --All is good
        SELECT ''
    END
END

--Cleanup temp tables
DROP TABLE #Lithos

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


