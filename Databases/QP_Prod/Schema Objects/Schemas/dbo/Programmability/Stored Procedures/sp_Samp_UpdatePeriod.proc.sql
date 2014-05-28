/**********************************************************************
	This stored procedure will update the perioddates table after a 
	sample is created.

	Updates:
	2-25-2004 DC
		Initial Creation

***********************************************************************/

CREATE    PROCEDURE sp_Samp_UpdatePeriod
 @intSampleset_id int,
 @intPeriod_id int
AS

	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_UpdatePeriod', getdate())
Declare @minEmptySample integer

SELECT @minEmptySample=MIN(samplenumber)
FROM perioddates
WHERE datsamplecreate_dt IS null and
	  PERIODDEF_ID=@INTPERIOD_ID

IF @minEmptySample IS NULL
	--Oversample
	BEGIN
		DECLARE @MAXSAMPLE AS INTEGER

		SELECT @MAXSAMPLE=MAX(SAMPLENUMBER)
		FROM PERIODDATES
		WHERE PERIODDEF_ID=@INTPERIOD_ID

		INSERT INTO PERIODDATES (PERIODDEF_ID, SAMPLENUMBER, DATSCHEDULEDSAMPLE_DT,
								 SAMPLESET_ID, DATSAMPLECREATE_DT)
		VALUES (@INTPERIOD_ID, @MAXSAMPLE + 1, GETDATE(), @INTSAMPLESET_ID, GETDATE())
	END
ELSE
	BEGIN
		UPDATE perioddates
		SET SAMPLESET_ID=@INTSAMPLESET_ID,
			DATSAMPLECREATE_DT=GETDATE()
		WHERE PERIODDEF_ID=@INTPERIOD_ID AND
			SAMPLENUMBER=@minEmptySample
	END


