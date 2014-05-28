/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It adds or updates the sample
in the PeriodDates table.

Created:  02/27/2006 by DC

Modified:
*/  

CREATE    PROCEDURE [dbo].[QCL_InsertSampleSetInPeriod]
 @SampleSet_id int,
 @Period_id int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
Declare @minEmptySample integer

SELECT @minEmptySample=MIN(samplenumber)
FROM perioddates
WHERE datsamplecreate_dt IS null and
	  PERIODDEF_ID=@Period_id

IF @minEmptySample IS NULL
	--Oversample
	BEGIN
		DECLARE @MAXSAMPLE AS INTEGER

		SELECT @MAXSAMPLE=MAX(SAMPLENUMBER)
		FROM PERIODDATES
		WHERE PERIODDEF_ID=@Period_id

		INSERT INTO PERIODDATES (PERIODDEF_ID, SAMPLENUMBER, DATSCHEDULEDSAMPLE_DT,
								 SAMPLESET_ID, DATSAMPLECREATE_DT)
		VALUES (@Period_id, @MAXSAMPLE + 1, GETDATE(), @SampleSet_id, GETDATE())
	END
ELSE
	BEGIN
		UPDATE perioddates
		SET SAMPLESET_ID=@SampleSet_id,
			DATSAMPLECREATE_DT=GETDATE()
		WHERE PERIODDEF_ID=@Period_id AND
			SAMPLENUMBER=@minEmptySample
	END

  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


