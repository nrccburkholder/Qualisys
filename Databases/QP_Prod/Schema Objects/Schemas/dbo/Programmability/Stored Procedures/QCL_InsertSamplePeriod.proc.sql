CREATE PROCEDURE [dbo].[QCL_InsertSamplePeriod]
@Employee_id INT,
@strPeriodDef_nm VARCHAR(42),
@intExpectedSamples INT,
@DaysToSample INT,
@datExpectedEncStart DATETIME,
@datExpectedEncEnd DATETIME,
@SamplingMethod_id INT,
@MonthWeek char(1),
@surveyId int
AS

SET NOCOUNT ON

INSERT INTO [dbo].PeriodDef (Employee_id, datAdded, strPeriodDef_nm, intExpectedSamples, DaysToSample, datExpectedEncStart, datExpectedEncEnd, SamplingMethod_id, MonthWeek, survey_id)
VALUES (@Employee_id, getdate(), @strPeriodDef_nm, @intExpectedSamples, @DaysToSample, @datExpectedEncStart, @datExpectedEncEnd, @SamplingMethod_id, @MonthWeek, @surveyID)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


