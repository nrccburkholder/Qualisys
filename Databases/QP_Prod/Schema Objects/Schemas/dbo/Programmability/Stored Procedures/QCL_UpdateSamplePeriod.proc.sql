CREATE PROCEDURE [dbo].[QCL_UpdateSamplePeriod]
@PeriodDef_id INT,
@Employee_id INT,
@strPeriodDef_nm VARCHAR(42),
@intExpectedSamples INT,
@DaysToSample INT,
@datExpectedEncStart DATETIME,
@datExpectedEncEnd DATETIME,
@SamplingMethod_id INT,
@MonthWeek char(1)
AS

SET NOCOUNT ON

UPDATE [dbo].PeriodDef SET
	Employee_id = @Employee_id,
	strPeriodDef_nm = @strPeriodDef_nm,
	intExpectedSamples = @intExpectedSamples,
	DaysToSample = @DaysToSample,
	datExpectedEncStart = @datExpectedEncStart,
	datExpectedEncEnd = @datExpectedEncEnd,
	SamplingMethod_id = @SamplingMethod_id,
	MonthWeek=@MonthWeek
WHERE PeriodDef_id = @PeriodDef_id


SET NOCOUNT OFF


