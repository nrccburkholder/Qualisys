--DRM 9/27/2011 Added check for positive pop_id values (i.e. rows that weren't seed mailing receivers)    
--DRM 4/19/2013 Increased size of @samplesets and @sql
CREATE procedure [dbo].[SSRS_MS_SamplePlanWorksheet]          
 @samplesets varchar(8000),          
 @AggType int          
          
as          
          
--exec ssrs_ms_sampleplanworksheet '2,3,4,13,14',1          
--/***/if object_id('tempdb..#samplesets') is not null drop table #samplesets          
--/***/if object_id('tempdb..#spw') is not null drop table #spw          
--/***/if object_id('tempdb..#sampleunittree') is not null drop table #sampleunittree          
--/***/if object_id('tempdb..#sampleunits') is not null drop table #sampleunits          
--/***/if object_id('tempdb..#sampleplans') is not null drop table #sampleplans          
--/***/if object_id('tempdb..#dqs') is not null drop table #dqs          
--/***/declare @samplesets varchar(200),@AggType int          
--/***/set @samplesets='2,3,4,13,14' set @AggType=2 --1=Sampleset,2=Overall          
          
set nocount on          
          
set transaction isolation level read uncommitted            
          
/********Temp Table Definition End ***************************************************/          
create table #samplesets (survey_id int,sampleset_id int)          
          
create table #spw          
 (sampleset_id int,sampleunit_id int,Tier int,TreeOrder int,strSampleUnit_nm varchar(60),PRT int,DRR int,HRR float,TPO int,          
 APON float,ONTS int,STS int,D int,Avail int,ISTS int,TotalDQ int,HCAHPSSampled int)          
          
create table #sampleplans (sampleplan_id int,Done bit)          
          
create table #SampleUnitTree (sampleplan_id int,sampleunit_id int,strSampleUnit_nm varchar(255),Tier int,TreeOrder int)          
          
create table #SampleUnits (sampleplan_id int,sampleunit_id int,strSampleUnit_nm varchar(255),intTier int,intTreeOrder int)          
          
create table #dqs (sampleset_id int,sampleunit_id int,cnt int)          
/********Temp Table Definition End ***************************************************/          
          
print 'all tables created'      
      
declare @sql varchar(8000)          
          
set @sql=          
'insert #samplesets (survey_id,sampleset_id)'+char(10)+          
'select survey_id,sampleset_id'+char(10)+          
'from sampleset'+char(10)+          
'where sampleset_id in ('+@samplesets+')'+char(10)          
        
print @sql       
exec (@sql)          


--DRM 9/27/2011 Added check for positive pop_id values (i.e. rows that weren't seed mailing receivers)
--populate first part of SPW        
  print 'populate first part of SPW  '      
insert #spw (sampleset_id,TreeOrder,strSampleUnit_nm,STS)          
select sp.sampleset_id,0,'Total Individuals Sampled',count(*)          
from samplepop sp          
 inner join #samplesets sst          
  on (sp.sampleset_id=sst.sampleset_id)          
where pop_id > 0       
group by sp.sampleset_id          

          
--populate sampleunit tree by sampleplan       
print 'populate sampleunit tree by sampleplan '         
insert #sampleplans (sampleplan_id,Done)          
select distinct ss.sampleplan_id,0          
from sampleset ss          
 inner join #samplesets sst          
  on (ss.sampleset_id=sst.sampleset_id)          
          
declare @sampleplan_id int          
          
select top 1 @sampleplan_id=sampleplan_id          
from #sampleplans          
where Done=0          
          
while @@rowcount>0          
          
begin --begin sutree loop          
          
truncate table #sampleunits          
          
print 'sp_SampleUnits'      
exec sp_SampleUnits @sampleplan_id          
        
print 'insert #sampleunittree'        
insert #sampleunittree (sampleplan_id,sampleunit_id,strSampleUnit_nm,Tier,TreeOrder)          
select @sampleplan_id,sampleunit_id,strSampleUnit_nm,intTier,intTreeOrder          
from #sampleunits          
          
update #sampleplans          
set Done=1          
where sampleplan_id=@sampleplan_id          
          
select top 1 @sampleplan_id=sampleplan_id          
from #sampleplans          
where Done=0          
          
end --end sutree loop          
          
print 'insert #spw '      
--insert sampleunit trees into SPW table          
insert #spw (sampleset_id,sampleunit_id,Tier,TreeOrder,strSampleUnit_nm,PRT,DRR,HRR,TPO,APON,ONTS,STS,D,Avail,ISTS,          
   TotalDQ,HCAHPSSampled)          
select sst.sampleset_id,sut.sampleunit_id,sut.Tier,sut.TreeOrder,          
    case   
 when bitHCAHPS=1 then '(H) '+ su.strSampleUnit_nm   
 when bitHHCAHPS=1 then '(HH) '+ su.strSampleUnit_nm   
 when bitMNCM=1 then '(MN) '+ su.strSampleUnit_nm   
 else su.strSampleUnit_nm end,        
 0,0,0,0,0,0,0,0,0,0,0,0          
from #samplesets sst          
 inner join sampleset ss          
  on (sst.sampleset_id=ss.sampleset_id)          
 inner join #sampleunittree sut          
  on (sut.sampleplan_id=ss.sampleplan_id)          
 inner join sampleunit su          
  on (sut.sampleunit_id=su.sampleunit_id)          
          
--calculate total DQs and update SPW table        
print 'insert #dqs '        
insert #dqs (sampleset_id,sampleunit_id,cnt)          
select dq.sampleset_id,dq.sampleunit_id,sum(N)          
from spwdqcounts dq          
 inner join #samplesets sst          
  on (dq.sampleset_id=sst.sampleset_id)          
--where dq.dq in ('DQ_AGE','DQ_AddEr') --this is a clause used in the old version of the SPW, not on the expanded one          
group by dq.sampleset_id,dq.sampleunit_id          
          
print 'after insert #dqs '    
    
update spw          
set TotalDQ=dq.cnt          
from #spw spw          
 inner join #dqs dq          
  on (spw.sampleset_id=dq.sampleset_id and spw.sampleunit_id=dq.sampleunit_id)          
          
print 'update SPW values'    
--update SPW with other values          
update spw          
set PRT=intPeriodReturnTarget,          
 DRR=numDefaultResponseRate,          
 HRR=numHistoricResponseRate,          
 TPO=intTotalPriorPeriodOutgo,          
 APON=case when numAdditionalPeriodOutgoNeeded<0 then 0 else numAdditionalPeriodOutgoNeeded end,          
 ONTS=case when intOutgoNeededNow<0 then 0 else intOutgoNeededNow end,          
 ISTS=isnull(intInDirectSampledNow,0),          
 STS=isnull(intSampledNow,0),          
 D=case when intShortfall<0 or intOutgoNeededNow<0 then 0 when intShortfall is null then intOutgoNeededNow else intShortfall end,          
 Avail=isnull(intAvailableUniverse,0),          
 HCAHPSSampled=HcahpsDirectSampledCount           
from #spw spw          
 inner join sampleplanworksheet spw1          
  on (spw.sampleset_id=spw1.sampleset_id and spw.sampleunit_id=spw1.sampleunit_id)          
           
if @AggType=1          
begin --begin AggType=1 loop          
          
print 'AggType 1'    
select 'SPW',sampleset_id,sampleunit_id,tier,TreeOrder,strSampleUnit_nm,PRT,DRR,HRR,TPO,          
  str(APON,10,2) APON,ONTS,ISTS,STS,D,Avail,TotalDQ,HCAHPSSampled          
from #spw          
order by sampleset_id,TreeOrder          
          
end --end AggType=1 loop          
          
else if @AggType=2          
begin --begin AggType=2 loop          
         
print 'agg Type 2'    
select 'SPW',-1,sampleunit_id,TreeOrder,null,strSampleUnit_nm,sum(PRT) PRT,avg(DRR) DRR,avg(HRR) HRR,sum(TPO) TPO,          
  str(sum(APON),10,2) APON,sum(ONTS) ONTS,sum(ISTS) ISTS,sum(STS) STS,sum(D) D,sum(Avail) Avail,sum(TotalDQ) TotalDQ,          
  sum(HCAHPSSampled) HCAHPSSampled          
from #spw          
group by sampleunit_id,strSampleunit_nm,TreeOrder          
order by TreeOrder          
          
end --end AggType=2 loop          
          
else           
begin          
print 'Unspecified AggType'          
--return 
end          
          
set transaction isolation level read uncommitted          
          
drop table #samplesets          
drop table #spw          
drop table #sampleunittree          
drop table #sampleunits          
drop table #sampleplans          
drop table #dqs


