CREATE procedure QP_Rep_UnitbyService
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id


select su.sampleunit_id, strsampleunit_nm, service 
into #service
from libraryconversion lc, sel_qstns sq, sampleunitsection sus, sampleunit su
where lc.survey_id = @intSurvey_id
and lc.survey_id = sq.survey_id
and lc.qstncore = sq.qstncore
and sq.subtype = 1
and sq.section_id = sus.selqstnssection
and sus.sampleunit_id = su.sampleunit_id
and sq.survey_id = sus.selqstnssurvey_id

select sampleunit_id, strsampleunit_nm, service, count(*)
from #service
group by sampleunit_id, strsampleunit_nm, service
order by sampleunit_id

drop table #service

set transaction isolation level read committed


