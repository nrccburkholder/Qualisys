--DRM 11/23/2011 Changed Datasets field in #title table to be varchar(2500) instead of varchar(500) 
--Santosh Doodi - Max'ed up the Sampelset variable size on 01/24/2012     
CREATE procedure [dbo].[SSRS_MS_SamplePlanWorksheetTitle]              
 @samplesets nvarchar(max),              
 @AggType int              
as              
              
--exec ssrs_ms_sampleplanworksheettitle '2,3,4,13,14',1              
--if object_id('tempdb..#samplesets') is not null drop table #samplesets              
--if object_id('tempdb..#title') is not null drop table #title              
--if object_id('tempdb..#alldatasets') is not null drop table #alldatasets              
--if object_id('tempdb..#datasets') is not null drop table #datasets              
--if object_id('tempdb..#dstemp') is not null drop table #dstemp              
--declare @samplesets varchar(200),@AggType int --1 Sampleset 2 Overall              
--set @samplesets='2,3,4,13,14'--'6,32,33,95,96,97,103'               
--set @AggType=1              
              
print 'Inside of SSRS_MS_SamplePlanWorksheetTitle'      
      
set nocount on              
              
set transaction isolation level read uncommitted                
              
/********Temp Table Definition End ***************************************************/              
create table #samplesets (survey_id int,sampleset_id int)              
              
create table #title (survey_id int,sampleset_id int,datSampleCreate_dt datetime,              
        PeriodDateMin datetime,PeriodDateMax  datetime,              
        SelectedDateMin datetime,SelectedDateMax datetime,              
        EncounterDateField varchar(60),              
                       SampledDateRangeMin datetime,SampledDateRangeMax datetime,              
                       Datasets varchar(2500),SamplingType varchar(20),              
        SamplingAlgorithm varchar(30),SAP int,SIP int,SLP int)              
              
create table #datasets (sampleset_id int,dataset_id int,Done bit)              
/********Temp Table Definition End ***************************************************/              
              
              
declare @sql varchar(8000)              
set @sql=              
'insert #samplesets (survey_id,sampleset_id)'+char(10)+              
'select survey_id,sampleset_id'+char(10)+              
'from sampleset'+char(10)+              
'where sampleset_id in ('+@samplesets+')'+char(10)              
      
print @sql              
exec (@sql)              
              
      
print 'Insert into #title'      
insert #title (survey_id,sampleset_id,datSampleCreate_dt,              
        PeriodDateMin,PeriodDateMax,              
        SelectedDateMin,SelectedDateMax,              
                       SampledDateRangeMin,SampledDateRangeMax,              
        EncounterDateField,              
                       Datasets,SamplingType,              
        SamplingAlgorithm,SAP,SIP,SLP)              
select sst.survey_id,              
  sst.sampleset_id,ss.datSampleCreate_dt,              
  p.datExpectedEncStart,p.datExpectedEncEnd,              
  ss.datDateRange_FromDate,ss.datDateRange_ToDate,              
  spwd2.minenc_dt,spwd2.maxenc_dt,              
  '',              
  '',              
  sm.strsamplingmethod_nm,              
  sa.AlgorithmName,                
  spwd1.SAP,spwd1.SIP,            
  case when spwd1.SIP-spwd1.SAP<0 then 0 else spwd1.SIP-spwd1.SAP end            
from #samplesets sst              
 inner join sampleset ss              
  on (sst.sampleset_id=ss.sampleset_id)              
 inner join (select spw.sampleset_id,max(spw.intSamplesAlreadyPulled) SAP,max(spw.intSamplesInPeriod) SIP              
    from sampleplanworksheet spw              
    inner join #samplesets sst              
     on (spw.sampleset_id=sst.sampleset_id)              
    group by spw.sampleset_id) spwd1              
  on (sst.sampleset_id=spwd1.sampleset_id)              
 inner join (select spw.sampleset_id,min(spw.minenc_dt) minenc_dt,max(spw.maxenc_dt) maxenc_dt              
    from sampleplanworksheet spw              
    inner join #samplesets sst              
     on (spw.sampleset_id=sst.sampleset_id)              
    group by spw.sampleset_id) spwd2              
  on (sst.sampleset_id=spwd2.sampleset_id)              
 inner join perioddates pd           
  on (sst.sampleset_id=pd.sampleset_id)              
 inner join perioddef p              
  on (pd.PeriodDef_id=p.PeriodDef_id)                
 inner join survey_def sd             
  on (sd.survey_id=ss.survey_id)              
 inner join samplingalgorithm sa              
  on (sd.SamplingAlgorithmId=sa.SamplingAlgorithmId)              
 inner join samplingmethod sm              
  on (sm.samplingmethod_id=p.samplingmethod_id)                
              
print 'Update #title'      
update t              
set EncounterDateField=              
  case mt.strTable_nm              
  when 'ENCOUNTER' then isnull(mt.strTable_nm+'.'+mf.strField_nm,'encounterNewRecordDate')              
  else 'populationNewRecordDate'              
  end              
from #title t              
 inner join survey_def sd              
  on (t.survey_id=sd.survey_id)              
 inner join metatable mt              
  on (sd.sampleencountertable_id=mt.table_id)              
 inner join metafield mf              
  on (sd.sampleencounterfield_id=mf.field_id)              
 inner join #samplesets sst              
  on (sd.survey_id=sst.survey_id)              
where mf.strFieldDataType='D'              
      
print 'insert into #datasets'              
insert #datasets (sampleset_id,dataset_id,Done)              
select sd.sampleset_id,sd.dataset_id,0              
from sampledataset sd              
 inner join #samplesets sst              
  on (sd.sampleset_id=sst.sampleset_id)                
           
print 'entering DataSet loop'         
declare @sid1 int,@sid2 int,@dataset_id int,@datasets varchar(500)              
              
select top 1 @sid1=sampleset_id,@dataset_id=dataset_id              
from #datasets              
where Done=0              
              
while @@rowcount>0              
              
begin --begin dataset assignment loop              
print 'Update Dataset 1'           
print '@dataset_id = ' + cast(@dataset_id as varchar (8000))         
      
update t              
set Datasets=Datasets+convert(varchar,@dataset_id)+','              
from #title t              
where t.sampleset_id=@sid1              
          
print 'Update Dataset 2'           
update #datasets              
set Done=1              
where sampleset_id=@sid1              
 and dataset_id=@dataset_id              
              
select top 1 @sid1=sampleset_id,@dataset_id=dataset_id              
from #datasets              
where Done=0              
              
end --end dataset assignment loop              
      
print 'Update Dataset 3'           
update t              
set Datasets=substring(Datasets,1,len(Datasets)-1)              
from #title t              
              
if @AggType=1  --select * from #results              
begin --begin aggtype1 loop             
  print 'begin aggtype1 loop  '       
  select 'Title',sampleset_id,datSampleCreate_dt,              
    isnull(convert(varchar,PeriodDateMin,101)+' - '+convert(varchar,PeriodDateMax,101),'Period Date Range Unspecified') [Period Date Range],              
    isnull(convert(varchar,SelectedDateMin,101)+' - '+convert(varchar,SelectedDateMax,101),'Selected Date Range Unspecified') [Selected Date Range],              
    isnull(convert(varchar,SampledDateRangeMin,101)+' - '+convert(varchar,SampledDateRangeMax,101),'Sampled Date Range Unspecified') [Sampled Date Range],              
    EncounterDateField,Datasets,SamplingType,SamplingAlgorithm,SAP,SIP,SLP              
  from #title              
              
end --end aggtype1 loop              
              
else if @AggType=2              
begin --begin aggtype2 loop              
  print 'begin aggtype2 loop'      
  create table #dstemp (Datasets varchar(500),Done bit)              
              
  declare @ds varchar(500)              
              
set @datasets=''              
              
insert #dstemp (Datasets,Done)              
select Datasets,0              
from #title              
order by datSampleCreate_dt              
              
select top 1 @ds=Datasets              
from #dstemp              
where Done=0              
              
while @@rowcount>0              
              
begin --begin datasets string pop              
set @datasets=@datasets+@ds+','            
              
update #dstemp              
set Done=1              
where Datasets=@ds              
              
select top 1 @ds=Datasets              
from #dstemp              
where Done=0              
              
end --begin datasets string pop              
              
set @datasets=substring(@datasets,1,len(@datasets)-1)              
              
              
select 'Title',-1 sampleset_id,null,              
  isnull(convert(varchar,min(PeriodDateMin),101)+' - '+convert(varchar,max(PeriodDateMax),101),'Period Date Range Unspecified') [Period Date Range],              
  isnull(convert(varchar,min(SelectedDateMin),101)+' - '+convert(varchar,max(SelectedDateMax),101),'Selected Date Range Unspecified') [Selected Date Range],              
  isnull(convert(varchar,min(SampledDateRangeMin),101)+' - '+convert(varchar,max(SampledDateRangeMax),101),'Sampled Date Range Unspecified') [Sampled Date Range],              
  '' EncounterDateField,@Datasets Datasets,'' SamplingType,'' SamplingAlgorithm,count(*) SAP,null SIP,null SLP              
from #title              
              
              
drop table #dstemp              
                
              
end              
              
else              
begin              
print 'unknown agg type'              
end              
            
              
set transaction isolation level read committed                
              
drop table #samplesets              
drop table #title              
drop table #datasets


