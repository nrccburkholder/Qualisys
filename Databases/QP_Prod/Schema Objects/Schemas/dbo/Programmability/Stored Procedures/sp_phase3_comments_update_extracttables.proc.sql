create procedure sp_phase3_comments_update_extracttables
as

update e
set e.study_id = sd.study_id
from questionform_extract e, questionform qf, survey_def sd
where e.study_id is null
and e.questionform_id = qf.questionform_id
and qf.survey_id = sd.survey_id

update e
set e.study_id = sd.study_id
from comments_extract e, comments c, questionform qf, survey_def sd
where e.study_id is null
and e.cmnt_id = c.cmnt_id
and c.questionform_id = qf.questionform_id
and qf.survey_id = sd.survey_id


