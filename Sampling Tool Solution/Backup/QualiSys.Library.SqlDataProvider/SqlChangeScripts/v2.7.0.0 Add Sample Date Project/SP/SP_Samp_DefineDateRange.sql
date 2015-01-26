set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_Samp_DefineDateRange] @SampleSet_id INT
AS

IF (SELECT datDateRange_FromDate FROM SampleSet WHERE SampleSet_id = @SampleSet_id) IS NOT NULL
BEGIN
	RETURN
END

update sampleset
set datDateRange_FromDate=(select min(sampleEncounterDate) from selectedsample where sampleset_id=@SampleSet_id),
	datDateRange_ToDate=(select max(sampleEncounterDate) from selectedsample where sampleset_id=@SampleSet_id)
where sampleset_id=@SampleSet_id







