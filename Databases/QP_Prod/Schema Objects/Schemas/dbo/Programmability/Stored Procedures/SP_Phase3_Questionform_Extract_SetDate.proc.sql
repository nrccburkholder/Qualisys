CREATE procedure SP_Phase3_Questionform_Extract_SetDate
as

update qe
set qe.datextracted_dt = getdate()
from questionform_extract qe, questionform_extract_work qew
where qe.questionform_id = qew.questionform_id
and qe.datextracted_dt is null
and qe.tiextracted = 1


