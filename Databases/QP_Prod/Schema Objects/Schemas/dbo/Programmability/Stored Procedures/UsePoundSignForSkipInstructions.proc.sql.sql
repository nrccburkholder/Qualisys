create procedure dbo.UsePoundSignForSkipInstructions
@survey_id int
as
select 1 
from SurveyType st
inner join Survey_def sd on st.SurveyType_id = sd.SurveyType_id 
where survey_id=@survey_id
and st.UsePoundSignForSkipInstructions=1