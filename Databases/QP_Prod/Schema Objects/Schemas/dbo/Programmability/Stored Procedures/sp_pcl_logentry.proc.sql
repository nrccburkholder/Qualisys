/* This procedure will allows PCLGen to identify batch runs by adding the log entry */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
CREATE PROCEDURE sp_pcl_logentry
 @pclgenrun_id int,
 @logentry varchar(100),
 @survey_id int,
 @sentmail_id int
AS
 INSERT INTO dbo.PCLGenLog (
  PCLGenRun_id, LogEntry, Survey_id, SentMail_id, datlogged
 ) VALUES (
  @pclgenrun_id, @logentry, @survey_id, @sentmail_id, getdate()
 )


