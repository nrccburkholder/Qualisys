CREATE procedure [dbo].[qp_rep_HCMGUsageByClient]
@startdate datetime, @enddate datetime, @HCMGYear varchar(4)
as

-- 07-12-2005 Modified SH
-- Changed NRC16 to Medusa
-- 02-05-2007 Modified RUFFIN
-- Changed Medusa to HCMG

select client_id,strSessionid,strUserID,min(datlog) as datStart, max(datLog) as datEnd
into #sessions
from HCMG.HCMG_dev.dbo.activitylog
where datLog between @StartDate and dateadd(day,1,@EndDate)
--and client_id > 2
group by client_id,strSessionid,strUserID

select c.client_id, c.client_nm, strUserID, sum(datediff(minute,datstart,datEnd)) as intTotalMinutes
into #clientusage
from HCMG.HCMG_dev.dbo.client c left outer join #sessions s on s.client_id=c.client_id,
HCMG.HCMG_dev.dbo.client_marketyear cmy
where c.client_id=cmy.client_id
and cmy.datyear=@HCMGYear
and c.client_id > 10
group by c.client_id, c.client_nm, strUserID
order by c.client_nm, strUserID

select cu.*, cuser.strCity, cuser.strState
from #clientusage cu left outer join HCMG.WebAccounts.dbo.clientuser cuser on cu.client_id=cuser.client_id and cu.strUserID=cuser.strLogin_nm
order by cu.client_nm

drop table #sessions
drop table #clientusage


