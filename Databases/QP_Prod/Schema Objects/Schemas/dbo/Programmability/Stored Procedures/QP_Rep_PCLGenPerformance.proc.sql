CREATE procedure QP_Rep_PCLGenPerformance
  @LastNHours int
as
set transaction isolation level read uncommitted
select sentmail_id, max(datlogged) as start_dt, max(pclgenrun_id) as pclgenrun_id, max(pclgenlog_id) as pclgenlog_id
into #gentime
from pclgenlog 
where sentmail_id is not null
  and datediff(hour,datlogged,getdate()) <= @lastNhours
group by sentmail_id

select g.sentmail_id, g.start_dt, min(l.datlogged) as end_dt, g.pclgenrun_id, g.pclgenlog_id, min(l.pclgenlog_id) as pclgenlog_next
into #gentime2
from #gentime g, pclgenlog l
where g.pclgenrun_id=l.pclgenrun_id
 and l.pclgenlog_id>g.pclgenlog_id
group by g.sentmail_id, g.start_dt, g.pclgenrun_id, g.pclgenlog_id

select 
  pc.STRPAPERCONFIG_NM as [Paper Configuration],
  count(*) as Volume,
  min(convert(real,datediff(millisecond,g.start_dt,g.end_dt))/1000) as [Quickest (secs)],
  max(convert(real,datediff(millisecond,g.start_dt,g.end_dt))/1000) as [Slowest (secs)],
  avg(convert(real,datediff(millisecond,g.start_dt,g.end_dt))/1000) as [Average (secs)],
  stdev(convert(real,datediff(millisecond,g.start_dt,g.end_dt))/1000) as [Standard Dev]
from #gentime2 g, sentmailing sm, paperconfig pc
where sm.sentmail_id=g.sentmail_id and sm.paperconfig_id=pc.paperconfig_id
group by sm.paperconfig_id, pc.STRPAPERCONFIG_NM
order by strpaperconfig_nm

drop table #gentime
drop table #gentime2

set transaction isolation level read committed


