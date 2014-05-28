CREATE PROCEDURE qp_rep_EveningGeneration 
 @Associate varchar(50)
AS
set transaction isolation level read uncommitted
DECLARE @intresult integer
DECLARE @strresult varchar(10)
DECLARE @endtime datetime
SET @endtime = getdate() + 1

declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, procedurebegin) select 'Evening Generation', @associate, @procedurebegin

IF DATEPART(HOUR,GETDATE())>5
BEGIN
	UPDATE scheduledmailing 
	SET datGenerate = dateadd(day,-1,datGenerate) 
	WHERE datediff(day, getdate(), datGenerate) = 1
END

PRINT 'This report was created:  ' + convert(varchar(19),getdate())
PRINT ''

PRINT db_name() + ' is available.'
PRINT ''

PRINT 'Surveys that will print.'
SELECT c.Client_id, strClient_nm, s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, strMailingStep_nm, COUNT(*) as Total
FROM   Client C, Study S, Survey_def SD, SamplePop SP, ScheduledMailing SM, MailingStep MS
WHERE  SP.SamplePop_id = SM.SamplePop_id 
   AND SM.SentMail_id IS NULL 
   AND SM.datGenerate <= @endtime
   AND SD.bitFormGenRelease = 1 
   AND MS.MailingStep_id = SM.MailingStep_id 
   AND MS.Survey_id = SD.Survey_id 
   AND SD.Study_id = S.Study_id
   AND S.Client_id = C.Client_id
   AND SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError
      WHERE ScheduledMailing_id IS NOT NULL)
GROUP BY c.Client_id, strClient_nm, s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, strMailingStep_nm
ORDER BY strClient_nm, strStudy_nm, strSurvey_nm, strMailingStep_nm
COMPUTE SUM(COUNT(*))

PRINT ''
SET @intresult = (
 SELECT count(*)
 FROM pclneeded
 WHERE bitdone = 0
)
PRINT 'There are already ' + rtrim(ltrim(str(@intresult))) + ' surveys to be PCLGenerated tonight.'

PRINT 'Generation Parameters:'
select strparam_nm, numparam_value 
from qualpro_params 
where strparam_nm like '%time%' 
order by strparam_nm

select strparam_nm, numparam_value 
from qualpro_params 
where strparam_nm like '%pause%' 
order by strparam_nm

update dashboardlog 
set procedureend = getdate()
where report = 'Evening Generation'
and associate = @associate
and procedurebegin = @procedurebegin
and procedureend is null

set transaction isolation level read committed


