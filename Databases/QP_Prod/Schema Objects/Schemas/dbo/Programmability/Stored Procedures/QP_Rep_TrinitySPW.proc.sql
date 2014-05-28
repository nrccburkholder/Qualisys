CREATE procedure QP_Rep_TrinitySPW
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
AS

exec master.dbo.xp_sendmail @recipients='bdohmen', @subject='QP_Rep_TrinitySPW', @message=@Associate

set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intSampleSet_id int, @DQAddress int, @DQAge int, @strsql varchar(2000), @intstudy_id int

select @intSurvey_id=sd.survey_id, @intstudy_id=s.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

 create table #SPW
 (SampleUnit_id int,    
  Tier int,
  Unit_nm varchar(60),
  PRT int,     -- Period Return Target
  QP int,      -- Qualified Population
  DRR int,     -- Default Response Rate
  HRRn int,    -- Historic Response Rate (numerator)
  HRRd int,    -- Historic Response Rate (denominator)
  HRR float,   -- Historic Response Rate 
  TPO int,     -- Total Prior Outgo for this period
  AR float,    -- Anticipated Returns from TPO
  ARN float,   -- Additional Returns Needed 
  SAP int,     -- Samples Already Pulled
  SIP int,     -- Samples In Period
  SLP int,     -- Samples Left in Period
  APON float,  -- Additional Period Outgo Needed 
  ONTS int,    -- Outgo Needed This Sampleset
  STS int,     -- Sampled This Sampleset
  D int,       -- Difference between ONTS and STS
  Avail int,   -- Available records
  DQAdd int,  -- Records DQ'd for address
  DQAge int)   -- Records DQ'd for age
 
 create table #SampleUnits
  (SampleUnit_id int,
   strSampleUnit_nm varchar(255),
   intTier int,
   intTreeOrder int)

 declare @intSamplePlan_id int
 select @intSamplePlan_id=sampleplan_id from sampleset where sampleset_id=@intSampleset_id
 exec sp_SampleUnits @intSamplePlan_id
 
 INSERT into #SPW (Unit_nm, STS)
   select 'Total Individuals Sampled', count(*)
   from SamplePop
   where sampleset_id=@intSampleset_id

 INSERT into #SPW 
   (SampleUnit_id, tier, Unit_nm, PRT, QP, DRR, HRRn, HRRd, HRR, TPO, AR, ARN, SAP, SIP, SLP, APON, ONTS, STS, D)
 select sampleunit_id, intTier, strSampleUnit_nm, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 from #sampleunits
 
 drop table #SampleUnits

 UPDATE #SPW
 set PRT = intTargetReturn, DRR = NUMINITResponseRate, HRR = NULL
 from sampleunit SU
 where #SPW.SampleUnit_id = SU.SampleUnit_id

 DECLARE @ResponseRate_Recalc_Period int, @datSampleCreate_dt datetime
 -- Fetch the Response Rate Recalculation Period 
 SELECT @ResponseRate_Recalc_Period = intResponse_Recalc_Period
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id

 -- Fetch the date/time the sampleset was created 
 SELECT @datSampleCreate_dt=datSampleCreate_dt 
  FROM dbo.SampleSet
  WHERE SampleSet_id = @intSampleSet_id

 -- Fetch the period datetime bookends
 DECLARE @datPeriodStart datetime, @datPeriodEnd datetime
 select @datPeriodStart = ISNULL(max(datPeriodDate),'1/1/1990')
 from Period
 where datperioddate<@datSampleCreate_dt
   and survey_id=@intSurvey_id

 select @datPeriodEnd = ISNULL(min(datPeriodDate),getdate())
 from Period
 where datperioddate>@datSampleCreate_dt
   and survey_id=@intSurvey_id

 CREATE TABLE #SampleSet_Status
  (SampleSet_id int, bitComplete bit)
 -- Identify the Sample Sets that have mailing items. 
 INSERT INTO #SampleSet_Status
  SELECT DISTINCT SS.SampleSet_id, 1
   FROM dbo.SampleSet SS, dbo.SamplePop SP, dbo.ScheduledMailing SchM
   WHERE SS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SS.Survey_id = @intSurvey_id
    AND SS.datSampleCreate_dt < @datSampleCreate_dt

 -- Of the sample sets that have mailing items, identify the ones that have non-generated mailing items. 
 UPDATE #SampleSet_Status
  SET bitComplete = 0
   FROM #SampleSet_Status SSS, dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, dbo.MailingStep MS
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND (SchM.SentMail_id IS NULL OR SchM.datGenerate >= @datSampleCreate_dt)
    AND SchM.OverrideItem_id IS NULL
    
 CREATE TABLE #SampleSet_MailDate
  (SampleSet_id int, datLastMailDate datetime, bitCompleteCollMethod bit)
 -- Of the sample sets that have generated all mailing items, identify the date the last non-Thank You item was sent 
 INSERT INTO #SampleSet_MailDate
  SELECT SSS.SampleSet_id, MAX(SM.datMailed), 0
   FROM #SampleSet_Status SSS, dbo.SamplePop SP, dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, dbo.MailingStep MS
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.SentMail_id = SM.SentMail_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND SchM.OverrideItem_id IS NULL
    AND SSS.bitComplete = 1
   GROUP BY SSS.SampleSet_id
 DROP TABLE #SampleSet_Status
 
 -- Mark the Sample Sets that have completed the collection methodology 
 UPDATE #SampleSet_MailDate
  SET bitCompleteCollMethod = 1
  WHERE datLastMailDate IS NOT NULL
   AND DATEDIFF(day, datLastMailDate, @datSampleCreate_dt) > @ResponseRate_Recalc_Period
 CREATE TABLE #SampleUnit_Mailed
  (SampleUnit_id int, intNumMailed int)

 -- For each Sample Unit, calculate the number of people directly sampled from the sample sets that have completed the collection methodology 
 INSERT INTO #SampleUnit_Mailed
  SELECT SU.SampleUnit_id, COUNT(DISTINCT SS.Pop_id)
   FROM dbo.SamplePlan SP, dbo.SampleUnit SU, dbo.SelectedSample SS, 
    dbo.SamplePop SPop, dbo.QuestionForm QF, #SampleSet_MailDate SSMD
   WHERE SP.SamplePlan_id = SU.SamplePlan_id
    AND SU.SampleUnit_id = SS.SampleUnit_id
    AND SS.SampleSet_id = SSMD.SampleSet_id
    AND SS.SampleSet_id = SPop.SampleSet_id
    AND SS.Study_id = SPop.Study_id
    AND SS.Pop_id = SPop.Pop_id
    AND SPop.SamplePop_id = QF.SamplePop_id
    AND SP.Survey_id = @intSurvey_id
    AND SSMD.bitCompleteCollMethod = 1
    AND SS.strUnitSelectType = 'D'
   GROUP BY SU.SampleUnit_id
 CREATE TABLE #SampleUnit_Returned
  (SampleUnit_id int, intNumReturn int)

 -- For each Sample Unit, calculate the number of people who have returned surveys from the sample sets that have completed the collection methodology 
 INSERT INTO #SampleUnit_Returned
  SELECT SU.SampleUnit_id, COUNT(DISTINCT SS.Pop_id)
   FROM dbo.SamplePlan SP, dbo.SampleUnit SU, dbo.SelectedSample SS, 
    dbo.SamplePop SPop, dbo.QuestionForm QF, #SampleSet_MailDate SSMD
   WHERE SP.SamplePlan_id = SU.SamplePlan_id
    AND SU.SampleUnit_id = SS.SampleUnit_id
    AND SS.SampleSet_id = SSMD.SampleSet_id
    AND SS.SampleSet_id = SPop.SampleSet_id
    AND SS.Study_id = SPop.Study_id
    AND SS.Pop_id = SPop.Pop_id
    AND SPop.SamplePop_id = QF.SamplePop_id
    AND SP.Survey_id = @intSurvey_id
    AND SSMD.bitCompleteCollMethod = 1
    AND SS.strUnitSelectType = 'D'
    AND ISNULL(QF.datReturned,getdate()) < @datSampleCreate_dt
   GROUP BY SU.SampleUnit_id

 -- Calculate and Record the Response Rate for each sample unit 
 UPDATE #SPW
  SET HRRn = SUR.intNumReturn,
      HRRd = SUS.intNumMailed,
      HRR = CONVERT(float, SUR.intNumReturn)/CONVERT(float, SUS.intNumMailed) * 100
  FROM #SampleUnit_Mailed SUS, #SampleUnit_Returned SUR
  WHERE #SPW.SampleUnit_id = SUS.SampleUnit_id
    AND SUS.SampleUnit_id = SUR.SampleUnit_id
    AND SUR.intNumReturn <> 0
    AND SUS.intNumMailed <> 0 
 DROP TABLE #SampleUnit_Mailed
 DROP TABLE #SampleUnit_Returned
 DROP TABLE #SampleSet_MailDate


 DECLARE @SamplesInPeriod INT
 DECLARE @SamplesRun INT
 DECLARE @SamplesLeft INT

 -- Creating temp tables for calculation of targets 
 -- The following table will retain the number of eligible record per sample unit 
 CREATE TABLE #SampleUnit_Count
  (SampleUnit_id INT, 
  PopCounter INT)
 -- The following table will retain the sample_sets within this period
 CREATE TABLE #SampleSet_Period
  (SampleSet_id INT)
 -- The following table will retain the number of Samples left, target returns and response rates for each sample_units 
 CREATE TABLE #SampleUnit_Temp

  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period INT, 
  ResponseRate INT,
  InitResponseRate INT)
 -- The following table will retain the different numbers used to compute targets for each sample_units 
 CREATE TABLE #SampleUnit_Sample
  (SampleUnit_id INT, 
  SamplesLeft INT, 
  TargetReturn_Period INT, 
  ResponseRate INT, 
  InitResponseRate INT,
  NumSampled_Period INT, 
  ReturnEstimate INT, 
  ReturnsNeeded_Period INT, 
  NumToSend_Period FLOAT, 
  NumToSend_SampleSet INT)
 -- Getting the other sampleSet_id prior to the one we are processing 
 INSERT INTO #SampleSet_Period
  SELECT SampleSet_id 
  FROM dbo.SampleSet S
  WHERE S.survey_id = @intSurvey_id
   AND S.SampleSet_id <> @intSampleSet_id
   AND S.datSampleCreate_dt between @datPeriodStart and dateadd(second,-1,@datSampleCreate_dt)
 SELECT @SamplesInPeriod = intSamplesInPeriod
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id
 SELECT @SamplesRun = COUNT(*)
  FROM #SampleSet_Period
 SELECT @SamplesLeft = @SamplesInPeriod - @SamplesRun
 IF @SamplesLeft < 1 
  SELECT @SamplesLeft = 1 
 INSERT INTO #SampleUnit_Temp (SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate)
  SELECT SampleUnit_id, @SamplesLeft, PRT, HRR, DRR
   FROM #spw SP
   --WHERE SP.SamplePlan_id = SU.SamplePlan_id
   -- AND SP.Survey_id = @intSurvey_id
 INSERT INTO #SampleUnit_Sample(SampleUnit_id, SamplesLeft, 
      TargetReturn_Period, ResponseRate, InitResponseRate,
   NumSampled_Period, ReturnEstimate, ReturnsNeeded_Period, NumToSend_Period, 
   NumToSend_SampleSet)
  SELECT  SampleUnit_id, SamplesLeft, 
   TargetReturn_Period, ResponseRate, InitResponseRate, 0, 0, 0, 0, 0
   FROM  #SampleUnit_Temp
 INSERT INTO #SampleUnit_Count
  SELECT SS.SampleUnit_id, COUNT(DISTINCT Pop_id)
   FROM dbo.SelectedSample SS, #SampleSet_Period SSP
   WHERE SS.SampleSet_id = SSP.SampleSet_id
    AND SS.strUnitSelectType = 'D'
   GROUP BY SS.SampleUnit_id
 UPDATE #SampleUnit_Sample
  SET NumSampled_Period = PopCounter
  FROM #SampleUnit_Count SUC
  WHERE SUC.SampleUnit_id = #SampleUnit_Sample.SampleUnit_id
 /* Computing the rest of the SampleUnit targets */
 UPDATE #SampleUnit_Sample
  SET ReturnEstimate = ROUND(NumSampled_Period * (CONVERT(float,isnull(ResponseRate,initResponseRate))/100), 0)
 UPDATE #SampleUnit_Sample
  SET ReturnsNeeded_Period = TargetReturn_Period - ReturnEstimate
  WHERE (TargetReturn_Period - ReturnEstimate) > 0
 UPDATE #SampleUnit_Sample
  SET NumToSend_Period = ReturnsNeeded_Period/(CONVERT(float, isnull(ResponseRate,initResponseRate))/100)
 UPDATE #SampleUnit_Sample
  SET NumToSend_SampleSet = ROUND(NumToSend_Period/SamplesLeft, 0)

 UPDATE #SPW
   set SAP=@SamplesRun,
       SIP=@SamplesInPeriod,
       SLP=SamplesLeft,
       PRT=TargetReturn_Period, 
       TPO=NumSampled_Period, 
       AR=ReturnEstimate, 
       ARN=ReturnsNeeded_Period, 
       APON=NumToSend_Period, 
       ONTS=NumToSend_SampleSet,
       D=0
  FROM #SampleUnit_Sample
  WHERE #SPW.SampleUnit_id=#SampleUnit_Sample.SampleUnit_id

 DROP TABLE #SampleUnit_Count
 DROP TABLE #SampleSet_Period
 DROP TABLE #SampleUnit_Temp
 DROP TABLE #SampleUnit_Sample

 update #SPW
   set STS=cnt
   from (select sampleunit_id, count(*) as cnt
         from selectedsample
         where sampleset_id=@intSampleSet_id
           and STRUNITSELECTTYPE='D'
         group by sampleunit_id) xx
   where xx.sampleunit_id=#spw.sampleunit_id

 update #SPW
   set D = ONTS-STS 

 Create table #avail (sampleunit_id int, cnt int)

 set @strsql = 'insert into #avail select sampleunit_id, count(distinct pop_id) from s' + convert(varchar,@intstudy_id) + '.unikeys
	where sampleset_id = ' + convert(varchar,@intsampleset_id) + ' group by sampleunit_id'

 exec (@strsql)

 update t
   set t.avail = a.cnt
   from #spw t, #avail a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #avail

 Create table #addr (sampleunit_id int, cnt int)
 
 set @dqaddress = (select businessrule_id from businessrule br, criteriastmt c
	where survey_id = @intsurvey_id
	and br.criteriastmt_id = c.criteriastmt_id
	and c.strcriteriastmt_nm = 'DQ_AddEr')
 
 insert into #addr select sampleunit_id, count(*) from unitdq
	where sampleset_id = @intsampleset_id
	and dqrule_id = @dqaddress
	group by sampleunit_id

 update t
   set t.dqadd = a.cnt
   from #spw t, #addr a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #addr

 Create table #age (sampleunit_id int, cnt int)

 set @dqage = (select businessrule_id from businessrule br, criteriastmt c
	where survey_id = @intsurvey_id
	and br.criteriastmt_id = c.criteriastmt_id
	and c.strcriteriastmt_nm = 'DQ_Age')

 insert into #age select sampleunit_id, count(*) from unitdq
	where sampleset_id = @intsampleset_id
	and dqrule_id = @dqage
	group by sampleunit_id

 update t
   set t.dqage = a.cnt
   from #spw t, #age a
   where  t.sampleunit_id = a.sampleunit_id
 
 drop table #age
 

 select 
    Unit_nm as SampleUnit,
    Tier,
    SampleUnit_id as [Unit ID],
    PRT,
    DRR,
    str(HRR,10,2) as HRR,
    TPO,
    str(AR,10,2) as AR,
    str(ARN,10,2) as ARN,
    SAP,
    SIP,
    SLP,
    str(APON,10,2) as APON,
    ONTS,
    STS,
    D ,
    Avail ,
    DQAdd , 
    DQAge
 from #spw

 drop table #spw

set transaction isolation level read committed


