CREATE PROCEDURE [dbo].[QCL_SelectSamplePeriodScheduledSamples]
@PeriodDef_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT PeriodDef_id, SampleNumber, datScheduledSample_dt, SampleSet_id, datSampleCreate_dt
FROM [dbo].PeriodDates
WHERE PeriodDef_id = @PeriodDef_id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


