/*
    S70 RTP-1637 create sample periods prior to sampling 1st sampleset of the quarter.sql

	Chris Burkholder

	3/6/2017

	CREATE PROCEDURE [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId]
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
GO

if exists (select * from sys.procedures where name = 'QCL_InsertQuarterlyRTPeriodsbySurveyId')
	drop procedure QCL_InsertQuarterlyRTPeriodsbySurveyId
GO

CREATE PROCEDURE [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId]
@surveyId int,
@DateToCheck datetime
AS

if exists(select * from SurveySubType sst inner join 
		SubType st on sst.Subtype_id = st.Subtype_id 
		where survey_ID = @surveyid and 
			st.Subtype_nm = 'RT')
	and
	not exists(select * from perioddef 
		where survey_id = @surveyid and 
			dbo.YearQtr(@DateToCheck) = dbo.YearQtr(datExpectedEncStart))
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

	declare @StartingDate datetime = convert(varchar(2),((month(@DateToCheck)-1) / 3) * 3 + 1) + 
							'/01/' + convert(varchar(4), year(@DateToCheck))

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
Modified: 3/07/2017 by CJB -- RTP-1449 create RT HCAHPS sample periods
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

  --RTP-1449 create RT HCAHPS sample periods
  exec [dbo].[QCL_InsertQuarterlyRTPeriodsbySurveyId] @intSurvey_id, @vcDateRange_FromDate
  -------------------

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