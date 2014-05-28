CREATE PROCEDURE SP_SYS_ExtractStatus    
AS    
    
CREATE TABLE #ExtractStatus (Status INT)    
    
INSERT INTO #ExtractStatus    
EXEC Datamart.QP_Comments.dbo.SP_Extract_Status    
    
IF EXISTS (SELECT * FROM #ExtractStatus WHERE Status=-1)    
--EXEC MASTER.dbo.XP_SendMail @Recipients='msphone@nrcpicker.com;dba@nationalresearch.com', @Subject='Extract Failed'    
EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='QualisysEmail',
	@recipients='msphone@nrcpicker.com;dba@nationalresearch.com',
	@subject='Extract Failed',    
	@body_format='Text',
	@importance='High'
    
DROP TABLE #ExtractStatus


