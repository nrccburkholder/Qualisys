/*
    S70 RTP-1637 create sample periods prior to sampling 1st sampleset of the quarter - Rollback.sql

	Chris Burkholder

	3/6/2017

	CREATE PROCEDURE [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId]
	ALTER PROCEDURE [dbo].[QCL_InsertSampleSet]   
	ALTER PROCEDURE [dbo].[QCL_SelectSamplePeriodsBySurvey]

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

use [qp_prod]
go

delete from Employee where STREMPLOYEE_TITLE = 'Automation' and STRNTLOGIN_NM = 'SystemUser'
GO

if exists (select * from sys.procedures where name = 'QCL_InsertQuarterlyRTPeriodsbySurveyId')
	drop procedure QCL_InsertQuarterlyRTPeriodsbySurveyId
GO

/****** Object:  StoredProcedure [dbo].[QCL_InsertSampleSet]    Script Date: 3/7/2017 3:40:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
Business Purpose:   
This procedure is used to support the Qualisys Class Library.  It creates a new  
sampleset record and also adds placeholders in the sampleplanworksheet table.  
  
Created:  2/23/2006 by DC  
  
Modified: 5/18/2006 by SS -- If Table_id or Field_id is passed as zero set it to NULL because of FK to metatable
Modified: 7/15/2009 by DRM -- Changed @@identity to Scope_Identity()  
  
*/   
  
ALTER PROCEDURE [dbo].[QCL_InsertSampleSet]   
 @intSurvey_id INT,  
 @intEmployee_id INT,  
 @vcDateRange_FromDate VARCHAR(24) = NULL,  
 @vcDateRange_ToDate VARCHAR(24) = NULL,  
 @tiOverSample_flag bit,  
 @tiNewPeriod_flag bit,  
 @intPeriodDef_id int,  
 @strSurvey_nm VARCHAR(10),   
 @intSampleEncounterDateRange_Table_id int,   
 @intSampleEncounterDateRange_Field_id int,  
 @SamplingAlgorithmId int,  
 @intSamplePlan_id INT,  
 @SurveyType_id INT,  
 @HCAHPSOverSample bit  
AS  
  
BEGIN  
  
  DECLARE @intSampleSet_id int  
  
 --If Table_id or Field_id is passed as zero set it to NULL because of FK to metatable  
  SELECT @intSampleEncounterDateRange_Table_id = CASE WHEN @intSampleEncounterDateRange_Table_id = -1 THEN NULL ELSE @intSampleEncounterDateRange_Table_id END,  
  @intSampleEncounterDateRange_Field_id = CASE WHEN @intSampleEncounterDateRange_Field_id = -1 THEN NULL ELSE @intSampleEncounterDateRange_Field_id END  
  
  
  INSERT INTO dbo.SampleSet  
   (SamplePlan_id, Survey_id, Employee_id, datSampleCreate_dt,   
    intDateRange_Table_id, intDateRange_Field_id,   
    datDateRange_FromDate,   
    datDateRange_ToDate, tiOverSample_flag, tiNewPeriod_flag, strSampleSurvey_nm,  
  SamplingAlgorithmId,surveytype_id, HCAHPSOverSample)  
  VALUES  
   (@intSamplePlan_id, @intSurvey_id, @intEmployee_id, GETDATE(),   
    @intSampleEncounterDateRange_Table_id, @intSampleEncounterDateRange_Field_id, @vcDateRange_FromDate,   
    @vcDateRange_ToDate, @tiOverSample_flag, @tiNewPeriod_flag, @strSurvey_nm,  
  @SamplingAlgorithmId,@SurveyType_id, @HCAHPSOverSample)  
                                                                                                                                                                           
  SELECT @intSampleSet_id = Scope_Identity()
  
  --Insert into SamplePlanWorkSheet table  
  INSERT INTO SamplePlanWorkSheet (SampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intPeriodReturnTarget,   
   numDefaultResponseRate, intSamplesInPeriod)  
  SELECT @intSampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intTargetReturn,   
   numInitResponseRate, intExpectedSamples  
  FROM SampleUnit su, SamplePlan sp, Survey_def sd, Perioddef p  
  WHERE sp.Survey_id = @intSurvey_id  
  AND sp.SamplePlan_id = su.SamplePlan_id  
  AND sp.Survey_id = sd.Survey_id   
  AND sd.survey_id=p.survey_Id  
  AND p.periodDef_id=@intPeriodDef_id  
  
 SELECT @intSampleSet_id AS intSampleSet_id  
END  
  
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectSamplePeriodsBySurvey]    Script Date: 3/10/2017 12:12:57 PM ******/
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

ALTER   PROCEDURE [dbo].[QCL_SelectSamplePeriodsBySurvey]
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

