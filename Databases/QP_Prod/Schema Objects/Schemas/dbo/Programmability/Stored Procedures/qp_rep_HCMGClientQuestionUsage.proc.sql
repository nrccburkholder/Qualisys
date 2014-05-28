CREATE procedure [dbo].[qp_rep_HCMGClientQuestionUsage]
@startdate datetime, @enddate datetime, @HCMGYear varchar(4)
as

-- Modified 07-12-2005 SH
-- Changed NRC16 to Medusa
-- Modified 02-05-2007
-- Changed Medusa to VUCLAN


select count(*) as intTotalTimesAccessed, crossing_id into #CountCrossings from HCMG.HCMG_dev.dbo.activitylog al, 
HCMG.WebAccounts.dbo.clientuser cu
where datLog between @StartDate and dateadd(day,1,@EndDate) and al.client_id > 10 and al.client_id <> 1051 and 
al.client_id <> 1586 and datLog between cu.datCreation and IsNull(cu.datRetired, getdate())
 and cu.strLogin_Nm = al.strUserID and cu.client_id = al.client_id and cu.intUserType = 4
 group by crossing_id 

select cv.crossing_id, sg.strGroup_nm as strQuestion into #Questions
from HCMG.HCMG_dev.dbo.crossing_view cv left join HCMG.HCMG_dev.dbo.fieldgroup sg on cv.stubgroup_id = sg.fieldgroup_id 
where sg.fieldgroup_id in (select distinct stubGroup_id from 
HCMG.HCMG_dev.dbo.stub s left join HCMG.HCMG_dev.dbo.booksection b on s.booksection_id = b.booksection_id where b.datYear = @HCMGYear)

select Q.strQuestion, sum(IsNull(CC.intTotalTimesAccessed,0)) as intTotalTimesAccessed from #Questions Q left join 
#CountCrossings CC on Q.crossing_id = CC.crossing_id group by Q.strQuestion order by Q.strQuestion

drop table #CountCrossings
drop table #Questions


