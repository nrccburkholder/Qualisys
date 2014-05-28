CREATE PROCEDURE QCL_SetNextGeneration @batchsize INT = NULL          
AS          
/* This procedure will set the next datgenerate for item in the NextMailingStep table.          
*/          
DECLARE @rowsupdated INT, @rowsupdated1 INT          
DECLARE @SQL VARCHAR(300)          
 IF NOT EXISTS (SELECT * FROM NextMailingStep WHERE datUpdated IS NULL)          
 RETURN          
          
--Remove duplicate records          
BEGIN TRAN          
          
SELECT nextscheduledmailing_id          
INTO #dup          
FROM nextmailingstep          
GROUP BY nextscheduledmailing_id          
HAVING COUNT(*) > 1          
          
IF @@ERROR > 0          
BEGIN          
 ROLLBACK TRAN          
 RETURN          
END          
          
SELECT t.nextscheduledmailing_id, MIN(mailingstep_id) mailingstep_id          
INTO #del          
FROM nextmailingstep n, #dup t          
WHERE t.nextscheduledmailing_id = n.nextscheduledmailing_id          
GROUP BY t.nextscheduledmailing_id          
          
IF @@ERROR > 0          
BEGIN          
 ROLLBACK TRAN          
 RETURN          
END          
          
DELETE n          
FROM #del t, nextmailingstep n          
WHERE t.nextscheduledmailing_id = n.nextscheduledmailing_id          
AND t.mailingstep_id = n.mailingstep_id          
          
IF @@ERROR > 0          
BEGIN          
 ROLLBACK TRAN          
 RETURN          
END          
          
COMMIT TRAN          
          
          
BEGIN TRANSACTION          
DELETE          
FROM NextMailingStep          
WHERE not exists (SELECT * FROM scheduledmailing WHERE NextScheduledMailing_id = ScheduledMailing_id)          
COMMIT TRANSACTION          
          
 IF @batchSize IS NULL           
    BEGIN          
 BEGIN TRANSACTION          
 UPDATE sm          
 SET    datgenerate = nextdatgenerate          
 FROM   NextMailingStep nms, ScheduledMailing sm          
 WHERE  ScheduledMailing_id = NextScheduledMailing_id          
 AND    datUpdated IS NULL          
           
 SELECT @rowsupdated = @@ROWCOUNT          
          
 SELECT @rowsupdated1 = COUNT(*) FROM NextMailingStep WHERE datUpdated IS NULL          
          
 --Track the counts by paperconfig, integrated for operations          
 EXEC QP_Operations_MailPagesbyDay           
          
 UPDATE NextMailingStep           
 SET    datUpdated = GETDATE()          
 WHERE  datUpdated IS NULL          
    END          
 ELSE          
    BEGIN          
 CREATE TABLE #NextMailingStep(NextScheduledMailing_id INT, NextDatGenerate DATETIME)          
 SET @SQL = 'INSERT INTO #NextMailingStep SELECT TOP '+CONVERT(VARCHAR(10), @batchsize)+' NextScheduledMailing_id, NextDatGenerate FROM NextMailingStep WHERE datUpdated IS NULL'          
          
        EXEC (@SQL)          
 BEGIN TRANSACTION          
 UPDATE sm          
 SET    datgenerate = nextdatgenerate          
 FROM   #NextMailingStep tnms, ScheduledMailing sm          
 WHERE  ScheduledMailing_id = NextScheduledMailing_id          
          
 SELECT @rowsupdated = @@ROWCOUNT          
          
 --Track the counts by paperconfig, integrated for operations          
 EXEC QP_Operations_MailPagesbyDay           
           
 UPDATE nms          
 SET    datUpdated = GETDATE()          
 FROM   NextMailingStep nms, #NextMailingStep tnms          
 WHERE  tnms.NextScheduledMailing_id = nms.NextScheduledMailing_id          
           
 SELECT @rowsupdated1 = @@ROWCOUNT          
    END          
          
 IF @rowsupdated <> @rowsupdated1          
    BEGIN          
 ROLLBACK TRANSACTION          
--EXEC master.dbo.xp_sendmail @recipients = 'QualisysDBAEmailAlerts@NationalResearch.com', @subject = 'No mail dates were set.', @message = 'Check for duplicate nextscheduledmailing_id`s in nextmailingstep'          
--new code needed for SQL Server 2008 upgrade  

declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
declare @vsubject nvarchar(255)
exec qp_prod.dbo.sp_getemailsubject 'No mail dates were set.',@country, @environment, 'Qualisys', @osubject=@vsubject output

EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',  
@recipients='itsoftwareengineeringlincoln@nationalresearch.com',  
@subject=@vsubject,  
@body='Check for duplicate nextscheduledmailing_id`s in nextmailingstep',  
@body_format='Text',  
@importance='High'  
  
  
RETURN          
    END          
 COMMIT TRANSACTION


