/****** Object:  Stored Procedure dbo.sp_Queue_Printing_NumRunning    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Printing_NumRunning    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Printing_NumRunning 
 @Instances int OUTPUT
AS
 SELECT @Instances = numParam_value
  FROM dbo.QualPro_params
   WHERE strParam_nm = 'Printing'
   AND strParam_grp = 'QueueManager'


