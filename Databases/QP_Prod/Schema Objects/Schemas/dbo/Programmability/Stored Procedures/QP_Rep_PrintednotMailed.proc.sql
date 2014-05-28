CREATE procedure QP_Rep_PrintednotMailed
@associate varchar(50),
@startdate varchar(20)
as
set transaction isolation level read uncommitted
set nocount on
declare @strsql varchar(8000)

if convert(datetime, @startdate) > getdate()
begin
  create table #display (Display varchar(200))
  insert into #Display
	select 'How can we analyze the future?'
   select * from #Display
   drop table #Display
   goto done
end

-- if convert(datetime, @startdate) > dateadd(day, -2,getdate())
-- begin
--   create table #Display2 (Display varchar(200))
--   insert into #Display2
-- 	select 'It is not prudent to analyze anything that is less than 2 days old.'
--    select * from #Display2
--    drop table #Display2
--    goto done
-- end

set @strsql = 'create table #queue (employee varchar(20), ClientName varchar(42), StudyName varchar(42), SurveyName varchar(42), ' +
	' survey_id int, datprinted datetime, datbundled datetime, ' +
	' mailingstep varchar(20), numprinted int, sampleset int, sampledate datetime) ' +

	' insert into #queue (clientname, studyname, surveyname, survey_id, datprinted, datbundled, mailingstep, numprinted, sampleset) ' +
	' select c.strclient_nm, s.strstudy_nm, sd.strsurvey_nm, sd.survey_id, convert(varchar(10),datprinted,120), datbundled, ' +
	' strmailingstep_nm, count(*), sampleset_id ' +
	' from sentmailing sm, survey_def sd, samplepop sp, scheduledmailing schm, mailingstep ms, study s, client c ' +
	' where sm.datmailed is null ' +
-- 	' and sm.datprinted >''' + @startdate + ''' and dateadd(day, -2, getdate()) ' +
	' and sm.datprinted >''' + @startdate + ''' ' +
	' and sm.sentmail_id = schm.sentmail_id ' +
	' and schm.samplepop_id = sp.samplepop_id ' +
	' and ms.mailingstep_id = schm.mailingstep_id ' +
	' and ms.survey_id = sd.survey_id ' +
	' and sd.study_id = s.study_id ' +
	' and s.client_id = c.client_id ' +
	' group by c.strclient_nm, s.strstudy_nm, sd.strsurvey_nm, sd.survey_id, convert(varchar(10),datprinted,120), datbundled, strmailingstep_nm, sampleset_id ' +
	' order by c.strclient_nm, s.strstudy_nm, sd.strsurvey_nm, sd.survey_id, convert(varchar(10),datprinted,120), datbundled, strmailingstep_nm, sampleset_id ' +

	' update q set employee = strntlogin_nm from #queue q, survey_def sd, study s, employee e ' +
	' where q.survey_id = sd.survey_id and sd.study_id = s.study_id and s.ademployee_id = e.employee_id ' +

	' update q set sampledate = datsamplecreate_dt from #queue q, sampleset ss ' +
	' where q.sampleset = ss.sampleset_id ' +

	' select employee, ClientName, StudyName, SurveyName, survey_id, datprinted, datbundled, mailingstep, numprinted, sampledate ' +
	' from #queue ' +

	' drop table #queue '

exec (@strsql)

done:

set transaction isolation level read committed


