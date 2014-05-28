CREATE procedure APlan_PrepOther
  @rootunit_id int, @ThisOne int=0, @Other1 int=0, @other2 int=0, @other3 int=0, @other4 int=0, @other5 int=0, @other6 int=0, @other7 int=0, @other8 int=0
as
exec APlan_Aggregate

select u.sampunit, u.qstncore, qr.response, 0 as cnt, qr.bitMeanable 
into #aggbyUnit
from (select distinct sampunit,qstncore from #agg where response>-8) u,
     (select distinct qstncore,response,bitmeanable from #agg) qr
where u.qstncore=qr.qstncore 

update bu
  set cnt = a.cnt
  from #aggbyunit bu, #agg a
  where bu.sampunit=a.sampunit
    and bu.qstncore=a.qstncore
    and bu.response=a.response

truncate table #agg
insert into #agg
  select 1,qstncore,response,sum(cnt),convert(int,bitMeanable)
  from #aggbyunit 
  group by qstncore,response,convert(int,bitMeanable)

update bu
  set cnt = a.cnt-bu.cnt
  from #aggbyunit bu, #agg a
  where bu.qstncore=a.qstncore
    and bu.response=a.response

truncate table #mrd
truncate table #agg 
if @ThisOne > 0 
begin
  if @other1>0 
    exec APlan_LoadOther @ThisOne, @other1
  if @other2>0 
    exec APlan_LoadOther @ThisOne, @other2
  if @other3>0 
    exec APlan_LoadOther @ThisOne, @other3
  if @other4>0 
    exec APlan_LoadOther @ThisOne, @other4
  if @other5>0 
    exec APlan_LoadOther @ThisOne, @other5
  if @other6>0 
    exec APlan_LoadOther @ThisOne, @other6
  if @other7>0 
    exec APlan_LoadOther @ThisOne, @other7
  if @other8>0 
    exec APlan_LoadOther @ThisOne, @other8

  -- select distinct sampunit,strsampleunit_nm 
  -- from #mrd m, sampleunit su
  -- where sampunit=sampleunit_id
 
  update M 
    set Sampunit=su.parentsampleunit_id
    from #mrd M, sampleunit su, sampleunit pu
    where m.sampunit=su.sampleunit_id
      and su.parentsampleunit_id=pu.sampleunit_id
      and pu.parentsampleunit_id is not null

  update #mrd
    set SampUnit=UnitTo
    from #UnitRecode
    where sampunit=unitfrom

  exec APlan_Aggregate
end

insert into #agg select * from #aggbyunit where cnt>0

delete from #agg where qstncore in (100001,100002)


