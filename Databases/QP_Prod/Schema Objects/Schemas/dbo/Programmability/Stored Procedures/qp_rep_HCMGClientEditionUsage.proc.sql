CREATE procedure [dbo].[qp_rep_HCMGClientEditionUsage]
@startdate datetime, @enddate datetime, @HCMGYear varchar(4)
as

-- Modified 07-12-2005 SH
-- Chamged NRC16 to Medusa
-- Modified 02-05-2007 RUFFIN
-- Changed Medusa to HCMG

create table #sessions
(client_id int, strSessionid char(25), sessionnum int, strUserID varchar(20), datStart dateTime, datEnd dateTime, datTrend dateTime)

--This stored procedure was created on HCMG because the subquery does not compile on NRC10, but it does on HCMG.
insert into #sessions
 exec HCMG.HCMG_Dev.dbo.qp_rep_HCMG16ClientEditionUse @startdate, @enddate, @HCMGYear

--datTrend is only a valid trending date if it is on or after datStart and before datEnd.
--note the /60 will truncate and not round from the second to the minute
--Don't include the power user minutes, but want to include all clients with rights to that edition
--note when trending is turned on the times logged for each of the years may be different by 2 or 3 seconds
--because we don't know how long a user spent on the last table they viewed (datEnd is null)we are estimating 180 seconds (3 mins).
--a client must be on HCMG in the client table to exist as a HCMG client in this procedure
select c_16.client_id, c_16.client_nm, sum(case when cu_31.intusertype is null or cu_31.intusertype <> 4 then 0 else 
IsNull(datediff(second,datstart,datEnd), 180) end) / 60 
as intTotalMinutes, sum(case when cu_31.intusertype is null or cu_31.intusertype <> 4 or datTrend >= datEnd or datTrend is null
 then 0 else IsNull(datediff(second,datTrend,datEnd), 180) end) / 60 as intTotalTrendMinutes
into #clientusage
from (HCMG.HCMG_dev.dbo.client as c_16 left join (#sessions s left join HCMG.WebAccounts.dbo.clientuser as cu_31 
on s.client_id = cu_31.client_id and s.strUserID = cu_31.strLogin_Nm and cu_31.datCreation <= datStart and 
(cu_31.datRetired is null or cu_31.datRetired >= datEnd)) on c_16.client_id = s.client_id), 
HCMG.HCMG_dev.dbo.client_marketyear cmy
where c_16.client_id = cmy.client_id and cmy.datYear = @HCMGYear and c_16.client_id > 10 and c_16.client_id <> 1051 
and c_16.client_id <> 1586 
group by c_16.client_id, c_16.client_nm
order by c_16.client_nm

select cu.client_id, cu.client_nm as Client_Name, (Select top 1 cu_16.strState from HCMG.HCMG_dev.dbo.client_user cu_16 where 
cu_16.client_id = cu.client_id) as State, cu.intTotalMinutes as TotalMinutes, 
cu.intTotalTrendMinutes as TotalTrendMinutes 
from #clientusage cu


drop table #sessions
drop table #clientusage


