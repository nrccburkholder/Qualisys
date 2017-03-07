/*
    S70 RTP-1637 create sample periods prior to sampling 1st sampleset of the quarter.sql

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

use [qp_prod]
GO

if exists (select * from sys.procedures where name = 'QCL_InsertQuarterlyRTPeriodsbySurveyId')
	drop procedure QCL_InsertQuarterlyRTPeriodsbySurveyId
GO

CREATE PROCEDURE [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId]
@surveyId int 
AS

if exists(select * from SurveySubType sst inner join 
		SubType st on sst.Subtype_id = st.Subtype_id 
		where survey_ID = @surveyid and 
			st.Subtype_nm = 'RT')
	and
	not exists(select * from perioddef 
		where survey_id = @surveyid and 
			dbo.YearQtr(GetDate()) = dbo.YearQtr(datExpectedEncStart))
BEGIN
	declare @Employee_id INT, --954
	@strPeriodDef_nm VARCHAR(42),  --Jan17
	@intExpectedSamples INT, --31
	@DaysToSample INT = 2,
	@datExpectedEncStart DATETIME, --2017-01-01 
	@datExpectedEncEnd DATETIME, --2017-01-31
	@SamplingMethod_id INT = 1,
	@MonthWeek char(1) = 'D',
	@PeriodDef_id INT, --457135
	@SampleNumber INT, --1,2,3
	@datScheduledSample_dt DATETIME --2017-01-01 2017-01-02 2017-01-03 

	declare @StartingDate datetime = convert(varchar(2),((month(GetDate())-1) / 3) * 3 + 1) + '/01/' + convert(varchar(4), year(GetDate()))

	declare @WorkingDate datetime = @StartingDate

	while DateDiff(month, @StartingDate, @WorkingDate) < 3
	begin
		select @Employee_ID = IsNull(Employee_id, 930) from Employee where SYSTEM_USER like '%'+STRNTLOGIN_NM
		Select @strPeriodDef_nm = convert(varchar(3), DateName(month, @WorkingDate)) + convert(varchar(2),Year(@WorkingDate) % 100)
		select @intExpectedSamples = datediff(day,@workingDate, dateadd(month, 1, @workingDate))
		select @datExpectedEncStart = @workingDate
		select @datExpectedEncEnd = dateadd(day, -1, dateadd(month, 1, @workingdate))

		--exec [dbo].[QCL_InsertSamplePeriod] @Employee_id, @strPeriodDef_nm,	@intExpectedSamples, 
		--	@DaysToSample, @datExpectedEncStart, @datExpectedEncEnd, @SamplingMethod_id, 
		--	@MonthWeek,	@surveyId
		INSERT INTO [dbo].PeriodDef (Employee_id, datAdded, strPeriodDef_nm, intExpectedSamples, DaysToSample, datExpectedEncStart, datExpectedEncEnd, SamplingMethod_id, MonthWeek, survey_id)
		VALUES (@Employee_id, getdate(), @strPeriodDef_nm, @intExpectedSamples, @DaysToSample, @datExpectedEncStart, @datExpectedEncEnd, @SamplingMethod_id, @MonthWeek, @surveyID)

		select @PeriodDef_id = ident_current('PeriodDef')
		select @SampleNumber = 1
		select @datScheduledSample_dt = @WorkingDate

		while DateDiff(day, @WorkingDate, @datScheduledSample_dt) < @intExpectedSamples
		begin
			--exec [dbo].[QCL_InsertSamplePeriodScheduledSample] @PeriodDef_ID, @SampleNumber, @datScheduledSample_dt
			INSERT INTO [dbo].PeriodDates (datScheduledSample_dt, SampleNumber, PeriodDef_id)
			VALUES (@datScheduledSample_dt,@SampleNumber,@PeriodDef_id)
			
			select @datScheduledSample_dt = DateAdd(Day, 1, @datScheduledSample_dt)
			set @SampleNumber = @SampleNumber + 1
		end
		select @WorkingDate = DateAdd(Month, 1, @WorkingDate)
	end

END

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

--RTP-1449 insert sample periods if not already present
	exec [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId] @survey_id
--END: RTP-1449 insert sample periods if not already present

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
