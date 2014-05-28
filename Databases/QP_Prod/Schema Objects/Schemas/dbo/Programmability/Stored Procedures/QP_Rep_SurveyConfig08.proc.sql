CREATE PROCEDURE QP_Rep_SurveyConfig08  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50)  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
CREATE TABLE #t (Message VARCHAR(70))  
INSERT INTO #t SELECT 'See "Question Mapping" report.'  
SELECT 'Survey Configuration' AS SheetNameDummy, Message FROM #t  
DROP TABLE #t  
RETURN  
  
  
Declare @intStudy_id int, @intSurvey_id int  
select @intStudy_id=s.study_id, @intSurvey_id=sd.survey_id  
from study s, client c, survey_def sd  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  and sd.strsurvey_nm=@survey  
  
create table #mapping (Tier int, SampleUnit_ID int, SampleUnit_Name varchar(42), ParentSampleUnit_ID int, Quota int, Theme varchar(60), Section_ID int)  
  
------------  
------------  
  
 create table #SampleUnits  
  (SampleUnit_id int,  
   strSampleUnit_nm varchar(255),  
   intTier int,  
   intTreeOrder int)  
  
declare @tier int, @indent varchar(100)  
set @tier=0  
set @indent=''  
  
create table #SU  
 (SampleUnit_id int,  
  strSampleUnit_nm varchar(255),  
  intTier int,  
  strNode varchar(255),  
  intTreeOrder int)  
  
insert into #SU (SampleUnit_id, strSampleUnit_nm, intTier, strNode)  
  select sampleunit_id,strsampleunit_nm,1,convert(varchar,sampleunit_id)  
  from sampleunit   
  where sampleplan_id=(select sampleplan_id from sampleplan where survey_id=@intSurvey_id)  
   and parentsampleunit_id  is null  
  
while (@@rowcount > 0)  
begin  
  set @tier = @tier + 1  
  set @indent=@indent + replicate(' ',2)  
  insert into #SU (SampleUnit_id, strSampleUnit_nm, intTier, strNode)  
   select su.sampleunit_id,@indent+su.strsampleunit_nm,@tier+1,t.strNode+'.'+right('000000'+convert(varchar,su.sampleunit_id),7)  
   from sampleunit su, #SU t  
   where su.sampleplan_id=(select sampleplan_id from sampleplan where survey_id=@intSurvey_id)  
     and su.parentsampleunit_id = t.sampleunit_id   
     and t.intTier=@tier  
end  
  
declare @treeorder int  
set @treeorder = 1  
update #SU   
 set intTreeOrder = @treeorder   
 where strNode = (select min(strNode) from #su where intTreeOrder is null)  
while @@rowcount > 0  
begin  
  set @treeorder = @treeorder + 1  
  update #SU   
   set intTreeOrder = @treeorder   
   where strNode = (select min(strNode) from #su where intTreeOrder is null)  
end  
  
insert into #SampleUnits (sampleunit_id,strSampleUnit_nm,intTier,intTreeOrder)  
  Select sampleunit_id,strSampleUnit_nm,intTier,intTreeOrder  
  from #SU  
  order by strnode  
  
drop table #SU  
  
  
------------  
------------  
  
insert into #mapping (Sampleunit_ID, SampleUnit_Name, ParentSampleunit_id, Quota, Section_ID)  
select distinct su.sampleunit_id, strsampleunit_nm, su.parentsampleunit_id, su.inttargetreturn, sus.selqstnssection  
from sampleplan sp, sampleunit su, sampleunitsection sus  
where sp.survey_id = @intSurvey_id  
and sp.sampleplan_id = su.sampleplan_id  
and su.sampleunit_id = sus.sampleunit_id  
  
insert into #mapping (SampleUnit_Name, SampleUnit_ID, parentsampleunit_id, Quota)  
select strsampleunit_nm, sampleunit_id, parentsampleunit_id, inttargetreturn  
from sampleunit su, sampleplan sp  
where sp.survey_id = @intsurvey_id  
and sp.sampleplan_id = su.sampleplan_id  
and su.sampleunit_id not in (select sampleunit_id  
from #mapping)  
  
update m  
set m.tier = su.inttier  
from #mapping m, #sampleunits su  
where m.sampleunit_id = su.sampleunit_id  
  
delete #mapping where section_id < 1  
  
update m  
set theme = label  
from #mapping m, sel_qstns sq  
where sq.survey_id = @intsurvey_id  
and sq.section_id = m.section_id  
and scaleid = 0  
and language = 1  
and subtype = 3  
and label is not null  
  
update #mapping   
set theme = 'No Theme Assigned'  
where theme is null  
  
select 'Survey Configuration' AS SheetNameDummy, Tier, SampleUnit_ID, SampleUnit_Name, ParentSampleUnit_ID, Quota, Theme, Section_ID
from #mapping  
order by sampleunit_id  
  
drop table #mapping  
  
set transaction isolation level read committed


