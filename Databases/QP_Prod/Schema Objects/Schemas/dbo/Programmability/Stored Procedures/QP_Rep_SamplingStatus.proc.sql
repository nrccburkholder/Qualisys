CREATE procedure QP_Rep_SamplingStatus @associate varchar(42), @client varchar(42), @study varchar(42), @survey varchar(42)
as
set transaction isolation level read uncommitted
set nocount on

exec SP_Teams_SamplingStatus

declare @studyid int, @surveyid int, @empid int, @strsql varchar(8000), @where varchar(2000)

set @empid = (select employee_id from employee where strntlogin_nm = @associate)

set @strsql = 'select tss.* from teamstatus_sampling tss, client c, study s, survey_def sd, study_employee se '

if @client = '_all' 
goto allclients

if (select count(*) from teamstatus_sampling where client = @client) < 1
goto novalues

if @study = '_all' 
goto allstudies

if @survey = '_all' 
goto allsurveys

set @surveyid = (select sd.survey_id
from client c, study s, survey_def sd
where c.strclient_nm = @client
and c.client_id = s.client_id
and s.strstudy_nm = @study
and s.study_id = sd.study_id
and sd.strsurvey_nm = @survey)

set @where = 'where tss.survey_id = ' + convert(varchar,@surveyid) +
	' and tss.survey_id = sd.survey_id ' +
	' and sd.study_id = s.study_id ' +
	' and s.client_id = c.client_id ' + 
	' and s.study_id = se.study_id ' +
	' and se.employee_id = ' + convert(varchar,@empid)

goto final

allclients:

set @where = 'where tss.survey_id = sd.survey_id ' +
	' and sd.study_id = s.study_id ' +
	' and s.client_id = c.client_id ' +
	' and s.study_id = se.study_id ' +
	' and se.employee_id = ' + convert(varchar,@empid)

goto final

allstudies:

set @where = 'where tss.survey_id = sd.survey_id ' +
	' and sd.study_id = s.study_id ' +
	' and s.client_id = c.client_id ' + 
	' and s.study_id = se.study_id ' +
	' and c.strclient_nm = ''' + convert(varchar,@client) + '''' +
	' and se.employee_id = ' + convert(varchar,@empid)

goto final

allsurveys:

set @studyid = (select s.study_id
from client c, study s
where c.strclient_nm = @client
and c.client_id = s.client_id
and s.strstudy_nm = @study)

set @where = 'where tss.survey_id = sd.survey_id ' +
	' and tss.survey_id = sd.survey_id ' +
	' and sd.study_id = s.study_id ' +
	' and s.client_id = c.client_id ' + 
	' and s.study_id = se.study_id ' +
	' and s.study_id = ' + convert(varchar,@studyid) +
	' and se.employee_id = ' + convert(varchar,@empid)

goto final

novalues:

set @where = ' where study_id is null'
set @strsql = 'select client from teamstatus_sampling '

final:

set @strsql = @strsql + @where + ' order by client, study, survey' 

--print @strsql

exec (@strsql)

set transaction isolation level read committed


