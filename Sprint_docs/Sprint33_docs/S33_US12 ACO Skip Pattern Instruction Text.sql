/*
S33_US12 ACO Skip Pattern Instruction Text.sql

As an authorized ACO CAHPS vendor, we want to update the skip pattern instructions to include those with the #, so that we field the survey according to specs	Same verbiage as PQRS	
	12.1	write new stored procedure to determine inclusion in pound sign list
	12.2	refactor PCLGen to call new stored procedure to determine skip language

Dave Gilsdorf

*/
use qp_prod
go
if not exists (select * from sys.columns where object_name(object_id)='SurveyType' and name='UsePoundSignForSkipInstructions')
	alter table SurveyType add UsePoundSignForSkipInstructions bit
go
update surveytype set UsePoundSignForSkipInstructions = 0
update surveytype set UsePoundSignForSkipInstructions = 1 where surveytype_dsc in ('PQRS CAHPS','ACOCAHPS')
update surveytype set SkipRepeatsScaleText = 1 where surveytype_dsc in ('ACOCAHPS')
go
if exists (select * from sys.procedures where name='UsePoundSignForSkipInstructions')
	drop procedure dbo.UsePoundSignForSkipInstructions
go
create procedure dbo.UsePoundSignForSkipInstructions
@survey_id int
as
select 1 
from SurveyType st
inner join Survey_def sd on st.SurveyType_id = sd.SurveyType_id 
where survey_id=@survey_id
and st.UsePoundSignForSkipInstructions=1
go
