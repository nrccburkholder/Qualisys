CREATE PROCEDURE [dbo].[QCL_SelectSamplePeriod]
	@period_id int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
--This recordSET has the Period Properties informatiON
SELECT PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEND,
    SamplingMethod_id, DaysToSample, monthWeek
INTO #period
FROM PeriodDef
WHERE perioddef_id =@period_id

CREATE table #activePeriod (periodDef_id int, ActivePeriod bit default 0)

DECLARE @survey_id int
SELECT @survey_id=survey_id
FROM #period

IF @survey_id IS NOT NULL
BEGIN
	INSERT INTO #activePeriod
	EXEC [dbo].[QCL_SELECTActivePeriodbySurveyId] @survey_id
END

SELECT p.PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEnd,
    SamplingMethod_id, DaysToSample, monthWeek, coalesce(a.ActivePeriod,0) as ActivePeriod,
	case
		when a.ActivePeriod is not null then 1
		else 0
	end as TimeFrame
INTO #AllPeriod
FROM #period p LEFT JOIN #activePeriod a
ON p.perioddef_id=a.perioddef_id 
WHERE p.survey_id =@survey_id

--Mark any periods that are in the future
UPDATE #AllPeriod
SET TimeFrame=2
WHERE perioddef_id in 
	(select p.perioddef_id
	 from #AllPeriod p, perioddates pd
	 WHERE p.perioddef_id=pd.perioddef_id and
			p.activeperiod=0 and
			pd.samplenumber=1 and
			pd.datsamplecreate_dt is null)

SELECT *
FROM #AllPeriod


