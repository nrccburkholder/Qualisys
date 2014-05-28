/*
Business Purpose: 

This procedure is used to select the active period for a survey.

Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectActivePeriodbySurveyId]
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


