CREATE PROCEDURE SP_RespRateCountorig
AS

truncate table RespRateCount

declare @datLastExtract datetime
select @datLastExtract=dwrundate from dw_date where qpc_timestamp=(select max(qpc_timestamp) from dw_date)

create table #SelSampUnit 
(survey_id int, sampleset_id int, sampleunit_id int, samplepop_id int, tiUD tinyint, tiReturned tinyint)

insert into #SelSampUnit (survey_id, sampleset_id, sampleunit_id, samplepop_id, tiUD, tiReturned)
  select qf.survey_id, ss.sampleset_id, ss.sampleunit_id, sp.samplepop_id, 0, 0
  from SelectedSample SS, samplepop sp, questionform qf, sentmailing sm
  where ss.sampleset_id=sp.sampleset_id
    and ss.pop_id=sp.pop_id
    and ss.strUnitSelectType='D'
    and sp.samplepop_id=qf.samplepop_id
    and qf.sentmail_id=sm.sentmail_id
    and sm.datmailed is not null

update #SelSampUnit
set tiReturned=1
from QuestionForm QF
where #SelSampUnit.Samplepop_id=QF.samplepop_id
  and isnull(QF.datreturned,getdate()) < @datlastextract

update #SelSampUnit
set tiUD=1
from SentMailing sm, ScheduledMailing sc
where #SelSampUnit.tiReturned=0 
  and #SelSampUnit.Samplepop_id=SC.samplepop_id
  and SC.sentmail_id=SM.sentmail_id 
  and isnull(sm.datundeliverable,getdate()) < @datlastextract
  
insert into RespRateCount (survey_id, sampleset_id, sampleunit_id,intSampled,intUD,intReturned)
  select survey_id,sampleset_id,sampleunit_id,count(*),sum(tiUD),sum(tiReturned)
  from #SelSampUnit
  group by survey_id,sampleset_id,sampleunit_id

select distinct survey_id, sampleset_id, samplepop_id, tiUD, tiReturned 
into #SelSampPop
from #SelSampUnit

insert into RespRateCount (survey_id, sampleset_id, sampleunit_id,intSampled,intUD,intReturned)
  select survey_id,sampleset_id,0,count(*),sum(tiUD),sum(tiReturned)
  from #SelSampPop
  group by survey_id,sampleset_id

drop table #SelSampUnit
drop table #SelSampPop


