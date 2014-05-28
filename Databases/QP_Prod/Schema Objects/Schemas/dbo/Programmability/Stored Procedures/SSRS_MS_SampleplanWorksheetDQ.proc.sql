Create procedure [dbo].[SSRS_MS_SampleplanWorksheetDQ]      
 @samplesets varchar(8000),      
 @AggType int      
as      
      
----exec ssrs_ms_sampleplanworksheetDQ '2,3,4,13,14',1     
--/***/if object_id('tempdb..#samplesets') is not null drop table #samplesets      
--/***/if object_id('tempdb..#dqs') is not null drop table #dqs      
--/***/if object_id('tempdb..#dqs2') is not null drop table #dqs2      
--/***/if object_id('tempdb..#sampleunittree') is not null drop table #sampleunittree      
--/***/if object_id('tempdb..#sampleunits') is not null drop table #sampleunits      
--/***/if object_id('tempdb..#sampleplans') is not null drop table #sampleplans      
--/***/if object_id('tempdb..#Removed_Rules') is not null drop table #Removed_Rules      
--/***/declare @samplesets varchar(200),@AggType int      
--/***/set @samplesets='2,3,4,13,14' set @AggType=2      
      
set nocount on      
      
set transaction isolation level read uncommitted        
      
/********Temp Table Definition End ***************************************************/      
create table #samplesets (survey_id int,sampleset_id int)      
      
create table #sampleplans (sampleplan_id int,Done bit)      
      
create table #SampleUnits (sampleplan_id int,sampleunit_id int,strSampleUnit_nm varchar(255),intTier int,intTreeOrder int)      
      
create table #SampleUnitTree (sampleplan_id int,sampleunit_id int,strSampleUnit_nm varchar(255),Tier int,TreeOrder int)      
      
create table #DQs (Part varchar(20),sampleset_id int,strSampleUnit_nm varchar(255),Tier int,TreeOrder int,sampleunit_id int,DQ varchar(20),DQOrd int,N int)      
      
create table #Removed_Rules (DQrr varchar(10))      
/********Temp Table Definition End ***************************************************/      
      
declare @sql varchar(8000)      
      
set @sql=      
'insert #samplesets (survey_id,sampleset_id)'+char(10)+      
'select survey_id,sampleset_id'+char(10)+      
'from sampleset'+char(10)+      
'where sampleset_id in ('+@samplesets+')'+char(10)      
      
exec (@sql)      
      
--populate sampleunit tree by sampleplan      
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
      
exec sp_SampleUnits @sampleplan_id      
      
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
      
--populate RemovedRules table      
Insert into #Removed_Rules values ('Resurvey')        
Insert into #Removed_Rules values ('NewBorn')        
Insert into #Removed_Rules values ('TOCL')        
Insert into #Removed_Rules values ('DQRule')        
Insert into #Removed_Rules values ('ExcEnc')        
Insert into #Removed_Rules values ('HHMinor')        
Insert into #Removed_Rules values ('HHAdult')        
Insert into #Removed_Rules values ('SSRemove')        
Insert into #Removed_Rules values ('DupEnc')        
      
--join everything      
insert #dqs (sampleset_id,strSampleUnit_nm,Tier,TreeORder,sampleunit_id,DQ,DQOrd,N)      
select sst.sampleset_id,      
  case 
	when bitHCAHPS=1 then '(H) '+ su.strSampleUnit_nm 
	when bitHHCAHPS=1 then '(HH) '+ su.strSampleUnit_nm 
	when bitMNCM=1 then '(MN) '+ su.strSampleUnit_nm 
	else su.strSampleUnit_nm end,      
  sut.Tier,sut.TreeOrder,sut.sampleunit_id,replace(dq.DQ,'DQ_',''),      
  case when dq.dq in (select DQrr from #Removed_Rules) then 2 else 1 end,dq.N      
from #samplesets sst      
 inner join sampleset ss      
  on (sst.sampleset_id=ss.sampleset_id)      
 inner join sampleplan sp      
  on (ss.sampleplan_id=sp.sampleplan_id)      
 inner join #sampleunittree sut      
  on (sp.sampleplan_id=sut.sampleplan_id)      
 inner join SPWDQCounts dq      
  on (sst.sampleset_id=dq.sampleset_id and sut.sampleunit_id=dq.sampleunit_id)      
 inner join sampleunit su      
  on (sut.sampleunit_id=su.sampleunit_id)      
      
if @AggType=1      
begin      
select 'DQs',sampleset_id,strSampleUnit_nm,Tier,TreeOrder,sampleunit_id,DQ,DQOrd,N      
from #dqs       
order by sampleset_id,treeorder,dqord,dq      
      
end      
      
else if @AggType=2      
begin      
select 'DQs',-1,strSampleUnit_nm,floor(avg(Tier)),floor(avg(TreeOrder)),sampleunit_id,DQ,floor(avg(DQOrd)),sum(N)      
from #dqs      
group by strSampleUnit_nm,sampleunit_id,DQ      
order by floor(avg(TreeOrder)),floor(avg(DQOrd))      
      
end      
      
else       
print 'Unknown AggType'      
      
set transaction isolation level read committed      
 
drop table #samplesets
drop table #sampleplans
drop table #SampleUnits
drop table #SampleUnitTree
drop table #DQs
drop table #Removed_Rules


