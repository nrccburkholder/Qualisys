/*
S39_US19 SV_SamplePlan_Has_Consistent_CCNs.sql

user story 10 Consistent CCN survey validation 
As a certified CAHPS vendor, we want to ensure that if a sample unit is assigned to a CCN, all of its children are assigned to that same CCN so that we conform to CMS requirements and submit valid data.

Dave Gilsdorf

QP_Prod:
CREATE PROCEDURE dbo.SV_SamplePlan_Has_Consistent_CCNs
INSERT INTO dbo.SurveyValidationProcs

*/
use QP_Prod
go
delete from SurveyValidationProcs where ProcedureName='SV_SamplePlan_Has_Consistent_CCNs'

if exists (select * from sys.procedures where name = 'SV_SamplePlan_Has_Consistent_CCNs')
	drop procedure dbo.SV_SamplePlan_Has_Consistent_CCNs
go

