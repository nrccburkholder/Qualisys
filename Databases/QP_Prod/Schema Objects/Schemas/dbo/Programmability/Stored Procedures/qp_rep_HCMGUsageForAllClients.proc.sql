CREATE procedure [dbo].[qp_rep_HCMGUsageForAllClients]
@startdate datetime, @enddate datetime, @HCMGYear varchar(4)
as

select *, 0 as sessionNum into #activitylog
from HCMG.HCMG_dev.dbo.activitylog al1 
where datLog between @startdate and dateadd(day,1,@enddate) and client_id > 10 and client_id <> 1051
and client_id <> 1586

update #activitylog set sessionNum = (select count(*) from #activitylog al2 where al2.strSessionID = #activitylog.strsessionID and 
al2.datLog <= #activitylog.datlog and al2.strFunction = 'Login')

select client_id,strSessionid, sessionNum, strUserID,min(datlog) as datStart, max(datLog) as datEnd
into #sessions
from #activitylog
group by client_id,strSessionid, sessionNum, strUserID

--Kris wanted to add on 3 minutes because we don't know how long the user accessed the last table
select c_16.client_id, c_16.client_nm, sum(case when cu_31.intusertype = 4 then datediff(second,datstart,datEnd) + 180 else 0 end)/60 
as intTotalMinutes
into #clientusage
from (HCMG.HCMG_dev.dbo.client as c_16 left join (#sessions s left join HCMG.WebAccounts.dbo.clientuser as cu_31 
on s.client_id = cu_31.client_id and s.strUserID = cu_31.strLogin_Nm and cu_31.datCreation <= datStart and 
(cu_31.datRetired is null or cu_31.datRetired >= datEnd)) on c_16.client_id = s.client_id), 
HCMG.HCMG_dev.dbo.client_marketyear cmy
where c_16.client_id = cmy.client_id and cmy.datYear = @HCMGYear and c_16.client_id > 10 and c_16.client_id <> 1051 
and c_16.client_id <> 1586
group by c_16.client_id, c_16.client_nm

select cu.client_id, cu.client_nm as Client_Name, (Select top 1 cu_16.strState from HCMG.HCMG_dev.dbo.client_user cu_16 where 
cu_16.client_id = cu.client_id) as State, cu.intTotalMinutes as TotalMinutes
from #clientusage cu

drop table #sessions
drop table #activitylog
drop table #clientusage


