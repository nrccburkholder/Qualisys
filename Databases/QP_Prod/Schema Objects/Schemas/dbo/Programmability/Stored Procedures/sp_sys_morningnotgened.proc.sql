CREATE procedure sp_sys_morningnotgened
as
select strclient_nm as Client, strsurvey_nm as Survey, sd.survey_id as Survey_ID, strmailingstep_nm as MailingStep, count(*) as cnt
into ##notgened
from scheduledmailing schm, mailingstep ms, survey_def sd, study s, client c
where convert(varchar(10),datgenerate,120) <= dateadd(d,-1,getdate())
and schm.mailingstep_id = ms.mailingstep_id
and ms.survey_id = sd.survey_id
and schm.sentmail_id is null
and bitformgenrelease = 1
and sd.study_id = s.study_id
and s.client_id = c.client_id
group by strclient_nm, strsurvey_nm, sd.survey_id, strmailingstep_nm
order by strclient_nm, strsurvey_nm, sd.survey_id, strmailingstep_nm

if (select count(*) from ##notgened) > 0
 Begin
	--exec master.dbo.xp_sendmail @recipients = 'bdohmen',
	--@subject = 'Morning Generation Exception Report',
	--@dbuse = 'QP_Prod',
	--@query = 'select * from ##notgened compute sum(cnt)',
	--@width = 160,
	--@attach_results = 'true'


	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='QualisysEmail',
	@recipients='dba@nationalresearch.com',
	@subject='Morning Generation Exception Report',
	@body='Listing of all Surveys not generated.',
	@body_format='Text',
	@importance='High',
	@execute_query_database = 'qp_prod',
	@attach_query_result_as_file = 1,
	@Query='select * from ##notgened compute sum(cnt)'

 End

drop table ##notgened


