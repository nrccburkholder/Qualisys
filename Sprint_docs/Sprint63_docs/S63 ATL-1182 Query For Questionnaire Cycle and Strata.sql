/*

S63 ATL-1182 Query For Questionnaire Cycle and Strata.sql

Chris Burkholder

12/6/2016

create procedure CIHI.PullSubmissionData_QuestionnaireCycle

*/

--truncate table CIHI.QA_QuestionnaireCycleAndStratum
--select * from CIHI.QA_QuestionnaireCycleAndStratum order by FacilityNum

create procedure CIHI.PullSubmissionData_QuestionnaireCycle
@SubmissionID int
as
begin

CREATE TABLE #tempQA_QuestionnaireCycleAndStratum(
	[SubmissionID] [int] NULL,
	[Study_ID] [int] NULL,
	[CycleCD] [varchar](15) NULL,
	[FacilityNum] [varchar](10) NULL,
	[SubmissionTypeCD] [varchar](2) NULL,
	[CPESVersionCD] [varchar](15) NULL,
	[EncounterDateStart] [varchar](8) NULL,
	[EncounterDateEnd] [varchar](8) NULL,
	[samplingMethod_CD] [varchar](4) NULL,
	[dischargeCount] [int] NULL,
	[sampleSize] [int] NULL,
	[nonResponseCount] [int] NULL,
	[sampleunitID] [int] NULL,
	[strSampleunit_nm] [varchar](42) NULL,
	[bitflag] bit
)

insert into #tempQA_QuestionnaireCycleAndStratum (Study_id, sampleunitID, strSampleunit_nm, SubmissionTypeCD, EncounterDateStart, EncounterDateEnd, CPESVersionCD, SubmissionID, bitFlag)
select distinct sd.study_id, su.sampleunit_id, su.strSampleUnit_nm, cs.SubmissionTypeCd, CONVERT(VARCHAR(8), cs.encounterDateStart, 112), CONVERT(VARCHAR(8), cs.encounterDateEnd, 112), cs.CPESVersionCD, cs.SubmissionID, 0
	from CIHI.Submission cs
		join CIHI.SubmissionSurvey css on cs.submissionID=css.submissionID
		join survey_def sd on css.surveyID=sd.survey_id
		join SAMPLESET ss on sd.survey_id=ss.survey_id
		join SampleUnit su on ss.sampleplan_id=su.sampleplan_id
		join SelectedSample sel on ss.sampleset_id=sel.sampleset_id and su.sampleunit_id=sel.sampleunit_id
	where cs.SubmissionID=@SubmissionID
		and su.CahpsType_id=12
		and sel.strUnitSelectType='D'
		and ss.datDateRange_FromDate>=cs.EncounterDateStart and ss.datDateRange_ToDate<=cs.EncounterDateEnd

/*
This will get you the granularity you want for insertion into the table. But notice that it joins 
to SelectedSample (even though it doesn’t bring back any SelectedSample fields). 
But you use the same query to direct 

study_id, 
Pop_id, 
Enc_id 

into a temp table, and then cycle 
through the temp table, grabbing FacilityNum out of each study’s encounter table. Everyone in 
each sampleunit should have the same FacilityNum value.
*/

CREATE TABLE #work(
	[Study_ID] [int] NULL,
	[SampleSet_ID] [int] NULL,
	[SampleUnit_ID] [int] NULL,
	[Pop_ID] [int] NULL,
	[Enc_ID] [int] NULL
)

insert into #work (Study_id, SampleSet_ID, SampleUnit_ID, Pop_ID, Enc_ID)
select sd.study_id, ss.Sampleset_id, su.Sampleunit_id, pop_id, enc_id
	from CIHI.Submission cs
		join CIHI.SubmissionSurvey css on cs.submissionID=css.submissionID
		join survey_def sd on css.surveyID=sd.survey_id
		join SAMPLESET ss on sd.survey_id=ss.survey_id
		join SampleUnit su on ss.sampleplan_id=su.sampleplan_id
		join SelectedSample sel on ss.sampleset_id=sel.sampleset_id and su.sampleunit_id=sel.sampleunit_id
	where cs.SubmissionID=@SubmissionID
		and su.CahpsType_id=12
		and sel.strUnitSelectType='D'
		and ss.datDateRange_FromDate>=cs.EncounterDateStart and ss.datDateRange_ToDate<=cs.EncounterDateEnd

/*
You’ll then also need to join to EligibleEncLog, samplepop and perhaps others to calculate 

samplingMethod_CD, 
dischargeCount, 
sampleSize 
nonResponseCount.

*Invalid/no phone number
*Invalid/no mailing address
*Invalid email address
*Non-response after max attempts
*Patients who refuse to participate


Dana:
Group by encounter.FacilityNum
If Multiple sampleunits, then DSRS
If 1 sampleunit, then
              If dischargeCount = sampleSize, then CEN
              Else SRS

*/

declare @sql nvarchar(max)
declare @SampleUnitID int
declare @Study varchar(10)
declare @FacilityNum varchar(10)
declare @countFacility int
declare @dischargeCount int
declare @strataCount int
declare @sampleSize int
declare @nonResponseCount int

while exists (select * from #tempQA_QuestionnaireCycleAndStratum where bitFlag = 0)
begin
	select @SampleUnitID = min(SampleUnitId) from #tempQA_QuestionnaireCycleAndStratum where bitFlag = 0
	select @Study = study_id from #tempQA_QuestionnaireCycleAndStratum where SampleUnitId = @SampleUnitID

	select @sql = convert(nvarchar(max), 'select @Result = min(FacilityNum) from #work w ' +
	'inner join s' + @Study + '.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id ' +
	'where w.sampleunit_id = ' + convert(nvarchar,@SampleUnitId))
	exec sp_executesql @sql, N'@Result varchar(10) out', @FacilityNum out

	--First look demonstrates two FacilityNum values for the same SampleUnit_id
	--FacilityNum Error Trap: appropriately append "*" when a FacilityNum is not a singleton per SampleUnit_id

	select @sql = convert(nvarchar(max),'select @Result = count (distinct FacilityNum) from #work w ' +
	'inner join s' + @Study + '.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id ' +
	'where w.sampleunit_id = ' + convert(nvarchar,@SampleUnitId))
	exec sp_executesql @sql, N'@Result int out', @countFacility out

	if @countFacility > 1
		select @FacilityNum = @FacilityNum + '*'

	/*
	select min(FacilityNum) from #work w 
	inner join s26231.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id
	where w.sampleunit_id = 5008479

	select count (distinct FacilityNum) from #work w 
	inner join s26231.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id
	where w.sampleunit_id = 5008479

	select min(FacilityNum) from #work w 
	inner join s26289.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id
	where w.sampleunit_id = 5008793

	select count (distinct FacilityNum) from #work w 
	inner join s26289.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id
	where w.sampleunit_id = 5008793

	select study_id, count(distinct sampleunit_id) from #work
	group by study_id
	*/

	--dischargeCount int,               --count from eligible enc log
	select @dischargeCount = count(distinct eel.pop_id) from #work w 
	inner join eligibleenclog eel on w.SampleSet_ID = eel.sampleset_id and w.SampleUnit_ID = eel.SampleUnit_id
	where w.sampleunit_id = @SampleUnitId

	--sampleSize int,                   --count (distinct pop_id) from samplepop, sum counts for all units
	select @sampleSize = count(distinct w.pop_id) from #work w
	inner join samplepop sp on w.sampleset_id = sp.sampleset_id and w.pop_id = sp.pop_id
	inner join sampleset ss on sp.sampleset_id = ss.sampleset_id
	inner join #tempQA_QuestionnaireCycleAndStratum tq on tq.sampleunitid = w.sampleunit_id
	where tq.EncounterDateStart <= ss.datDateRange_FromDate and tq.EncounterDateEnd >= ss.datDateRange_ToDate
	and w.sampleunit_id = @SampleUnitId

	--nonResponseCount int,             --Calculate using dispositionlog, plus non response after max attempts (nothing in dispositionlog for that)
	select @nonResponseCount = count(distinct w.pop_id) from #work w
	inner join samplepop sp on w.sampleset_id = sp.sampleset_id and w.pop_id = sp.pop_id
	inner join sampleset ss on sp.sampleset_id = ss.sampleset_id
	inner join #tempQA_QuestionnaireCycleAndStratum tq on tq.sampleunitid = w.sampleunit_id
	left join DispositionLog dl on dl.SamplePop_id = sp.SAMPLEPOP_ID
	where tq.EncounterDateStart <= ss.datDateRange_FromDate and tq.EncounterDateEnd >= ss.datDateRange_ToDate
	and (dl.Disposition_id in (5,14,16,27,46,47,52) /*bad addr, bad phone, refusal*/ 
		or dl.Disposition_id is null /*non-response after max attempts*/ )
	and w.sampleunit_id = @SampleUnitId

	/*
	select * from disposition where disposition_id in (14,16,27,46,47,52)
	Disposition_id	strDispositionLabel
	5	The intended respondent is not at this address
	14	The intended respondent is not at this phone
	16	Bad/Missing/Wrong phone number
	27	Declined to participate
	46	Unused Bad Address
	47	Unused Bad Phone
	52	Bad address and bad phone
	*/

	update #tempQA_QuestionnaireCycleAndStratum set 
		FacilityNum = @FacilityNum,
		--CycleCD varchar(15),              --Derive from ENCOUNTERFacilityNum & encounter dates? Max length = 15.  Maybe ENCOUNTERFacilityNum + begin MMYY + end MMYY (e.g. 27907_0416_0616)
		CycleCD = LEFT(@FacilityNum + '_' + 
			SUBSTRING(EncounterDateStart,5,2) + SUBSTRING(EncounterDateStart,3,2) + '_' + 
			SUBSTRING(EncounterDateEnd,5,2) + SUBSTRING(EncounterDateEnd,3,2), 15),
		dischargeCount = @dischargeCount,
		sampleSize = @sampleSize,
		nonResponseCount = @nonResponseCount,
		bitflag = 1 
	where SampleUnitId = @SampleUnitId
end

while exists (select * from #tempQA_QuestionnaireCycleAndStratum where samplingMethod_CD is null)
begin
	select @SampleUnitID = min(SampleUnitId) from #tempQA_QuestionnaireCycleAndStratum where samplingMethod_CD is null
	select @FacilityNum = FacilityNum from #tempQA_QuestionnaireCycleAndStratum where SampleUnitid = @SampleUnitID

	select @strataCount = count(distinct SampleUnitId) from #tempQA_QuestionnaireCycleAndStratum where FacilityNum = @FacilityNum

	update #tempQA_QuestionnaireCycleAndStratum set 
		--samplingMethod_CD varchar(4),     --if dischargeCount=sampleSize for all strata then CEN, if one stratum then SRS, if multiple strata then DSRS
		samplingMethod_CD = case 
			when @StrataCount > 1 then 'DSRS' 
			when dischargeCount = sampleSize then 'CEN' 
			else 'SRS' end
	where SampleUnitId = @SampleUnitId
end

--INSERT (Blindly), Clearing the Deck for an additional time will be the reponsibility of the calling application per Dave G 12/8/2016

INSERT INTO [CIHI].[QA_QuestionnaireCycleAndStratum]
           ([SubmissionID],[CycleCD],[FacilityNum],[SubmissionTypeCD],[CPESVersionCD],[EncounterDateStart],[EncounterDateEnd]
           ,[samplingMethod_CD],[dischargeCount],[sampleSize],[nonResponseCount],[sampleunitID],[strSampleunit_nm])
SELECT /*[QuestionnaireCycleAndStratumID]
      ,*/[SubmissionID],[CycleCD],[FacilityNum],[SubmissionTypeCD],[CPESVersionCD],[EncounterDateStart],[EncounterDateEnd]
      ,[samplingMethod_CD],[dischargeCount],[sampleSize],[nonResponseCount],[sampleunitID],[strSampleunit_nm]
  FROM #tempQA_QuestionnaireCycleAndStratum

DROP TABLE #work
DROP TABLE #tempQA_QuestionnaireCycleAndStratum

end 

GO