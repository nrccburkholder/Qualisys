CREATE PROCEDURE [dbo].[QCL_UpdateSamplePeriodScheduledSample]
@PeriodDef_id INT,
@SampleNumber INT,
@datScheduledSample_dt DATETIME,
@datActualSample_dt DATETIME 
AS

SET NOCOUNT ON

UPDATE [dbo].PeriodDates SET
	datScheduledSample_dt = @datScheduledSample_dt,
	datSampleCreate_dt = @datActualSample_dt
WHERE PeriodDef_id = @PeriodDef_id
	and SampleNumber=@SampleNumber

SET NOCOUNT OFF


