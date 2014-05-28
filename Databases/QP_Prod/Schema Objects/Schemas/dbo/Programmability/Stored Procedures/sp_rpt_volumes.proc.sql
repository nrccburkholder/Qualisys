create procedure sp_rpt_volumes
 @Survey_id int
as
 set nocount on
 create table #mysu (sampleunit_id int, level_id int)
 create table #mysup (sampleunit_id int, level_id int)
 create table #mysp (sampleunit_id int, samplepop_id int, level_id int)
 create table #myrpt (sampleunit_id int, level_id int, outgo int, nondel int, returns int)
 
 insert into #mysu (sampleunit_id, level_id)
 select distinct sampleunit_id, 1
 from SampleUnit SU, SamplePlan SP
 where SU.PARENTSAMPLEUNIT_ID is null 
 and SU.SamplePlan_id = SP.SamplePlan_id
 and SP.Survey_id = @Survey_id
 WHILE @@ROWCOUNT > 0
 begin
  truncate table #mysp
  insert into #mysp (sampleunit_id, samplepop_id, level_id)
  select SS.sampleunit_id, SM.samplepop_id, SU.level_id
  from #mysu SU, SelectedSample SS, SamplePop SM
  where SS.sampleunit_id = SU.sampleunit_id
  and SS.sampleset_id = SM.sampleset_id
  and SS.study_id = SM.study_id
  and SS.pop_id = SM.pop_id
  if @@ROWCOUNT > 0
  begin
 /* Total OutGo & Returned */
   insert into #myrpt (sampleunit_id, level_id, outgo, nondel, returns)
   select SP.Sampleunit_id, SP.level_id, count(*), 0, Sum(case when QF.Datreturned is not null then 1 else 0 end)
   from #mysp SP, QuestionForm QF
   where SP.samplepop_id = QF.samplepop_id
   group by SP.sampleunit_id, SP.level_id
  
   insert into #myrpt (sampleunit_id, level_id, outgo, nondel, returns)
   select SP.sampleunit_id, SP.level_id, 0, count(*), 0
   from #mysp SP, QuestionForm QF, SentMailing SM
   where QF.SentMail_id = SM.SentMail_id
   and SM.Datundeliverable is not null
   and SP.SamplePop_id = QF.SamplePop_id 
   group by SP.sampleunit_id, SP.level_id
  end
 
  truncate table #mysup
  insert into #mysup (sampleunit_id, level_id) select sampleunit_id, level_id from #mysu
  truncate table #mysu
  insert into #mysu (sampleunit_id, level_id)
  select distinct SU.sampleunit_id, sup.level_id + 1 
  from SampleUnit SU, #mysup sup
  where SU.PARENTSAMPLEUNIT_ID = sup.sampleunit_id
 end
 set nocount off
 
 select SU.strSampleUnit_nm, mr.Sampleunit_id, mr.level_id, 
  SUM(mr.outgo) as outgo, SUM(mr.nondel) as nondel, SUM(mr.returns) as returns
 from #myrpt mr, SampleUnit SU
 where mr.sampleunit_id = SU.sampleunit_id
 group by SU.strSampleUnit_nm, mr.Sampleunit_id, mr.level_id
 order by mr.level_id, mr.Sampleunit_id, SU.strSampleUnit_nm
 drop table #mysu
 drop table #mysup
 drop table #mysp
 drop table #myrpt


