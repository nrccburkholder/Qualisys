CREATE PROCEDURE [dbo].[QP_REP_RollbackCounts]  
 @BeginDate DATETIME,   
 @EndDate DATETIME  
AS  
  
SELECT @EndDate=@EndDate+'23:59:59'  
select Distinct Study_id, Survey_id, Year(datRollback_dt) as nYear,  Month(datRollback_dt) as nMonth,  
 Day(datRollback_dt) as nDay, RollbackType, cnt  
into #Rollbacks  
from Rollbacks   
where datRollback_dt >= @BeginDate and datRollback_dt <= @EndDate  
order by Study_id, Survey_id,Rollbacktype  
  
select DISTINCT Survey_id, Year(datRollback_Start) as nYear,  Month(datRollback_Start) as nMonth,  
 Day(datRollback_Start) as nDay  
into #GRollbacks  
from Generation_Rollbacks   
Where datRollback_start >= @BeginDate and datRollback_start <= @EndDate  
order by Survey_id  
  
select RollbackType, count(*) as Counts into #Out from #Rollbacks   
group by Rollbacktype  
order by Rollbacktype  
  
Insert #Out select 'Generation', count(*) from #GRollbacks   
  
Select RollbackType, Sum(Counts) as [Count] from #out GROUP BY RollbackType
  
Drop table #Rollbacks  
Drop table #GRollbacks  
Drop table #out


