create procedure QP_Rep_UnenteredComments
@BeginDate datetime,
@EndDate datetime
as
set transaction isolation level read uncommitted
set nocount on
select distinct survey_id 
into #SurveysWithComments
from sel_qstns
where subtype = 4
and height > 0

select qf.survey_id, count(*) as Returns
into #ExpectedComments
from questionform qf, #SurveysWithComments swc
where datreturned between @BeginDate and @EndDate
and qf.survey_id = swc.survey_id
group by qf.survey_id
having count(*) > 10

select distinct survey_id 
into #Comments
from comments c, questionform qf
where c.questionform_id = qf.questionform_id
and datentered between @BeginDate and @EndDate

set nocount off

select cl.strclient_nm, cl.client_id, s.strstudy_nm, s.study_id, sd.strsurvey_nm, sd.survey_id, ec.returns
from client cl, study s, survey_def sd, #ExpectedComments ec left outer join #Comments c on ec.survey_id = c.survey_id
where c.survey_id is null
and ec.survey_id = sd.survey_id
and sd.study_id = s.study_id
and s.client_id = cl.client_id
and ec.survey_id not in (select distinct survey_id from commentskipsurveys)
order by cl.strclient_nm, s.strstudy_nm, sd.strsurvey_nm

drop table #SurveysWithComments
drop table #ExpectedComments
drop table #Comments

set transaction isolation level read committed


