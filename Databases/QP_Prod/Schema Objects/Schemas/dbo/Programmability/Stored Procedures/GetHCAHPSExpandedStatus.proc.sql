-- =============================================
-- Author:		<Dana Petersen>
-- Create date: <12/27/2012>
-- Description:	<Provides list of active surveys that do not have the 5 questions for the
--				HCAHPS Expanded Survey>
-- =============================================
CREATE PROCEDURE GetHCAHPSExpandedStatus 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


select c.strclient_nm, c.client_id, s.strstudy_nm, s.study_id, sd.strsurvey_nm, sd.survey_id
into #css 
from client c, study s, survey_def sd
where c.client_id = s.client_id
and s.study_id = sd.study_id
and sd.surveytype_id = 2
and c.active = 1 and s.active = 1 and sd.active = 1
and c.client_id not in (5,1364,1285)
and s.strstudy_nm not like 'x%'
and sd.strsurvey_nm not like 'x%'

select css.survey_id, count(*) as "count5"
into #haveqs
from #css css, sel_qstns sq
where css.survey_id = sq.survey_id
and sq.qstncore in (46863,46864,46865,46866,46867)
and sq.language = 1
group by css.survey_id
having count(*) = 5

select css.*, 
case when h.survey_id is null then 'N'
else 'Y'
end as "Expanded"
from #css css
left outer join #haveqs h
on h.survey_id = css.survey_id


END


