CREATE PROCEDURE DBO.QP_REP_PROJSTATUS_LOADED    
 @ASSOCIATE VARCHAR(50),    
 @CLIENT VARCHAR(50),    
 @STUDY VARCHAR(50),    
 @ACTIVITYSINCE DATETIME    
AS    

-- Modified 5/22/06 SJS

-- declare @Associate varchar(50), @Client varchar(50), @Study varchar(50), @ActivitySince datetime    
-- select @associate='sspicka', @client='Children''s Hospital of Wisconsin', @study='CHWI', @activitysince= '12/19/2005'
   
create table #CS (    
 client_id int,     
 Study_id int,     
 strCutoffResponse_CD int,     
 cutofftable_id int,     
 cutofffield_id int,     
 strCutoffTable_nm varchar(42),     
 strCutoffField_nm varchar(42),    
 intFlag int default 0,    
 bitEncounterTable bit)    
    
insert into #cs (client_id, Study_id, strCutoffResponse_CD, cutofftable_id, cutofffield_id, strcutofftable_nm, strCutofffield_nm, bitEncounterTable)    
select css.client_id, css.study_id, max(sd.strCutoffResponse_CD) as strCutoffResponse_CD, max(sd.cutofftable_id) as cutofftable_id,     
max(sd.cutofffield_id) as cutofffield_id, NULL, NULL, 0    
from clientstudysurvey_view css, survey_def sd, data_set ds    
where css.strclient_nm=@Client    
  and css.strstudy_nm=case when @study='_ALL' then css.strStudy_nm else @Study end    
  and css.study_id=ds.study_id    
  and ds.datload_dt >= @ActivitySince    
  and css.survey_id = sd.survey_id    
group by css.client_id, css.study_id    
    
update #cs    
set strCutoffTable_nm=strTable_nm, strCutoffField_nm=strField_nm    
from metatable mt, metafield mf    
where #cs.cutofftable_id=mt.table_id    
and #cs.cutofffield_id=mf.field_id    
and #cs.strCutoffResponse_cd = 2     
    
update #cs    
set bitEncounterTable=1    
from metatable mt    
where #cs.study_id=mt.study_id    
and mt.strTable_nm = 'ENCOUNTER'    
    
create table #counts (dataset_id int, rec_cnt int, indiv_cnt int, FirstDt datetime, LastDt datetime)    
    
declare @SQL varchar(8000)    
    
set rowcount 100  
update #cs set intFlag=1    
while @@rowcount>0     
begin    

-- Changed the join criteria to user either pop_id if pop table only, or enc_id if ENC table exists, but not both (query was slow when joining on pop_id and enc_id)
 set @SQL=''    
 select @SQL=@SQL+'    
 insert into #counts     
 select ds.dataset_id,count(*),count(distinct pop_id), '+isnull('min('+strcutofftable_nm+strCutofffield_nm+')','null')+' as FirstDt, '+isnull('max('+strcutofftable_nm+strCutofffield_nm+')','null')+' as LastDt    
 from data_set ds, datasetmember dsm, s'+convert(varchar,study_id)+'.big_view bv    
 where ds.study_id='+convert(varchar,study_id)+'    
 and ds.datload_dt>='''+convert(varchar,@ActivitySince,101)+'''    
 and ds.dataset_id=dsm.dataset_id  '+ 
 case when bitEncounterTable=1 then ' and dsm.enc_id=bv.encounterenc_id' else ' and dsm.pop_id=bv.populationpop_id ' end + 
 ' group by ds.dataset_id '    
 from #CS    
 where intFlag=1    

    
 exec (@SQL)    
    
 delete from #CS where intflag=1    
 update #cs set intFlag=1    
end    
    
set rowcount 0    
    
set @SQL =     
'select s.strStudy_nm as [Study files loaded since '+convert(varchar, @ActivitySince, 7)+'], convert(varchar,DATLOAD_DT,101) as [Loaded On],     
convert(varchar,sub.firstdt,101)+'' - ''+convert(varchar,sub.lastdt,101) as [Date Range], dbo.AddComma(sub.Rec_Cnt) as [# records], dbo.AddComma(sub.indiv_cnt) as [# individuals]    
from data_set ds, study s, #counts sub    
where ds.study_id=s.study_id    
and ds.dataset_id = sub.dataset_id    
order by strStudy_nm, datLoad_dt'    
    
exec (@SQL)    
    
drop table #cs    
drop table #counts


