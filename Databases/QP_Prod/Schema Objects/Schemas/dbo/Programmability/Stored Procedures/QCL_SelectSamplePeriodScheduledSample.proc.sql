CREATE PROCEDURE [dbo].[QCL_SelectSamplePeriodScheduledSample]
@PeriodDef_id INT,
@SampleNumber INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT PeriodDef_id, SampleNumber, datScheduledSample_dt, SampleSet_id, datSampleCreate_dt
FROM [dbo].PeriodDates
WHERE PeriodDef_id = @PeriodDef_id
	AND SampleNumber=@SampleNumber

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


