/*

S63 ATL-1182 Query For Questionnaire Cycle and Strata.sql

Chris Burkholder

12/6/2016

create procedure CIHI.PullSubmissionData_QuestionnaireCycle

*/

--truncate table CIHI.QA_QuestionnaireCycleAndStratum
--select * from CIHI.QA_QuestionnaireCycleAndStratum order by FacilityNum

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_QuestionnaireCycle')
       drop procedure CIHI.PullSubmissionData_QuestionnaireCycle
go
