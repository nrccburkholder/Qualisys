/****** Object:  Stored Procedure dbo.sp_Queue_PrintStatus    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_PrintStatus    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_PrintStatus 
 @IsRunning bit OUTPUT
AS
 DECLARE @PrintCount int
 SELECT @PrintCount = numParam_value
  FROM dbo.QualPro_params
   WHERE strParam_nm = 'Printing'
   AND strParam_grp = 'QueueManager'
 IF @PrintCount = 0 
  SELECT @IsRunning = 0
 ELSE
  SELECT @IsRunning = 1


