/*
	S70 RTP-1639 HCAHPS+RT Oversamples - Rollback.sql

	Chris Burkholder

	3/8/2017

	ALTER    PROCEDURE [dbo].[QCL_InsertSampleSetInPeriod]

*/
USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_InsertSampleSetInPeriod]    Script Date: 3/8/2017 9:00:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It adds or updates the sample
in the PeriodDates table.

Created:  02/27/2006 by DC

Modified:
*/  

ALTER    PROCEDURE [dbo].[QCL_InsertSampleSetInPeriod]
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

GO