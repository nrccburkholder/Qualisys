/*

S63 ATL-1182 Query For Questionnaire Cycle and Strata.sql

Chris Burkholder

12/6/2016

CREATE TABLE CIHI.QA_QuestionnaireCycleAndStrata (
       QuestionnaireCycleAndStrataID int identity(1,1),
0       SubmissionID int,
calc       CycleCD varchar(15),              --Derive from ENCOUNTERFacilityNum & encounter dates? Max length = 15.  Maybe ENCOUNTERFacilityNum + begin MMYY + end MMYY (e.g. 27907_0416_0616)
+       FacilityNum varchar(10),          --ENCOUNTERFacilityNum
4       SubmissionTypeCD varchar(2),      --CIHI.Submission.SubmissionTypeCD
7       CPESVersionCD varchar(15),        --"CPES-IC_PM_V1.0"--CIHI.Submission.SPESVersionCD
5       EncounterDateStart varchar(8),    --CIHI.Submission.EncounterDateStart
6       EncounterDateEnd varchar(8),      --CIHI.Submission.EncounterDateEnd
calc       samplingMethod_CD varchar(4),     --if dischargeCount=sampleSize for all strata then CEN, if one stratum then SRS, if multiple strata then DSRS
calc       dischargeCount int,               --count from eligible enc log
calc       sampleSize int,                   --count (distinct pop_id) from samplepop, sum counts for all units
calc       nonResponseCount int,             --Calculate using dispositionlog, plus non response after max attempts (nothing in dispositionlog for that)
2       sampleunitID int,                 --sampleunit_id
3       strSampleunit_nm varchar(42),     --sampleunit name. Max length in submission file = 25; strsampleunit_nm is varchar(42).
       PRIMARY KEY (QuestionnaireCycleAndStrataID)
);


*/

--select * from CIHI.QA_QuestionnaireCycleAndStratum

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
)

declare @SubmissionID int = 1

insert into #tempQA_QuestionnaireCycleAndStratum (Study_id, sampleunitID, strSampleunit_nm, SubmissionTypeCD, EncounterDateStart, EncounterDateEnd, SubmissionID)
--declare @SubmissionID int = 1
select distinct sd.study_id, su.sampleunit_id, su.strSampleUnit_nm, cs.SubmissionTypeCd, cs.encounterDateStart, cs.encounterDateEnd, cs.CPESVersionCD, cs.SubmissionID
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
	[SampleUnit_ID] [int] NULL,
	[Pop_ID] [int] NULL,
	[Enc_ID] [int] NULL,
	bitflag bit
)

declare @SubmissionID int = 1 --copied here for debugging temporarily
insert into #work (Study_id, SampleUnit_id, Pop_ID, Enc_ID, bitflag)
select sd.study_id, su.Sampleunit_id, pop_id, enc_id, 0
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

/*
study_id	sampleunit_id
26231	5008479
26231	5008480
26231	5009008
*/
--3 sampleunits so DSRS

--TODO: FacilityNum: (Dave G) First look demonstrates two FacilityNum values for the same SampleUnit_id

select distinct * from #work w 
inner join s26231.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id
where w.sampleunit_id = 5008479

select distinct FacilityNum, DischargeUnit from #work w 
inner join s26231.Encounter e on w.pop_id = e.pop_id and w.enc_id = e.enc_id
where w.sampleunit_id = 5008479

--TODO: calc       CycleCD varchar(15),              --Derive from ENCOUNTERFacilityNum & encounter dates? Max length = 15.  Maybe ENCOUNTERFacilityNum + begin MMYY + end MMYY (e.g. 27907_0416_0616)

--TODO: calc       samplingMethod_CD varchar(4),     --if dischargeCount=sampleSize for all strata then CEN, if one stratum then SRS, if multiple strata then DSRS

--TODO: calc       dischargeCount int,               --count from eligible enc log

--TODO: calc       sampleSize int,                   --count (distinct pop_id) from samplepop, sum counts for all units

--TODO: calc       nonResponseCount int,             --Calculate using dispositionlog, plus non response after max attempts (nothing in dispositionlog for that)

--INSERT FOR NOW, s/b a MERGE most likely

INSERT INTO [CIHI].[QA_QuestionnaireCycleAndStratum]
           ([SubmissionID],[CycleCD],[FacilityNum],[SubmissionTypeCD],[CPESVersionCD],[EncounterDateStart],[EncounterDateEnd]
           ,[samplingMethod_CD],[dischargeCount],[sampleSize],[nonResponseCount],[sampleunitID],[strSampleunit_nm])
SELECT /*[QuestionnaireCycleAndStratumID]
      ,*/[SubmissionID],[CycleCD],[FacilityNum],[SubmissionTypeCD],[CPESVersionCD],[EncounterDateStart],[EncounterDateEnd]
      ,[samplingMethod_CD],[dischargeCount],[sampleSize],[nonResponseCount],[sampleunitID],[strSampleunit_nm]
  FROM #tempQA_QuestionnaireCycleAndStratum

DROP TABLE #work
DROP TABLE #tempQA_QuestionnaireCycleAndStratum

