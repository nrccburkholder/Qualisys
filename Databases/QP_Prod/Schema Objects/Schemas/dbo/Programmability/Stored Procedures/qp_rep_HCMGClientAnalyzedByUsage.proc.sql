CREATE procedure [dbo].[qp_rep_HCMGClientAnalyzedByUsage]
@startdate datetime, @enddate datetime, @HCMGYear varchar(4)
as

-- Modified 07-12-2005 SH
-- Changed NRC16 to Medusa
-- Modified 02-05-2007 RUFFIN
-- Change Medusa to HCMG  (LINKED SERVER ALIAS FOR SERVER HOSTING HCMGDATABASES)

select count(*) as intTotalTimesAccessed, crossing_id into #CountCrossings from HCMG.HCMG_dev.dbo.activitylog al, 
HCMG.WebAccounts.dbo.clientuser cu
where datLog between @StartDate and dateadd(day,1,@EndDate) and al.client_id > 10 and al.client_id <> 1051 and 
al.client_id <> 1586 and datLog between cu.datCreation and IsNull(cu.datRetired, getdate())
 and cu.strLogin_Nm = al.strUserID and cu.client_id = al.client_id and cu.intUserType = 4
 group by crossing_id 

select cv.crossing_id, sg.strGroup_nm as strQuestion, bg.strGroup_Nm as strAnalyzeBy into #QuestionAnalyzedBy 
from ((HCMG.HCMG_dev.dbo.crossing_view cv left join HCMG.HCMG_dev.dbo.fieldgroup sg on cv.stubgroup_id = sg.fieldgroup_id) left join 
HCMG.HCMG_dev.dbo.fieldgroup bg on cv.bannergroup_id = bg.fieldgroup_id) 
where sg.fieldgroup_id in (select distinct stubGroup_id from 
HCMG.HCMG_dev.dbo.stub s left join HCMG.HCMG_dev.dbo.booksection b on s.booksection_id = b.booksection_id where b.datYear = @HCMGYear)

select QAB.strQuestion, QAB.strAnalyzeBy, CC.crossing_id, CC.intTotalTimesAccessed from #CountCrossings CC inner join 
#QuestionAnalyzedBy QAB on CC.crossing_id = QAB.crossing_id order by QAB.crossing_id

drop table #CountCrossings
drop table #QuestionAnalyzedBy


