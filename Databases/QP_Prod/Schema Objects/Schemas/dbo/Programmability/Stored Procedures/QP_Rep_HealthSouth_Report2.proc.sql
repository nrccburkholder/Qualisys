CREATE procedure QP_Rep_HealthSouth_Report2
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
as
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intSampleSet_id int, @intStudy_id int, @strsql varchar(8000)

select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id 
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

declare @newperiod datetime

select @newperiod = max(datperioddate) 
from period
where survey_id = @intSurvey_id

Create table #report (sampleunit_id int, [Facility Number] varchar(42), [Qtr Goal] int, SentSurveysQTD int, RtrndSurveysQTD int, 
[Response Rate] numeric(5,2), RcvdRecordsQTD int, RcvdRecordsWeek int, GoodRecordsWeek int, [Should Send] int, [Will Send] int, 
Variance int)

insert into #report (sampleunit_id, [Facility Number], [Qtr Goal])
select sampleunit_id, strsampleunit_nm, inttargetreturn
from sampleunit su, sampleplan sp
where su.sampleplan_id = sp.sampleplan_id
and sp.survey_id = @intSurvey_id
and su.inttargetreturn > 0

create table #qtd (sampleunit_id int, samplepop_id int, outgo int, returned int)

insert into #qtd
select ss.sampleunit_id, samplepop_id, 1, 0
from #report r, selectedsample ss, sampleset sset, samplepop sp
where r.sampleunit_id = ss.sampleunit_id
and ss.strunitselecttype = 'd'
and ss.sampleset_id = sp.sampleset_id
and ss.pop_id = sp.pop_id
and sp.sampleset_id = sset.sampleset_id
and sp.sampleset_id <> @intSampleSet_id
and sset.survey_id = @intSurvey_id
and sset.datsamplecreate_dt > @newperiod

update q
set q.returned = 1
from #qtd q, questionform qf
where q.samplepop_id = qf.samplepop_id
and qf.datresultsimported is not null

create table #outgo (sampleunit_id int, outgo int, returned int)

insert into #outgo
select sampleunit_id, sum(outgo), sum(returned)
from #qtd
group by sampleunit_id

update r
set sentsurveysQTD = outgo, RtrndSurveysQTD = returned
from #outgo o, #report r
where r.sampleunit_id = o.sampleunit_id

create table #datasets (dataset_id int)

insert into #datasets
select distinct dataset_id
from sampledataset sds, sampleset ss
where ss.survey_id = @intSurvey_id
and ss.datsamplecreate_dt > @newperiod
and ss.sampleset_id = sds.sampleset_id

set @strsql = 'select encounterfacilitynum, count(*) as records '+
	' into #recordsqtd '+
	' from s'+convert(varchar,@intStudy_id)+'.big_view bv, datasetmember dsm, #datasets ds '+
	' where ds.dataset_id=dsm.dataset_id '+
	' and dsm.enc_id=bv.encounterenc_id '+
	' group by encounterfacilitynum '

exec (@strsql)

update r
set r.rcvdrecordsQTD=rq.records
from #report r, #recordsqtd rq
where r.[facility number]=rq.encounterfacilitynum

declare @recalc int

select @recalc = intresponse_recalc_period
from survey_def 
where survey_id = @intSurvey_id

--select sampleunit_id, sum(intreturned) as returned, (sum(intsampled)-sum(intud)) as outgo
select sampleunit_id, sum(intreturned) as returned, sum(intsampled) as outgo
into #rrr
from respratecount rr, sampleset ss
where ss.survey_id = @intSurvey_id
and ss.sampleset_id = rr.sampleset_id
and ss.datlastmailed is not null
and ss.datlastmailed < dateadd(day,-@recalc,getdate())
group by sampleunit_id

delete #rrr
where outgo < 1

select sampleunit_id, ((returned*1.0)/outgo) as resprate
into #rr
from #rrr
where outgo > 0

update r
set r.[response rate] = (rr.resprate*100)
from #report r, #rr rr
where r.sampleunit_id = rr.sampleunit_id

update r
set r.[response rate] = su.numinitresponserate
from #report r, sampleunit su
where su.sampleunit_id = r.sampleunit_id
and r.[response rate] is null

create table #time (mindate datetime)

create table #f1 (facilitynum int, visittype char(5), cnt1 int)

create table #f2 (facilitynum int, visittype char(5), cnt2 int)

create table #f11 (facilitynum int, cnt1 int)

create table #f22 (facilitynum int, cnt2 int)

if @intstudy_id in (190,207,255)

  begin

set @strsql = 'insert into #time ' +
	' select dateadd(second,-1,min(newrecorddate)) ' +
	' from s' + convert(varchar,@intStudy_id) + '.encounter_load ' 

exec (@strsql)

set @strsql = 'insert into #f1 ' +
	' select facilitynum, visittype, count(*) ' +
	' from s' + convert(varchar,@intStudy_id) + '.encounter_load ' +
	' group by facilitynum, visittype '

exec (@strsql)

set @strsql = 'insert into #f2 ' +
	' select facilitynum, visittype, count(*) ' +
	' from s' + convert(varchar,@intStudy_id) + '.encounter ' +
	' where newrecorddate >= (select mindate from #time) ' +
	' group by facilitynum, visittype '

exec (@strsql)

update r
set rcvdrecordsweek = cnt1, goodrecordsweek = cnt2
from #report r, (select ('0'+convert(varchar,f1.facilitynum)) as facilitynum, cnt1, cnt2
from #f1 f1 left outer join #f2 f2
on f1.facilitynum = f2.facilitynum
and f1.visittype = f2.visittype) a
where r.[facility number] = a.facilitynum

  end

if @intstudy_id not in (190,207,255)

  begin

set @strsql = 'insert into #time ' +
	' select dateadd(second,-1,min(newrecorddate)) ' +
	' from s' + convert(varchar,@intStudy_id) + '.encounter_load ' 

exec (@strsql)

set @strsql = 'insert into #f11 ' +
	' select facilitynum, count(*) ' +
	' from s' + convert(varchar,@intStudy_id) + '.encounter_load ' +
	' group by facilitynum '

exec (@strsql)

set @strsql = 'insert into #f22 ' +
	' select facilitynum, count(*) ' +
	' from s' + convert(varchar,@intStudy_id) + '.encounter ' +
	' where newrecorddate >= (select mindate from #time) ' +
	' group by facilitynum '

exec (@strsql)

update r
set rcvdrecordsweek = cnt1, goodrecordsweek = cnt2
from #report r, (select ('0'+convert(varchar,f1.facilitynum)) as facilitynum, cnt1, cnt2
from #f11 f1 left outer join #f22 f2
on f1.facilitynum = f2.facilitynum) a
where r.[facility number] = a.facilitynum

  end

declare @SamplesInPeriod int, @SamplesRun int, @SamplesLeft int

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
   AND S.datSampleCreate_dt between @newPeriod and dateadd(second,-1,@sampleset)
 SELECT @SamplesInPeriod = intSamplesInPeriod
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id
 SELECT @SamplesRun = COUNT(*)
  FROM #SampleSet_Period
 SELECT @SamplesLeft = @SamplesInPeriod - @SamplesRun
 IF @SamplesLeft < 1 
  SELECT @SamplesLeft = 1 
 INSERT INTO #SampleUnit_Temp (SampleUnit_id, SamplesLeft, TargetReturn_Period, ResponseRate, InitResponseRate)
  SELECT sp.SampleUnit_id, @SamplesLeft, [Qtr Goal], [Response Rate], numinitresponserate
   FROM #report SP, sampleunit su
	WHERE sp.sampleunit_id = su.sampleunit_id
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
	WHERE ResponseRate > 0
 UPDATE #SampleUnit_Sample
  SET NumToSend_SampleSet = ROUND(NumToSend_Period/SamplesLeft, 0)

 UPDATE #report
   set [should send]=NumToSend_SampleSet
  FROM #SampleUnit_Sample
  WHERE #report.SampleUnit_id=#SampleUnit_Sample.SampleUnit_id

 DROP TABLE #SampleUnit_Count
 DROP TABLE #SampleSet_Period
 DROP TABLE #SampleUnit_Temp
 DROP TABLE #SampleUnit_Sample

 update #report
   set [will send]=cnt
   from (select sampleunit_id, count(*) as cnt
         from selectedsample
         where sampleset_id=@intSampleSet_id
           and STRUNITSELECTTYPE='D'
         group by sampleunit_id) xx
   where xx.sampleunit_id=#report.sampleunit_id

update #report
set [will send] = 0
where [will send] is null

 update #report
   set variance = [should send]-[will send] 

update #report
set sentsurveysqtd = 0
where sentsurveysqtd is null

update #report
set RtrndSurveysQTD = 0 
where RtrndSurveysQTD is null

update #report
set RcvdRecordsWeek = 0
where RcvdRecordsWeek is null

update #report
set GoodRecordsWeek = 0
where GoodRecordsWeek is null

select * from #report

drop table #f1
drop table #f2
drop table #time
drop table #f11
drop table #f22
drop table #outgo
drop table #qtd
drop table #rr
drop table #report

set transaction isolation level read committed


