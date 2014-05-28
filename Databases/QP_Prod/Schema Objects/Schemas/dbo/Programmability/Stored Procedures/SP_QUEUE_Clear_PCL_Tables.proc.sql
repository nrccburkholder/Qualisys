create procedure SP_QUEUE_Clear_PCL_Tables
as

select distinct survey_id
into #survey
from pclneeded

delete p
from pcl_logo p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null

delete p
from pcl_scls p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null

delete p
from pcl_skip p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null

delete p
from pcl_pcl p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null

delete p
from pcl_cover p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null

delete p
from pcl_textbox p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null

delete p
from pcl_qstns p left outer join #survey s
on p.survey_id = s.survey_id
where s.survey_id is null


