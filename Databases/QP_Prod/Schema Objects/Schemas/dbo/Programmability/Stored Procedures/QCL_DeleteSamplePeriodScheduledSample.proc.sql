CREATE PROCEDURE [dbo].[QCL_DeleteSamplePeriodScheduledSample]
@PeriodDef_id INT,
@SampleNumber INT
AS

SET NOCOUNT ON

DELETE [dbo].PeriodDates
WHERE PeriodDef_id = @PeriodDef_id
	and SampleNumber=@SampleNumber

SET NOCOUNT OFF


