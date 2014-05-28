CREATE procedure QP_Rep_SamplePlanCriteria_loop
as

select distinct survey_id
into #survey
from survey_def 
order by survey_id

set nocount on

set transaction isolation level read uncommitted

Declare @intSurvey_id int, @intSamplePlan_id int, @strsql1 varchar(8000), @strsql2 varchar(8000), @num int, @ad varchar(25)

while (select count(*) from #survey) > 0
begin

select @intSurvey_id = (select min(survey_id) from #survey)

set @ad = (select strntlogin_nm from survey_def sd, study s, employee e where sd.survey_id = @intsurvey_id and sd.study_id = s.study_id and s.ademployee_id = e.employee_id)

set @num = ((select count(*) from #survey) - 1)

print 'working on survey ' + convert(varchar,@intsurvey_id) + '.  That means there are ' + convert(varchar,@num) + ' surveys left.'

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int)

create table #rpt 
  (SampleUnit_id int, 
   CriteriaStmt_id int, 
   parentSampleUnit_id int, 
   strSampleUnit_nm varchar(60), 
   tier int, 
   dummyTreeOrder int)


select @intSamplePlan_id=SamplePlan_id 
from SamplePlan 
where Survey_id=@intSurvey_id

exec sp_SampleUnits @intSamplePlan_id
  

INSERT into #rpt 
  (SampleUnit_id, tier, strSampleUnit_nm, dummyTreeOrder) 
select SampleUnit_id, intTier, strSampleUnit_nm, intTreeOrder
from #SampleUnits
 
drop table #SampleUnits

update #rpt
  set CriteriaStmt_id=su.CriteriaStmt_id
  from SampleUnit su
  where #rpt.SampleUnit_id=su.SampleUnit_id

create table #criters 
  (CriteriaStmt_id int,
  strCriteriaStmt varchar(2550),
  dummy_line int)

insert into #criters (CriteriaStmt_id) 
  select distinct CriteriaStmt_id from #rpt

exec sp_CriteriaStatements
update #criters set dummy_line=1

declare @crntLine int, @cnt int
set @crntLine=2
select @cnt=count(*) from #criters where len(strCriteriaStmt) > 255
while @cnt > 0 
begin
  insert into #criters (CriteriaStmt_id,dummy_line,strCriteriaStmt)
    select CriteriaStmt_id,@crntLine,substring(strCriteriaStmt,256,2550) 
    from #criters
    where len(strCriteriaStmt) > 255 and dummy_line < @crntLine

  update #criters
  set strCriteriaStmt = left(strCriteriaStmt,255)
  where len(strCriteriaStmt) > 255 and dummy_line < @crntLine
  
  set @crntLine = @crntLine + 1 
  select @cnt=count(*) from #criters where len(strCriteriaStmt) > 255
end

set @strsql1 = 'select convert(varchar(20),'' '') AHA, convert(varchar(42),'' '') City,convert(varchar(42),'' '') State,convert(varchar(42),'' '') Country,convert(varchar(42),'' '') FacilityName, ' + char(10) +
' css.strclient_nm, css.client_id, css.strstudy_nm, css.study_id, css.strsurvey_nm, css.survey_id, ' + char(10) +
' r.SampleUnit_id as SampUnit, su.INTTARGETRETURN as Target, case su.NUMRESPONSERATE when 0 then su.NumInitResponseRate else su.NumResponseRate end as ResponeRate, r.strSampleUnit_nm as SampleUnit, convert(varchar(255),c.strCriteriaStmt) as CriteriaStatement, ' + char(10) +
' dummyTreeOrder, dummy_line, '' '' Freestanding, '' '' IPMedSurg, '' '' IPOB, '' '' IPPeds, '' '' IPCardiology, '' '' IPOncology, '' '' IPRehabTherapy, '' '' IPOrthopedics, '' '' IPLab, '' '' IPRad, ' + char(10) +
' '' '' IPICU, '' '' IPDietary, '' '' IPPainCenter, '' '' OtherIP, '' '' OPSurg, '' '' OPEndoscopy, '' '' OPPeds, '' '' OPCardiology, '' '' OPOncology, '' '' OPOrthopedics, '' '' OPCardiacPulmonaryRehab, ' + char(10) +
' '' '' OPPhysOccuTherapy, '' '' OPCathLab, '' '' OPLab, '' '' OPRad, '' '' OPDietary, '' '' OPPainCenter, '' '' OtherOPTestingTherapy, '' '' OtherOPSpecialty, '' '' ER, '' '' UrgentCare, ' + char(10) +
' '' '' HH, '' '' POV, '' '' Phys, '' '' Emp, '' '' Member' + char(10) +
' into qp_archive.dbo.' + rtrim(@ad) + 'survey' +convert(varchar,@intsurvey_id) + 'criteria ' + char(10) +
' from #rpt r, #criters c, SampleUnit su, clientstudysurvey_view css' + char(10) +
' where r.CriteriaStmt_id=c.CriteriaStmt_id and c.dummy_line=1 and r.SampleUnit_id=su.SampleUnit_id and su.sampleplan_id = css.sampleplan_id' + char(10) +
' union'
set @strsql2 =' select convert(varchar(20),'' '') AHA, convert(varchar(42),'' '') City,convert(varchar(42),'' '') State,convert(varchar(42),'' '') Country,convert(varchar(42),'' '') FacilityName, ' + char(10) +
' css.strclient_nm, css.client_id, css.strstudy_nm, css.study_id, css.strsurvey_nm, css.survey_id, ' + char(10) +
' r.SampleUnit_id as SampUnit, su.INTTARGETRETURN as Target, case su.NUMRESPONSERATE when 0 then su.NumInitResponseRate else su.NumResponseRate end as ResponeRate, '' '' as SampleUnit, convert(varchar(255),c.strCriteriaStmt) as CriteriaStatement, ' + char(10) +
' dummyTreeOrder, dummy_line, '' '' Freestanding, '' '' IPMedSurg, '' '' IPOB, '' '' IPPeds, '' '' IPCardiology, '' '' IPOncology, '' '' IPRehabTherapy, '' '' IPOrthopedics, '' '' IPLab, '' '' IPRad, ' + char(10) +
' '' '' IPICU, '' '' IPDietary, '' '' IPPainCenter, '' '' OtherIP, '' '' OPSurg, '' '' OPEndoscopy, '' '' OPPeds, '' '' OPCardiology, '' '' OPOncology, '' '' OPOrthopedics, '' '' OPCardiacPulmonaryRehab, ' + char(10) +
' '' '' OPPhysOccuTherapy, '' '' OPCathLab, '' '' OPLab, '' '' OPRad, '' '' OPDietary, '' '' OPPainCenter, '' '' OtherOPTestingTherapy, '' '' OtherOPSpecialty, '' '' ER, '' '' UrgentCare, ' + char(10) +
' '' '' HH, '' '' POV, '' '' Phys, '' '' Emp, '' '' Member' + char(10) +
' from #rpt r, #criters c, SampleUnit su, clientstudysurvey_view css' + char(10) +
' where r.CriteriaStmt_id=c.CriteriaStmt_id and c.dummy_line>1 and r.SampleUnit_id=su.SampleUnit_id and su.sampleplan_id = css.sampleplan_id' + char(10) +
' order by r.dummyTreeOrder, dummy_line' 

exec (@strsql1 + @strsql2)

drop table #criters
drop table #rpt

delete #survey where survey_id = @intsurvey_id

end

set transaction isolation level read committed


