CREATE PROCEDURE SP_DBM_ScheduleBackup
AS
/*******************************************************************************
Created: 03/22/01
Author:	 Brian Dohmen
Business Purpose: This procedure will set the execution times for
the three morning jobs.  This will clean the individual tables
AND populate bubblepos approximately 1 hour after generation completes
for the night AND then start the backup an hour after the first two 
processes.
Modified: 05/06/2002 BD With the change to generation, we no longer 
use the individual tables.  Therefore, all references of that job have been
removed AND the clean individual tables job has been deleted.
******************************************************************************/
IF (SELECT DATEPART(HOUR,GETDATE()))>=3
    AND (SELECT DATEPART(HOUR,GETDATE()))<=18
  GOTO Completed

DECLARE @strsql VARCHAR(800)
IF (SELECT COUNT(*) FROM PCLNeeded WHERE bitDone=0)>0
  GOTO Finish
ELSE

IF (SELECT COUNT(*) FROM ScheduledMailing schm, MailingStep ms, Survey_Def sd
	WHERE datGenerate<=DATEADD(HOUR,6,GETDATE())
	AND schm.MailingStep_id=ms.MailingStep_id
	AND ms.Survey_id=sd.Survey_id
	AND schm.SentMail_id IS NULL
	AND bitFormGenRelease=1
	AND schm.ScheduledMailing_id  NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError
      WHERE ScheduledMailing_id IS NOT NULL)) > 0
  GOTO Finish
ELSE

IF (SELECT active_start_time FROM msdb.dbo.sysjobschedules WHERE job_id='3DC45114-354D-11D3-87D4-0008C79193B0' AND name='6.x schedule') <> 41500
GOTO Completed

/*creating the time to start the three morning jobs
PCLGEN - sp_pcl_batch_populatepos	3DC45114-354D-11D3-87D4-0008C79193B0
Backup of QP_Prod differential		60E076C8-8168-11D3-87DC-0008C79193B0
Backup of QP_Prod Monday Differential	ABE3F392-177C-11D4-87ED-00104B6751D1
Backup of QP_Prod Saturday Diff		805E3430-C9EB-11D3-87DE-0008C79193B0
@st1 will determine the start time of the first two jobs in the above list.
@st2 will determine the start time of the last three jobs.  This time will always be between midnight AND 4:45am.
*/
DECLARE @genstop INT, @starttime1 VARCHAR(8), @starttime2 VARCHAR(8), @starthour1 VARCHAR(2), 
        @starthour2 VARCHAR(2), @startminute VARCHAR(2)
SELECT @starthour1=CASE DATEPART(HOUR,DATEADD(HOUR,1,GETDATE())) WHEN 24 THEN 0 ELSE DATEPART(HOUR,DATEADD(HOUR,1,GETDATE())) END
SELECT @starthour2=CASE  
     WHEN DATEPART(HOUR,DATEADD(HOUR,2,GETDATE()))>=12 AND DATEPART(HOUR,DATEADD(HOUR,2,GETDATE()))<=24 THEN 0 
     WHEN DATEPART(HOUR,DATEADD(HOUR,2,GETDATE()))=25 THEN 1 
     ELSE DATEPART(HOUR,DATEADD(HOUR,2,GETDATE())) END
SELECT @startminute=DATEPART(MINUTE,GETDATE())
SELECT @startminute=CASE WHEN @startminute='0' THEN '00' ELSE @startminute END
SELECT @starttime1=@starthour1+@startminute+'00'
SELECT @starttime2=@starthour2+@startminute+'00'
--print @starttime1
--print @starttime2

DECLARE @st1 INT, @st2 INT
SELECT @st1=CONVERT(INT,@starttime1)
SELECT @st2=CONVERT(INT,@starttime2)
SELECT @genstop=CONVERT(INT,(@starthour1+@startminute))
--print @st1
--print @st2
--print @genstop

/*Changing the starttime for the "PCLGEN - sp_pcl_batch_populatepos" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="3DC45114-354D-11D3-87D4-0008C79193B0" , @name="6.x schedule" , @active_start_time=' + convert(varchar,@st1)
EXEC (@strsql)

/*Changing the starttime for the "Backup of QP_Prod differential" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="60E076C8-8168-11D3-87DC-0008C79193B0" , @name="Tuesday - Friday 5am" , @active_start_time=' + convert(varchar,@st2)
EXEC (@strsql)

/*Changing the starttime for the "Backup of QP_Prod Monday Differential" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="ABE3F392-177C-11D4-87ED-00104B6751D1" , @name="Monday 5am" , @active_start_time=' + convert(varchar,@st2)
EXEC (@strsql)

/*Changing the starttime for the "Backup of QP_Prod Saturday Diff" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="805E3430-C9EB-11D3-87DE-0008C79193B0" , @name="Every Saturday" , @active_start_time=' + convert(varchar,@st2)
EXEC (@strsql)

SELECT @strsql='UPDATE QualPro_Params SET numParam_Value='+CONVERT(VARCHAR,@genstop)+' WHERE ' +
	' strParam_nm="FormGenStopTime"'
EXEC (@strsql)

SELECT @strsql='UPDATE QualPro_Params SET numParam_Value='+CONVERT(VARCHAR,@genstop)+' WHERE ' +
	' strParam_nm="PCLGenStopTime"'
EXEC (@strsql)

GOTO Completed

Finish:

/*Changing the starttime for the "Backup of QP_Prod Monday Differential" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="ABE3F392-177C-11D4-87ED-00104B6751D1" , @name="Monday 5am" , @active_start_time=50000'
EXEC (@strsql)

/*Changing the starttime for the "Backup of QP_Prod Saturday Diff" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="805E3430-C9EB-11D3-87DE-0008C79193B0" , @name="Every Saturday" , @active_start_time=50000'
EXEC (@strsql)

/*Changing the starttime for the "PCLGEN - sp_pcl_batch_populatepos" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="3DC45114-354D-11D3-87D4-0008C79193B0" , @name="6.x schedule" , @active_start_time=41500'
EXEC (@strsql)

/*Changing the starttime for the "Backup of QP_Prod differential" job*/
SELECT @strsql='msdb.dbo.sp_update_jobschedule @job_id="60E076C8-8168-11D3-87DC-0008C79193B0" , @name="Tuesday - Friday 5am" , @active_start_time=50000'
EXEC (@strsql)

UPDATE QualPro_Params SET numParam_Value=330 WHERE 
strParam_nm='FormGenStopTime'

UPDATE QualPro_Params SET numParam_Value=400 WHERE 
strParam_nm='PCLGenStopTime'

Completed:


