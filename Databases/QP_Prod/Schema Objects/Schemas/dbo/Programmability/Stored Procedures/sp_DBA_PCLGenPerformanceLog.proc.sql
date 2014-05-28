CREATE PROCEDURE sp_DBA_PCLGenPerformanceLog
AS
declare @beg datetime, @end datetime
--set @beg = CONVERT(DATETIME,CONVERT(VARCHAR,DATEADD(dd,-14,GETDATE()),101))
set @beg = CONVERT(DATETIME,CONVERT(VARCHAR,DATEADD(dd,-1,GETDATE()),101))
set @beg = @beg + '19:00'
set @end = dateadd(hh,9,@beg)

select r.pclgenrun_id, computer_nm, min(start_dt) batchstart_dt, datediff (ss,min(start_dt),max(end_dt)) ElapsedTime, count(distinct sentmail_id) svycnt, datediff (ss,min(start_dt),max(end_dt))/(count(distinct sentmail_id)+0.0) Seconds_per_Survey
into #temp 
from pclgenlog l (nolock), pclgenrun r (Nolock) where r.pclgenrun_Id = l.pclgenrun_id
and r.start_dt >= @BEG
and computer_nm not like 'tp%'
and sentmail_id is not null
group by r.pclgenrun_id, computer_nm
order by datediff (ss,min(start_dt),max(end_dt)) asc

INSERT INTO PCLGenPerformanceLog (PCLGenRun_id, GenDate, Computer_nm, BatchStart_dt, TotalCnt, Avg_Sec_Per_Svy)
select PCLGenRun_id, 
CASE WHEN DATEPART(hh,BatchStart_dt) BETWEEN 19 AND 24  THEN CONVERT(varchar,BatchStart_dt,101) ELSE CONVERT(varchar,DATEADD(dd,-1,BatchStart_dt),101) end AS GenDate, computer_nm, 
BatchStart_dt, sum(svycnt) totalcnt, avg(seconds_per_survey) avg_sec_per_svy  from #temp T
where seconds_per_survey is not null 
and  not exists (select * from pclgenperformancelog p where t.pclgenrun_id = p.pclgenrun_id)
group by CASE WHEN DATEPART(hh,BatchStart_dt) BETWEEN 19 AND 24  THEN CONVERT(varchar,BatchStart_dt,101) ELSE CONVERT(varchar,DATEADD(dd,-1,BatchStart_dt),101) end, computer_nm, PCLGenRun_id, BatchStart_dt 
order by 4 

drop table #temp


