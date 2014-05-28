/*
Business Purpose: 

This procedure is used to display a grid of information about existing sample sets.  Since this dataset joins 
information from so many entities it is not used to populate the Class Library but is just for display purposes

Created:  01/26/2006 by Joe Camp

Modified:
		  04/10/2006 by DC 
			Changed code to return 0 if the computed sample count is null

		  09/05/08 by MWB
			Added ss.HCAHPSOverSample Column
*/
CREATE PROCEDURE [dbo].[QCL_SelectExistingSampleSetsBySurvey]
@SurveyId INT,
@StartDate DATETIME,
@EndDate DATETIME,
@ShowOnlyUnscheduled BIT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	SET @StartDate = ISNULL(@StartDate, '1/1/1900')
	SET @EndDate = ISNULL(@EndDate, '1/1/3000')

	IF @ShowOnlyUnscheduled = 0
	BEGIN
		SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled,
				coalesce(sum(spw.intSampledNow+ spw.intinDirectSampledNow),0) as sampledCount, ss.HCAHPSOverSample
		FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s, Employee e,
			SamplePlanWorksheet spw
		WHERE ss.SampleSet_id = pd.SampleSet_id
		AND pd.PeriodDef_id = p.PeriodDef_id
		AND ss.Survey_id = sd.Survey_id
		AND sd.Study_id = s.Study_id
		AND ss.Employee_id = e.Employee_id
		AND sd.Survey_id = @SurveyId
		AND ss.datSampleCreate_dt > @StartDate
		AND ss.datSampleCreate_dt < DATEADD(DAY, 1, @EndDate)
		AND ss.sampleset_id=spw.sampleset_id 
		AND spw.parentsampleunit_id is null
		GROUP BY s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled, ss.HCAHPSOverSample
		ORDER BY ss.datSampleCreate_dt DESC
	END
	ELSE
	BEGIN
		SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled,
				coalesce(sum(spw.intSampledNow+ spw.intinDirectSampledNow),0) as sampledCount, ss.HCAHPSOverSample
		FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s, Employee e,
			SamplePlanWorksheet spw
		WHERE ss.SampleSet_id = pd.SampleSet_id
		AND pd.PeriodDef_id = p.PeriodDef_id
		AND ss.Survey_id = sd.Survey_id
		AND sd.Study_id = s.Study_id
		AND ss.Employee_id = e.Employee_id
		AND sd.Survey_id = @SurveyId
		AND ss.datSampleCreate_dt > @StartDate
		AND ss.datSampleCreate_dt < DATEADD(DAY, 1, @EndDate)
		AND ss.datScheduled IS NULL
		AND ss.sampleset_id=spw.sampleset_id 
		AND spw.parentsampleunit_id is null
		GROUP BY s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled, ss.HCAHPSOverSample
		ORDER BY ss.datSampleCreate_dt DESC
	END
END


