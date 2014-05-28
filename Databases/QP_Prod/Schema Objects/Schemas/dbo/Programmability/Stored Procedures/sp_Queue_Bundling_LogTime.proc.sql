/****** Object:  Stored Procedure dbo.sp_Queue_Bundling_LogTime    Script Date: 7/15/99 3:57:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Bundling_LogTime    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Bundling_LogTime
AS
 DECLARE @BundlingTime varchar(24)
 
 SELECT @BundlingTime = GETDATE()
 EXECUTE dbo.sp_Queue_Update_Params 'Bundling', 'datParam_Value', @BundlingTime


