/*
S39_US19 SV_SamplePlan_Has_Consistent_CCNs.sql

user story 19 Consistent CCN survey validation 
As a certified CAHPS vendor, we want to ensure that if a sample unit is assigned to a CCN, all of its children are assigned to that same CCN so that we conform to CMS requirements and submit valid data.

Dave Gilsdorf

QP_Prod:
CREATE PROCEDURE dbo.SV_SamplePlan_Has_Consistent_CCNs
INSERT INTO dbo.SurveyValidationProcs

*/
use QP_Prod
go
declare @SurveyValidationProcs_id int
if not exists (select * from SurveyValidationProcs where ProcedureName='SV_SamplePlan_Has_Consistent_CCNs')
begin
	INSERT INTO dbo.SurveyValidationProcs (ProcedureName, ValidMessage, intOrder)
	select 'SV_SamplePlan_Has_Consistent_CCNs','PASSED!  Sample Plan has consistent CCN assignments', max(intOrder)+1 
	from SurveyValidationProcs 
	set @SurveyValidationProcs_id=scope_identity()
end 
else
begin
	select @SurveyValidationProcs_id=SurveyValidationProcs_id 
	from SurveyValidationProcs 
	where ProcedureName='SV_SamplePlan_Has_Consistent_CCNs'
end
if not exists (select * from SurveyValidationProcsBySurveyType where SurveyValidationProcs_id=@SurveyValidationProcs_id)
	insert into SurveyValidationProcsBySurveyType (SurveyValidationProcs_id, CAHPSType_ID, SubType_ID)
	select distinct @SurveyValidationProcs_id, CAHPSType_ID, SubType_ID
	from SurveyValidationProcsBySurveyType 
go
if exists (select * from sys.procedures where name = 'SV_SamplePlan_Has_Consistent_CCNs')
	drop procedure dbo.SV_SamplePlan_Has_Consistent_CCNs
go
CREATE PROCEDURE dbo.SV_SamplePlan_Has_Consistent_CCNs
@survey_id int
as
select sp.Survey_id, sd.SurveyType_id, su.SampleUnit_id
	, su.ParentSampleUnit_id, convert(varchar(100),su.strSampleUnit_nm) as strSampleUnit_nm, su.SUFacility_id, suf.MedicareNumber, su.CAHPSType_id, 0 as Tier, -1 as CCNMatch
	, convert(varchar(50),null) as TierSort
into #su
from sampleunit su
inner join sampleplan sp on su.sampleplan_id=sp.sampleplan_id
inner join survey_def sd on sp.survey_id=sd.survey_id
left join SUFacility suf on su.SUFacility_id=suf.SUFacility_id
where sd.survey_id = @survey_id

update #su set Tier=1, TierSort=Sampleunit_id where parentsampleunit_id is null

while @@rowcount>0
	update child
	set Tier=parent.Tier+1
		, CCNMatch = case when parent.MedicareNumber is NULL or isnull(parent.MedicareNumber,-1) = isnull(child.MedicareNumber,-1) then 1 else 0 end
		, TierSort=parent.TierSort+'.'+convert(varchar,child.sampleunit_id)
		--, strSampleUnit_nm=replicate('  ',parent.Tier)+strSampleUnit_nm
	from #su child
	inner join (select sampleunit_id, SUFacility_id, MedicareNumber, Tier, TierSort from #su where tier>0) parent
		on child.parentsampleunit_id=parent.sampleunit_id
	where child.tier=0

if exists (select * from #su where CCNMatch=0)
	select 1 error, left('CCN consistentcy error: "'+strsampleunit_nm+'" is assigned to a different CCN than its parent.',200) strMessage from #su where ccnmatch=0 order by TierSort
else 
	select 0 error, 'Sample Plan has consistent CCN assignments' strMessage 

drop table #su
