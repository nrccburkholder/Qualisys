CREATE PROCEDURE [dbo].[sp_DBM_CommentsExtractStatus]  @SendTo NVARCHAR(100)
AS      
      
--SET ANSI_DEFAULTS ON      
    
DECLARE @Job_id uniqueidentifier
SELECT @Job_id = job_id FROM datamart.msdb.dbo.sysjobs WHERE name = 'Extract'

SELECT TOP 10 Step_id, Run_Status, Run_Date, Run_Time, Run_Duration, Step_Name, Message       
INTO ##emailkdkdkd      
FROM datamart.MSDB.DBO.sysjobhistory       
--WHERE Job_id = 'FB12142B-A548-4759-9753-3781D348AE5E'    
WHERE Job_id = @Job_id
ORDER BY Instance_id DESC      
      
      EXEC Master.dbo.xp_SendMail       
         @Recipients = @SendTo,      
         @Subject = 'Comments Extract',      
         @Attach_Results = 'True',      
         @DBUse = 'MSDB',      
         @Width = 700,      
         @Query = 'SELECT * FROM ##emailkdkdkd'      
      
DROP TABLE ##emailkdkdkd      
      
IF (SELECT COUNT(*) FROM datamart.QP_Comments.DBO.UpdateBackGroundInfo_Log WHERE Attempted=1)>0      
BEGIN      
      
      EXEC Master.dbo.xp_SendMail       
  @Recipients=@SendTo,      
  @Subject='Background Info Errors on DATAMART'      
END


