CREATE PROCEDURE SP_DBM_SurveyStatus2
AS

truncate table surveystatus

insert into surveystatus (survey_id, projectnumber, samplesinperiod, sampleset_id, datsamplecreate_dt)
select sd.survey_id, left(strsamplesurvey_nm,4), intsamplesinperiod, sampleset_id, datsamplecreate_dt
from survey_def sd, sampleset s
where sd.survey_id = s.survey_id

select ss.sampleset_id, min(datmailed) as datmailed, count(*) as cnt into #mailed from sampleset ss, samplepop sp, scheduledmailing sc, sentmailing sm
where ss.sampleset_id = sp.sampleset_id
and sp.samplepop_id = sc.samplepop_id
and sc.sentmail_id = sm.sentmail_id
group by ss.sampleset_id

--select * from #mailed

update ss set ss.datmailed = t.datmailed, numsampled = cnt 
from surveystatus ss, #mailed t
where ss.sampleset_id = t.sampleset_id

insert into surveystatus (survey_id, projectnumber, cutoff_id, datcutoffstart_dt, datcutoffstop_dt, numexported)
select c.survey_id, left(strsamplesurvey_nm,4), c.cutoff_id, datcutoffstart_dt, datcutoffstop_dt, count(*)
from cutoff c, questionform qf, survey_def sd, sampleset s, samplepop sp
where c.cutoff_id = qf.cutoff_id
and qf.survey_id = sd.survey_id
and qf.samplepop_id = sp.samplepop_id
and sp.sampleset_id = s.sampleset_id
group by c.survey_id, left(strsamplesurvey_nm,4), c.cutoff_id, datcutoffstart_dt, datcutoffstop_dt

drop table #mailed


