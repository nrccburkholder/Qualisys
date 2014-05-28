CREATE procedure qp_rep_survey_status1
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

select pc.Strpaperconfig_nm as 'Paper Size', count(*) as 'OutGo'
from sentmailing sm, scheduledmailing schm, samplepop sp, sampleset ss, paperconfig pc
where sm.sentmail_id = schm.sentmail_id
and schm.samplepop_id = sp.samplepop_id
and sp.sampleset_id = ss.sampleset_id
and ss.datsamplecreate_dt between @StartDate and @EndDate
and ss.survey_id = @intSurvey_id
and sm.paperconfig_id = pc.paperconfig_id
--and schm.mailingstep_id = ms.mailingstep_id
--and ms.bitsendsurvey = 1
group by pc.strpaperconfig_nm

set transaction isolation level read committed


