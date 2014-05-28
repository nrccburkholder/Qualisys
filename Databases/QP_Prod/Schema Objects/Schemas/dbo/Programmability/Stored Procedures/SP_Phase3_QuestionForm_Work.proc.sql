create procedure SP_Phase3_QuestionForm_Work @study int
as
truncate table questionform_extract_work

insert into questionform_extract_work
select top 100 questionform_id
from questionform_extract
where study_id = @study
and datextracted_dt is null
and tiextracted = 1


