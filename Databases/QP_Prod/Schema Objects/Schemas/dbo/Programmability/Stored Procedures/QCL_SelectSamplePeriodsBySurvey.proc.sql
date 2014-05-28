/*
Business Purpose: 

This procedure will return the period data for all period for a survey.

Created:  01/27/2006 by Dan Christensen

Modified:
		03/28/2006 by DC
		Added code to mark each period as 0=past, 1=active, 2=future

*/

CREATE   PROCEDURE [dbo].[QCL_SelectSamplePeriodsBySurvey]
	@survey_id int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
CREATE TABLE #activePeriod (periodDef_id int, ActivePeriod bit default 0)

INSERT INTO #activePeriod
EXEC [dbo].[QCL_SelectActivePeriodbySurveyId] @survey_id

SELECT p.PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEnd,
    SamplingMethod_id, DaysToSample, monthWeek, coalesce(a.ActivePeriod,0) as ActivePeriod,
	case
		when a.ActivePeriod is not null then 1
		else 0
	end as TimeFrame
INTO #AllPeriods
FROM PeriodDef p LEFT JOIN #activePeriod a
ON p.perioddef_id=a.perioddef_id 
WHERE p.survey_id =@survey_id

--Mark any periods that are in the future
UPDATE #AllPeriods
SET TimeFrame=2
WHERE perioddef_id in 
	(select p.perioddef_id
	 from #AllPeriods p, perioddates pd
	 WHERE p.perioddef_id=pd.perioddef_id and
			p.activeperiod=0 and
			pd.samplenumber=1 and
			pd.datsamplecreate_dt is null)

SELECT *
FROM #AllPeriods


