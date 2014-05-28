create procedure dbo.qp_rep_ProjectUpdateStatus
@FirstWeek datetime, @LastWeek datetime
as

if @FirstWeek < '3/14/2004'
  set @FirstWeek='3/14/2004'

while datepart(weekday,@FirstWeek) <> 1
  set @FirstWeek = dateadd(day,-1,@FirstWeek) 

while datepart(weekday,@LastWeek) <> 7
  set @LastWeek = dateadd(day,1,@LastWeek) 

SELECT tm.TeamName,
       cl.strClient_NM,
       pl.pu_id, pl.PuName,
       convert(smalldatetime,convert(varchar,dd.DueDate,101)) as DueDate,
       convert(smalldatetime,convert(varchar,rp.DatePosted,101)) as DatePosted,
       mc.MailToClient
into #report
  FROM WorkFlow.dbo.PU_Plan pl,
       WorkFlow.dbo.Team tm,
       Client cl,
       Workflow.dbo.PU_DueDate_View dd
       LEFT JOIN Workflow.dbo.PUR_Report rp
         ON dd.PU_ID = rp.PU_ID
            AND dd.DueDate = rp.DueDate
       LEFT JOIN (          -- Find updates have mail address outside the NRC
            SELECT PUReport_ID,
                   1 AS MailToClient
              FROM Workflow.dbo.PUR_Addressee
             WHERE AddrType = 1
               AND Email NOT LIKE '%@NationalResearch.com'
               AND Email NOT LIKE '%PickerGroup.com'
               AND Email NOT LIKE '%@SmallerWorld.org'
             GROUP BY PUReport_ID
            ) mc
         ON rp.PUReport_ID = mc.PUReport_ID
 WHERE pl.Team_ID <> 999
   AND pl.Status = 0
   AND tm.Team_ID = pl.Team_ID
   AND cl.Client_ID = pl.Client_ID
   AND dd.PU_ID = pl.PU_ID
   AND dd.DueDate BETWEEN @FirstWeek
                      AND dateadd(minute,(60*24)-1,@LastWeek)
 ORDER BY 
       tm.TeamName,
       cl.strClient_NM,
       pl.PuName

update #report set PuName = replace(puName,'Client','')
update #report set PuName = replace(puName,'Update','')
update #report set PuName = replace(puName,'patient satisfaction','')
update #report set PuName = replace(puName,'project','')
update #report set PuName = replace(puName,'satisfaction','')
update #report set PuName = replace(puName,'Weekly','')
update #report set PuName = replace(puName,'Study','')
update #report set PuName = ltrim(rtrim(replace(puName,ltrim(rtrim(strClient_nm)),'')))

update #report set puname = replace(puname,'  ',' ') where puname like '%  %'
while @@rowcount>0
   update #report set puname = replace(puname,'  ',' ') where puname like '%  %'

update #report set puname = substring(puname, 3, len(puname)) where puname like '- %'
update #report set puname = substring(puname, 2, len(puname)) where puname like '-%'
update #report set puname = left(puname,len(puname)-2) where puname like '% -'
update #report set puname = left(puname,len(puname)-2) where puname like '%-'

update #report set puname = strclient_nm where rtrim(puname)='' or rtrim(puname)='-'

update #report set DueDate = dateadd(day,-1,DueDate) where datepart(weekday,duedate) <> 1
while @@rowcount>0
   update #report set DueDate = dateadd(day,-1,DueDate) where datepart(weekday,duedate) <> 1

update #report set dateposted = dateadd(day,-1,dateposted) where datepart(weekday,dateposted) <> 1
while @@rowcount>0
   update #report set dateposted = dateadd(day,-1,dateposted) where datepart(weekday,dateposted) <> 1

update #report set dateposted=null where dateposted>duedate or (mailtoclient is null and dateposted is not null)

select TeamName as Team, strClient_NM as Client, PuName as [Update], DueDate as [Week Due],
  case when min(datePosted) is null then 0 else 1 end as [Posted On Time]
from #report
group by TeamName, strClient_NM, pu_id, PuName, DueDate
ORDER BY TeamName, strClient_NM, PuName, DueDate

drop table #report


