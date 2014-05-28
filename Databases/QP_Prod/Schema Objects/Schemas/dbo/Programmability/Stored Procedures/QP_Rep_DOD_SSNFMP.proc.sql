CREATE procedure QP_Rep_DOD_SSNFMP
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
as
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intStudy_id int, @intSampleSet_id int, @strsql varchar(8000)

select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

set @strsql = 'select ssn, fmp ' +
	' from s'+convert(varchar,@intStudy_id)+'.population p, samplepop sp ' +
	' where sp.sampleset_id='+convert(varchar,@intSampleSet_id)+
	' and sp.pop_id=p.pop_id'

exec (@strsql)

set transaction isolation level read committed


