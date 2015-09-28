/*
S33_US12 ACO Skip Pattern Instruction Text.sql

As an authorized ACO CAHPS vendor, we want to update the skip pattern instructions to include those with the #, so that we field the survey according to specs	Same verbiage as PQRS	
	12.1	write new stored procedure to determine inclusion in pound sign list
	12.2	refactor PCLGen to call new stored procedure to determine skip language

Dave Gilsdorf

*/
use qp_prod
go
if  exists (select * from sys.columns where object_name(object_id)='SurveyType' and name='UsePoundSignForSkipInstructions')
	alter table SurveyType drop column UsePoundSignForSkipInstructions
go
if exists (select * from sys.procedures where name='UsePoundSignForSkipInstructions')
	drop procedure dbo.UsePoundSignForSkipInstructions
