CREATE procedure QP_Rep_TargetInfo
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @FirstPeriod datetime,
 @LastPeriod datetime
as 
set transaction isolation level read uncommitted
Declare @intSurvey_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select sampleunit_id, strsampleunit_nm, target, returns, perioddate
from targetinfo 
where survey_id = convert(varchar,@intsurvey_id) 
and convert(char(19),perioddate,120) >= convert(char(19),@firstperiod,120)
and convert(char(19),perioddate,120) <= convert(char(19),@lastperiod,120)
order by perioddate, strsampleunit_nm

set transaction isolation level read committed


