CREATE procedure SP_JCamp_Queue
as
declare @refreshstart datetime
set @refreshstart = getdate()

truncate table JC_Queue

insert into JC_Queue (Priority_flg, client_id, strclient_nm, study_id, strstudy_nm, survey_id, strsurvey_nm, strmailingstep_nm, quantity)
SELECT sd.priority_flg, c.Client_id, strClient_nm, s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, strMailingStep_nm, COUNT(*)
FROM   Client C (nolock), Study S (nolock), Survey_def SD (nolock), SamplePop SP (nolock), ScheduledMailing SM (nolock), MailingStep MS  (nolock)
WHERE  SP.SamplePop_id = SM.SamplePop_id 
AND SM.SentMail_id IS NULL 
AND SM.datGenerate <= dateadd(day, 1, getdate()) 
AND SD.bitFormGenRelease = 1 
AND MS.MailingStep_id = SM.MailingStep_id 
AND MS.Survey_id = SD.Survey_id 
AND SD.Study_id = S.Study_id 
AND S.Client_id = C.Client_id 
AND SM.ScheduledMailing_id NOT IN 
	(SELECT DISTINCT ScheduledMailing_id 
	FROM FormGenError 
	WHERE ScheduledMailing_id IS NOT NULL) 
GROUP BY sd.priority_flg, c.Client_id, strClient_nm, s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, strMailingStep_nm 
ORDER BY sd.priority_flg, strClient_nm, strStudy_nm, strSurvey_nm, strMailingStep_nm

truncate table JC_QueueUnreleased
insert into JC_QueueUnreleased
select sd.priority_flg, c.client_id, strclient_nm, s.study_id, strstudy_nm, sd.survey_id, strsurvey_nm, strmailingstep_nm, count(*)
from client c (nolock), study s (nolock), survey_def sd (nolock), samplepop sp (nolock), scheduledmailing sm (nolock), mailingstep ms (nolock)
where sp.samplepop_id = sm.samplepop_id 
and sm.sentmail_id is null 
and sm.datgenerate <= dateadd(day,1,getdate())
and sd.bitformgenrelease = 0 
and ms.mailingstep_id = sm.mailingstep_id 
and ms.survey_id = sd.survey_id 
and sd.study_id = s.study_id
and s.client_id = c.client_id
and sm.scheduledmailing_id not in (select distinct scheduledmailing_id from formgenerror
where scheduledmailing_id is not null)
group by sd.priority_flg, c.client_id, strclient_nm, s.study_id, strstudy_nm, sd.survey_id, strsurvey_nm, strmailingstep_nm
order by sd.priority_flg, strclient_nm, strstudy_nm, strsurvey_nm, strmailingstep_nm

update JC_Queue
set [Mailing Type] =  case when strMailingstep_nm like '%postcard%' then 'Postcard' 
			when strmailingstep_nm like 'PC%' then 'Postcard'
			when strmailingstep_nm like '%1st%s%v%y%' then '1st Survey'
			when strmailingstep_nm like '%1st%surv&' then '1st Survey'
			when strMailingstep_nm like '%First%s%v%y%' then '1st Survey'
			when strMailingstep_nm like '%First%surv%' then '1st Survey'
			when strMailingstep_nm like '%2nd%s%v%y%' then '2nd Survey'
			when strMailingstep_nm like '%2nd%surv%' then '2nd Survey'
			when strMailingstep_nm like '%Second%s%v%y%' then '2nd Survey'
			when strMailingstep_nm like '%Second%surv%' then '2nd Survey'
			when strMailingstep_nm like '%prenote%' then 'Prenote'
			when strMailingstep_nm like '%reminder%' then 'Reminder Letter'
			else strMailingstep_nm
		     end

insert into JC_RefreshLog select @RefreshStart, getdate(), 'FGQueue'


