CREATE PROCEDURE QP_Rep_StudyStatus
   @Associate varchar(50), 
   @Client varchar(50), 
   @Study varchar(50), 
   @Survey varchar(50), 
   @Days int

AS
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intStudy_id int, @strsql varchar(8000), @criteria varchar(255)


select @criteria = case
   when @Client = '_ALL' then
      'and s.study_id in (select study_id from study_employee where employee_id = ' + 
      (select convert(varchar(10),employee_id) from employee where strntlogin_nm = @associate) + ')'
   when @Study = '_ALL' then
      'and s.client_id = ' +
      (select convert(varchar(10),client_id) from client where strclient_nm = @client)
   when @Survey = '_ALL' then
      'and sd.study_id = ' +
      (select convert(varchar(10),study_id) from client c, study s where c.client_id = s.client_id and strclient_nm = @client and strstudy_nm = @study)
   else
      'and sd.survey_id = ' +
      (select convert(varchar(10),survey_id) from client c, study s, survey_def sd where c.client_id = s.client_id and s.study_id = sd.study_id and strclient_nm = @client and strstudy_nm = @study and strsurvey_nm = @survey)
end

set @strsql = '(select strclient_nm, strstudy_nm, strsurvey_nm, ss.sampleset_id, 0 as intsequence, "Sample" as step, datsamplecreate_dt as step_date, count(*) as cnt ' +
	'from client c, study s, survey_def sd, samplepop sp, sampleset ss ' +
	'where ss.survey_id = sd.survey_id ' +
	'and sd.study_id = s.study_id ' +
	'and s.client_id = c.client_id ' +
	'and sp.sampleset_id = ss.sampleset_id ' +
	@criteria +
	'and datediff(day,datsamplecreate_dt,getdate()) < ' + convert(char(5),@days) +
	'group by strclient_nm, strstudy_nm, strsurvey_nm, ss.sampleset_id, datsamplecreate_dt) ' +
	'union ' +
	'(select strclient_nm, strstudy_nm, strsurvey_nm, ss.sampleset_id, intsequence, strmailingstep_nm as step, datmailed as step_date, count(*) as cnt ' +
	'from client c, study s, survey_def sd, mailingstep ms, samplepop sp, sampleset ss, scheduledmailing schm, sentmailing sm ' +
	'where schm.mailingstep_id = ms.mailingstep_id ' +
	'and ms.survey_id = sd.survey_id ' +
	'and sd.study_id = s.study_id ' +
	'and s.client_id = c.client_id ' +
	'and schm.samplepop_id = sp.samplepop_id ' +
	'and sp.sampleset_id = ss.sampleset_id ' +
	'and schm.sentmail_id = sm.sentmail_id ' +
	@criteria +
	'and datediff(day,datsamplecreate_dt,getdate()) < ' + convert(char(5),@days) +
	'group by strclient_nm, strstudy_nm, strsurvey_nm, ss.sampleset_id, intsequence, strmailingstep_nm, datmailed) ' +
	'order by strclient_nm, strstudy_nm, strsurvey_nm, ss.sampleset_id, intsequence'

exec (@strsql)

set transaction isolation level read committed


