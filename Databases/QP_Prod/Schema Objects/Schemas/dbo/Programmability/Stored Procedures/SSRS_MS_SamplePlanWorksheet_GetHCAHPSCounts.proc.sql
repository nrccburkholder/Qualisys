CREATE proc SSRS_MS_SamplePlanWorksheet_GetHCAHPSCounts  
@samplesets varchar(1000)    
as    
    
declare @sampleplan_id int    
declare @sampleunit_id int  
declare @survey_id int  
declare @sampleset_id int  
declare @sql varchar(4000)      


create table #tmp (  
 sampleset_id int,  
 datDateRange_FromDate datetime,  
 datDateRange_ToDate datetime,  
 STS int  
)  
  
create table #tmp_sampleset (Sampleset_ID int)
  
set @sql = 'Insert into #tmp_sampleset select min(sampleset_id) as sampleset_id from sampleset where sampleset_id in (' + @samplesets + ')'    
exec(@sql)    
    
select @sampleset_id = sampleset_id from #tmp_sampleset   
  
select @sampleplan_id = sampleplan_id, @survey_id = survey_id from sampleset where sampleset_id = @sampleset_id  
select @sampleunit_id = sampleunit_id from sampleunit where sampleplan_id = @sampleplan_id and bithcahps = 1  
  
insert into #tmp (sampleset_id, datdaterange_fromdate, datdaterange_todate)    
select top 4 sampleset_id,datdaterange_fromdate, datdaterange_todate from sampleset     
where survey_id = @survey_id    
and sampleset_id < @sampleset_id    
order by datdaterange_fromdate desc  
  
update t  
set sts = isnull(intsamplednow,0)  
from #tmp t inner join sampleplanworksheet spw  
 on t.sampleset_id = spw.sampleset_id  
where sampleunit_id = @sampleunit_id  
  
select * from #tmp  
  
drop table #tmp  
/*  
select top 4 sampleset_id, isnull(intsamplednow,0) as STS  
from sampleplanworksheet  
where sampleunit_id = @sampleunit_id  
and sampleset_id < @sampleset_id  
order by sampleset_id desc  
*/  
drop table #tmp_sampleset


