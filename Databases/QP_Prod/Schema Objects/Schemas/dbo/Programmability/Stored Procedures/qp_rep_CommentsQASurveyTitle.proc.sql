CREATE procedure qp_rep_CommentsQASurveyTitle
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @StartDate datetime,
 @EndDate datetime
as
set transaction isolation level read uncommitted

declare @SQL varchar(500)--, @survey_id int, @startdate datetime, @enddate datetime
--set @intsurvey_id = 1441
--set @startdate = '4/25/02'
--set @enddate = '4/26/02'

Declare @intSurvey_id int, @intStudy_id int
select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select convert(char(10),@startdate,101) + ' to ' + convert(char(10),@enddate,101) as 'Comments Keyed From:'
set transaction isolation level read committed


