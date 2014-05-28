--Update on 01/24/2013 by Santosh Doodi: Updated the Dataset field with nvarchar
CREATE procedure [dbo].[SSRS_MS_SamplePlanWorksheetAll]                    
 @samplesets nvarchar(max),                    
 @AggType int                    
                    
as                    
 set ANSI_WARNINGS OFF
 
 --declare @samplesets nvarchar(max),@AggType int 
 --select @samplesets = '939049'
 --select @AggType = 1
 
--add info to log table          
insert SSRS_MS_SamplePlanWorksheetAll_Log select getdate(), 'aggtype=' + cast(@aggtype as varchar) + '; samplesets=' + @samplesets          
                    
--exec SSRS_MS_SamplePlanWorksheetAll '2,3,4,13,14',1                    
--if object_id('tempdb..#all') is not null drop table #all                    
--declare @samplesets varchar(1000),@AggType int                    
--set @samplesets='2,3,4,13,14' set @AggType=1                    
                    
set transaction isolation level read uncommitted                    
                    
create table #all (Part varchar(20),                    
       --title                    
       sampleset_id int,datSampleCreate_dt datetime,PeriodDateRange varchar(50),SelectedDateRange varchar(50),                    
       SampledDateRange varchar(50),EncounterDateField varchar(50),Datasets nvarchar(max),SamplingType varchar(30),                    
       SamplingAlgorithm varchar(20),                    
       SAP int,SIP int,SLP int,                    
       --spw                     
       sampleunit_id int,Tier int,TreeOrder int,strSampleUnit_nm varchar(50),PRT int,DRR int,HRR float,TPO int,                    
       APON float,ONTS int,STS int,D int,Avail int,ISTS int,TotalDQ int,HCAHPSSampled int,                    
       --DQs                     
          DQ varchar(20),DQOrd int,N int,        
    --previous period        
    previousrange varchar(50))                    
                    
--get title                   
print 'Get Title'             
insert #all (Part,sampleset_id,datSampleCreate_dt,PeriodDateRange,SelectedDateRange,SampledDateRange,EncounterDateField,Datasets,                    
   SamplingType,SamplingAlgorithm,SAP,SIP,SLP)                     
exec ssrs_ms_sampleplanworksheettitle @samplesets,@AggType                    
                    
--get SPW               
print 'Get SPW'                 
insert #all (Part,sampleset_id,sampleunit_id,Tier,TreeOrder,strSampleUnit_nm,PRT,DRR,HRR,TPO,APON,ONTS,ISTS,STS,D,Avail,TotalDQ,HCAHPSSampled)                    
exec ssrs_ms_sampleplanworksheet @samplesets,@AggType                    
                    
--get DQs                
print 'Get DQs'                
insert #all (Part,sampleset_id,strSampleUnit_nm,Tier,TreeOrder,SampleUnit_id,DQ,DQOrd,N)                    
exec ssrs_MS_SamplePlanWorksheetDQ @samplesets,@AggType           
        
        
--previous selected date range        
declare @survey_id int            
declare @sampleset_id int          
declare @sql nvarchar(max)            
declare @previous nvarchar(max)        
    
create table #tmp_sampleset (Sampleset_ID int)    
          
set @sql = 'Insert into #tmp_sampleset select min(sampleset_id) as sampleset_id from sampleset where sampleset_id in (' + @samplesets + ')'          
exec(@sql)          
          
select @sampleset_id = sampleset_id from #tmp_sampleset          
          
select @survey_id = survey_id from sampleset             
where sampleset_id = @sampleset_id            
        
select @previous =        
(select top 1 convert(varchar, datdaterange_fromdate, 101) + ' - ' + convert(varchar, datdaterange_todate, 101)        
from sampleset             
where survey_id = @survey_id            
and sampleset_id < @sampleset_id            
order by datdaterange_fromdate desc)        
          
drop table #tmp_sampleset        
        
update #all set previousrange = @previous where part = 'title'        
        
                    
print 'select from #all'            
select * from #all order by sampleset_id                  
                    
set transaction isolation level read committed                    
                    
drop table #all


