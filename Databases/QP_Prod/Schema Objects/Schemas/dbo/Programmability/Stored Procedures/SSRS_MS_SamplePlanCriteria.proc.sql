CREATE procedure [dbo].[SSRS_MS_SamplePlanCriteria]  
 @surveys varchar(1000)  
  
as   
  
--exec ssrs_ms_SamplePlanCriteria '6,16,49,58'  
--/***/if object_id('tempdb..#surveys') is not null drop table #surveys  
--/***/if object_id('tempdb..#sampleplans') is not null drop table #sampleplans  
--/***/if object_id('tempdb..#SampleUnitTree') is not null drop table #SampleUnitTree  
--/***/if object_id('tempdb..#SampleUnits') is not null drop table #SampleUnits  
--/***/if object_id('tempdb..#results') is not null drop table #results  
--/***/if object_id('tempdb..#DQRules') is not null drop table #DQRules  
--/***/declare @surveys varchar(1000) set @surveys='6,9,18,25,26,52'  

/* 03/12/2013 --  TS Changed strCriteriaString from 7000 to max */
  
set transaction isolation level read uncommitted  
  
/********Temp Table Definition End ***************************************************/    
create table #surveys (survey_id int,sampleplan_id int)  
  
create table #sampleplans (sampleplan_id int,Done bit)  
  
create table #SampleUnitTree (sampleplan_id int,sampleunit_id int,strSampleUnit_nm varchar(255),Tier int,TreeOrder int)    
    
create table #SampleUnits (sampleplan_id int,sampleunit_id int,strSampleUnit_nm varchar(255),intTier int,intTreeOrder int)    
  
create table #results (Part varchar(10),survey_id int,strSurvey_nm varchar(50),ID varchar(20),Target int,ResponseRate int,  
       Name varchar(255),Tier int,TreeOrder int,UnitType varchar(25),HCAHPS varchar(5),strCriteriaString varchar(max),  
       RuleType varchar(20),RuleName varchar(50))  
  
/********Temp Table Definition End ***************************************************/    
  
declare @sql varchar(1500)  
  
set @sql=  
'insert #surveys'+char(10)+  
'select survey_id,sampleplan_id'+char(10)+  
'from sampleplan'+char(10)+  
'where survey_id in ('+@surveys+')'  
  
exec (@sql)  
   
--populate sampleunit tree by sampleplan    
insert #sampleplans (sampleplan_id,Done)    
select distinct sampleplan_id,0    
from #surveys   
    
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
    
end --end sutree loop  select * from sampleunittree  
  
insert #results(Part,survey_id,strSurvey_nm,ID,Target,ResponseRate,Name,Tier,TreeOrder,UnitType,HCAHPS,strCriteriaString)  
select 'Unit',st.survey_id,sd.strSurvey_nm,  
  case su.bitSuppress when 0 then convert(varchar,sut.sampleunit_id) else convert(varchar,sut.sampleunit_id)+' (Suppressed)' end,  
  su.intTargetReturn,  
  case su.NumResponseRate when 0 then su.numinitresponserate else su.NumResponseRate end,  
  case 
	when bitHCAHPS=1 then '(H) '+ su.strSampleUnit_nm 
	when bitHHCAHPS=1 then '(HH) '+ su.strSampleUnit_nm 
	when bitMNCM=1 then '(MN) '+ su.strSampleUnit_nm 
	else su.strSampleUnit_nm end,      
  sut.Tier,sut.TreeOrder,sst.SampleSelectionType_dsc,  
  case su.bitHCAHPS when 0 then 'No' else 'Yes' end,  
  cs.strCriteriaString   
from #surveys st  
 inner join survey_def sd  
  on (st.survey_id=sd.survey_id)  
 inner join sampleplan sp  
  on (st.sampleplan_id=sp.sampleplan_id)  
 inner join SampleUnit su  
  on (sp.sampleplan_id=su.sampleplan_id)  
 inner join #SampleUnitTree sut  
  on (su.sampleunit_id=sut.sampleunit_id)  
 inner join SampleSelectionType sst  
  on (su.SampleSelectionType_id=sst.SampleSelectionType_id)  
 inner join CriteriaStmt cs  
  on (su.criteriastmt_id=cs.criteriastmt_id)  
  
insert #results (Part,survey_id,strSurvey_nm,ID,RuleType,strCriteriaString,RuleName)  
select 'DQ',st.survey_id,sd.strSurvey_nm,br.businessrule_id,br.BusRule_CD,cs.strCriteriaString,cs.strcriteriastmt_nm  
from #surveys st  
 inner join survey_def sd  
  on (st.survey_id=sd.survey_id)  
 inner join BusinessRule br  
  on (st.survey_id=br.survey_id)  
 inner join criteriastmt cs  
  on (br.criteriastmt_id=cs.criteriastmt_id)  
  
  
select Part,survey_id,strSurvey_nm,ID,Target,ResponseRate,Name,Tier,TreeOrder,UnitType,HCAHPS,strCriteriaString,RuleType,RuleName  
from #results  
order by strSurvey_nm,Part,TreeOrder  
  
  
set transaction isolation level read committed  
  
drop table #surveys  
drop table #sampleplans  
drop table #SampleUnitTree  
drop table #SampleUnits  
drop table #results


