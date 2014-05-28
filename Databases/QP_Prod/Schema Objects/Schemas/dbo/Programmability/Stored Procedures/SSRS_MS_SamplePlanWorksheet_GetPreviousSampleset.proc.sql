CREATE proc SSRS_MS_SamplePlanWorksheet_GetPreviousSampleset    
@samplesets varchar(1000)  
as    
    
declare @survey_id int    
declare @sampleset_id int  
declare @sql varchar(4000)    

create table #tmp_sampleset (Sampleset_ID int)
  
set @sql = 'Insert into #tmp_sampleset select min(sampleset_id) as sampleset_id from sampleset where sampleset_id in (' + @samplesets + ')'  
exec(@sql)  
  
select @sampleset_id = sampleset_id from #tmp_sampleset  
  
select @survey_id = survey_id from sampleset     
where sampleset_id = @sampleset_id    
    
select top 1 * from sampleset     
where survey_id = @survey_id    
and sampleset_id < @sampleset_id    
order by datdaterange_fromdate desc  
  
drop table #tmp_sampleset


