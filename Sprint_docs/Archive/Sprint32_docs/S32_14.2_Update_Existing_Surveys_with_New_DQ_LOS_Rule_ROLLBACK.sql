/*

S32 Hospice LOS DQ Rule Update	Story: As a certified Hospice CAHPS vendor, we want to refrain from sampling decedents that don’t have an admission date, so that we can administer and submit the survey properly.

Background: The current DQ rule is “(ENCOUNTERLengthOfStay < 2)”, but when AdmitDate is NULL LengthOfStay is also NULL, and these records do not get disqualified. 

Solution:  Modify DQ rule to (ENCOUNTERLengthOfStay < 2) OR (ENCOUNTERLengthOfStay IS NULL)

Task 14.2	alter existing Hospice CAHPS survey DQ rules


Tim Butler


modify DQ_LOS

*/

use QP_Prod

declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @dq_nm varchar(20) = 'DQ_LOS'

SELECT distinct sd.SURVEY_ID, sd.STUDY_ID
into #Surveys
from Survey_DEF sd
inner join BusinessRule br on br.Survey_Id = sd.Survey_id
inner join CRITERIASTMT cs on br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
where SurveyType_id = @hospiceId
and br.BUSRULE_CD = 'Q'

select *
from #Surveys

/* process each survey, one at a time */
declare @survey_id int, @study_id int
select top 1 @survey_id = survey_id, @study_id = study_id from #Surveys
while @@rowcount>0
begin

	-- Remove DQ_LOS rule from existing surveys
	declare @criteriastmt_id int
	declare @businessrule_id int
	if exists (	select 1 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm='DQ_LOS'
				and br.survey_id=@survey_id)
	begin
		print '"DQ_LOS" exists for study ' + convert(varchar,@study_id)+' survey '+convert(varchar,@survey_id)+'. removing...'

				select @businessrule_id = br.BUSINESSRULE_ID, @criteriastmt_id = cs.CRITERIASTMT_ID 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm='DQ_LOS'
				and br.survey_id=@survey_id

				delete from BusinessRule
				--select * from BUSINESSRULE
				where BUSINESSRULE_ID = @businessrule_id

				delete from CRITERIASTMT
				--select * from CRITERIASTMT
				where CRITERIASTMT_ID = @criteriastmt_id

				delete from CRITERIACLAUSE
				--select * from CRITERIACLAUSE
				where CRITERIASTMT_ID = @criteriastmt_id

	end

	-- now we add the new rule.  It will skip the existing rules and add only the new one.
	exec QCL_InsertDefaultDQRules @survey_id

	delete from #Surveys where survey_id=@survey_id and STUDY_ID = @study_id
	select top 1 @survey_id = survey_id, @study_id = study_id from #Surveys
end

drop table #Surveys

