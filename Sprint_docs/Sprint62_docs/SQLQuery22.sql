USE [QP_Prod]


declare survey_id int = 15584
declare study_id int = 4745

SELECT  BusinessRule_Id, Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD
FROM BusinessRule
WHERE Survey_ID=15825

declare @criteriastmt_id int
	declare @businessrule_id int

				select @businessrule_id = br.BUSINESSRULE_ID, @criteriastmt_id = cs.CRITERIASTMT_ID 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=4714
				and br.survey_id=15825

				select * from BUSINESSRULE
				where BUSINESSRULE_ID in (
					select br.BUSINESSRULE_ID
					from CriteriaStmt cs
					inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
					where cs.study_id=4714
					and br.survey_id=15825
				)

				select * from CRITERIASTMT
				where CRITERIASTMT_ID in (
					select cs.CRITERIASTMT_ID 
					from CriteriaStmt cs
					inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
					where cs.study_id=4714
					and br.survey_id=15825

				)

				select * from CRITERIACLAUSE
				where CRITERIASTMT_ID in (
					select cs.CRITERIASTMT_ID 
					from CriteriaStmt cs
					inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
					where cs.study_id=4714
					and br.survey_id=15825

				)


				--delete from BUSINESSRULE
				--where BUSINESSRULE_ID = 212895