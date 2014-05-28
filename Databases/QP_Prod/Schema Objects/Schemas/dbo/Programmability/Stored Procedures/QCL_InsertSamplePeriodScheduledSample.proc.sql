CREATE PROCEDURE [dbo].[QCL_InsertSamplePeriodScheduledSample]
@PeriodDef_id INT,
@SampleNumber INT,
@datScheduledSample_dt DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].PeriodDates (datScheduledSample_dt, SampleNumber, PeriodDef_id)
VALUES (@datScheduledSample_dt,@SampleNumber,@PeriodDef_id)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


