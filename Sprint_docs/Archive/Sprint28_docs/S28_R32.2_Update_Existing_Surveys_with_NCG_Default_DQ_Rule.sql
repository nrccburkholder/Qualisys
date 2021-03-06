/*

R32	Hospice non- caregiver name not generated

Tim Butler


remove old rules from each Hospice survey and add the new DQ_NCG rule.

*/

use QP_Prod

declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'


SELECT distinct sd.SURVEY_ID, sd.STUDY_ID
into #Surveys
from Survey_DEF sd
inner join BusinessRule br on br.Survey_Id = sd.Survey_id
inner join CRITERIASTMT cs on br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
where SurveyType_id = 11
and br.BUSRULE_CD = 'Q'

select *
from #Surveys

/* process each survey, one at a time */
declare @survey_id int, @study_id int
select top 1 @survey_id = survey_id, @study_id = study_id from #Surveys
while @@rowcount>0
begin

	-- Remove DQ_Lnm DQ_Fnm rules from existing surveys
	declare @criteriastmt_id int
	declare @businessrule_id int
	if exists (	select 1 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm='DQ_F Nm'
				and br.survey_id=@survey_id)
	begin
		print '"DQ_F Nm" exists for study ' + convert(varchar,@study_id)+' survey '+convert(varchar,@survey_id)+'. removing...'

				select @businessrule_id = br.BUSINESSRULE_ID, @criteriastmt_id = cs.CRITERIASTMT_ID 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm='DQ_F Nm'
				and br.survey_id=@survey_id

				delete from BusinessRule
				where BUSINESSRULE_ID = @businessrule_id

				delete from CRITERIASTMT
				where CRITERIASTMT_ID = @criteriastmt_id

				delete from CRITERIACLAUSE
				where CRITERIASTMT_ID = @criteriastmt_id

	end

	if exists (	select 1 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm='DQ_L Nm'
				and br.survey_id=@survey_id)
	begin
		print '"DQ_L Nm" exists for study ' + convert(varchar,@study_id)+' survey '+convert(varchar,@survey_id)+'. removing...'

		select @businessrule_id = br.BUSINESSRULE_ID, @criteriastmt_id = cs.CRITERIASTMT_ID 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm='DQ_L Nm'
				and br.survey_id=@survey_id

		delete from BusinessRule
		where BUSINESSRULE_ID = @businessrule_id

		delete from CRITERIASTMT
		where CRITERIASTMT_ID = @criteriastmt_id

		delete from CRITERIACLAUSE
		where CRITERIASTMT_ID = @criteriastmt_id

	end

	-- now we add the new rule.  It will skip the existing rules and add only the new one.
	exec QCL_InsertDefaultDQRules @survey_id

	delete from #Surveys where survey_id=@survey_id and STUDY_ID = @study_id
	select top 1 @survey_id = survey_id, @study_id = study_id from #Surveys
end

drop table #Surveys