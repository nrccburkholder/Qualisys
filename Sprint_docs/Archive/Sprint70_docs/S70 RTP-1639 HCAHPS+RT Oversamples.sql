/*
	S70 RTP-1639 HCAHPS+RT Oversamples.sql

	Chris Burkholder

	3/8/2017

	ALTER    PROCEDURE [dbo].[QCL_InsertSampleSetInPeriod]

select * from qualpro_params where strparam_nm like '%AllowOversample%'
select dbo.SurveyProperty('AllowOverSample',2,null)
select dbo.SurveyProperty('AllowOverSample',null,20697)

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

Modified: 03/08/2017 by CJB RTP-1449->RTP-1639 HCAHPS+RT Oversamples
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

		--RTP-1449 HCAHPS+RT Oversamples (increment Expected Samples for RT)
		declare @surveyid int
		select @surveyid = Survey_id from SampleSet where SampleSet_ID = @SampleSet_id

		if exists(select * from SurveySubType sst inner join 
				SubType st on sst.Subtype_id = st.Subtype_id
				where survey_ID = @surveyid and st.Subtype_nm = 'RT')
			and (dbo.SurveyProperty('AllowOverSample',null,@surveyid) = 1) --this indicates HCAHPS only 
				update PeriodDef set intExpectedSamples = @MAXSAMPLE + 1
				where PERIODDEF_ID = @Period_ID
		-------------------
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