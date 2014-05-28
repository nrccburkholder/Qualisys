/****** Object:  Stored Procedure dbo.sp_Queue_BundleStatus    Script Date: 7/15/99 3:57:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_BundleStatus    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_BundleStatus 
 @IsRunning bit OUTPUT,
 @LastBundleTime varchar(50) = '' OUTPUT
AS
 SELECT @IsRunning = numParam_value,
  @LastBundleTime = CONVERT(varchar(50), datParam_value)
  FROM dbo.QualPro_params
   WHERE strParam_nm = 'Bundling'
   AND strParam_grp = 'QueueManager'


