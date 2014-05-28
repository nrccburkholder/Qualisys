CREATE procedure qp_rep_survey_status2
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50)
AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intStudy_id int
select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

declare @StartDate datetime, @EndDate datetime
set @StartDate = '8/29/1980'
set @EndDate = GetDate()

if (select count(*) from period where survey_id = @intsurvey_id) > 0
begin
 set @EndDate = (select max(datperioddate) from period where survey_id = @intsurvey_id)
 if (select max(datperioddate) from period where survey_id = @intsurvey_id and datperioddate <> (select max(datperioddate) from period where survey_id = @intsurvey_id)) is not null set @StartDate = (select max(datperioddate) from period where survey_id = @intsurvey_id and datperioddate <> (select max(datperioddate) from period where survey_id = @intsurvey_id))
end

select count(*) as 'Units with a target set'
from sampleplan sp, sampleunit su
where sp.sampleplan_id = su.sampleplan_id
and sp.survey_id = @intsurvey_id
and su.inttargetreturn > 0

set transaction isolation level read committed


