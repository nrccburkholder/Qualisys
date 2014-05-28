Create procedure sp_DBASelCutoff
as
select cutoff_id, survey_id, datcutoffdate 
from cutoff
order by survey_id


