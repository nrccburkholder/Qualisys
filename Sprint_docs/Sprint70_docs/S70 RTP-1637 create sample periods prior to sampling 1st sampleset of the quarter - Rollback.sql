/*
    S70 RTP-1637 create sample periods prior to sampling 1st sampleset of the quarter - Rollback.sql

	Chris Burkholder

	3/6/2017

	ALTER PROCEDURE [dbo].[QCL_SelectActivePeriodbySurveyId]
	CREATE PROCEDURE [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId]

PeriodDef_id	Survey_id	Employee_id	datAdded	strPeriodDef_nm	intExpectedSamples	DaysToSample	datExpectedEncStart	datExpectedEncEnd	strDayOrder	MonthWeek	SamplingMethod_id
457135	20617	954	2017-01-12 16:17:12.320	Jan17	31	2	2017-01-01 00:00:00.000	2017-01-31 00:00:00.000	NULL	D	1
457136	20617	954	2017-01-12 16:17:12.747	Feb17	28	2	2017-02-01 00:00:00.000	2017-02-28 00:00:00.000	NULL	D	1
457137	20617	954	2017-01-12 16:17:13.110	Mar17	31	2	2017-03-01 00:00:00.000	2017-03-31 00:00:00.000	NULL	D	1

PeriodDef_id	SampleNumber	datScheduledSample_dt	SampleSet_id	datSampleCreate_dt
457135	1	2017-01-01 00:00:00.000	1857366	2017-02-02 23:07:01.417
457135	2	2017-01-02 00:00:00.000	1857373	2017-02-02 23:10:25.357
457135	3	2017-01-03 00:00:00.000	1857380	2017-02-02 23:13:23.287

select top 10 * from survey_def where surveytype_id = 2 order by survey_id desc

select * from perioddef where survey_id = 20617

select * from perioddates where perioddef_id in 
(select perioddef_id from perioddef where survey_id = 20693)
select * from period where survey_id = 20693

*/

if exists (select * from sys.procedures where name = 'QCL_InsertQuarterlyRTPeriodsbySurveyId')
	drop procedure QCL_InsertQuarterlyRTPeriodsbySurveyId
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectActivePeriodbySurveyId]    Script Date: 3/6/2017 9:08:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Business Purpose: 

This procedure is used to select the active period for a survey.

Created:  01/27/2006 by Dan Christensen

Modified:

*/

ALTER PROCEDURE [dbo].[QCL_SelectActivePeriodbySurveyId]
	@survey_id int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

CREATE TABLE #periods (periodDef_id int, ActivePeriod bit default 0)

--Get a list of all periods for this survey
INSERT INTO #periods (periodDef_id)
SELECT periodDef_id
FROM perioddef
WHERE survey_id=@survey_id

--Get a list of all periods that have not completed sampling
SELECT distinct pd.PeriodDef_id
INTO #temp
FROM perioddef p, perioddates pd
WHERE p.perioddef_id=pd.perioddef_id AND
		survey_id=@survey_id AND
	  	datsampleCREATE_dt is null

--Find the active Period.  It is either a period that hasn't completed sampling
--or a period that hasn't started but has the most recent first scheduled date 
--If no unfinished periods exist, set active period to the period with the most
--recently completed sample 

IF EXISTS (SELECT top 1 *
			FROM #temp)
BEGIN
	
	DECLARE @UnfinishedPeriod int
	
	SELECT @UnfinishedPeriod=pd.perioddef_id
	FROM perioddates pd, #temp t
	WHERE pd.perioddef_id=t.perioddef_id AND
		  	pd.samplenumber=1 AND
			pd.datsampleCREATE_dt is not null
	
	IF @UnfinishedPeriod is not null
	BEGIN
		--There is a period that is partially finished, so set it to be active
		UPDATE #periods
		SET ActivePeriod=1
		WHERE perioddef_id = @UnfinishedPeriod
	END
	ELSE
	BEGIN
		--There is no period that is partially finished, so set the unstarted period
		--with the earliest scheduled sample date to be active
		UPDATE #periods
		SET ActivePeriod=1
		WHERE perioddef_id =
			(SELECT top 1 pd.perioddef_id
			 FROM perioddates pd, #temp t
			 WHERE pd.perioddef_id=t.perioddef_id AND
				  	pd.samplenumber=1
			 ORDER BY datscheduledsample_dt)
	END
END
ELSE
BEGIN
	--No unfinished periods exist, so we will set the active to be the most recently
	--finished
	UPDATE #periods
	SET ActivePeriod=1
	WHERE perioddef_id =
		(SELECT top 1 p.perioddef_id
		 FROM perioddates pd, perioddef p
		 WHERE p.survey_id=@survey_id AND
				pd.perioddef_id=p.perioddef_id
		 GROUP BY p.perioddef_id
		 ORDER BY Max(datsampleCREATE_dt) desc)
END

SELECT *
FROM #periods
WHERE ActivePeriod=1

DROP TABLE #temp
DROP TABLE #periods

GO
