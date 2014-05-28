/****** Object:  Stored Procedure dbo.sp_Queue_Bundling_UnLock    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Bundling_UnLock    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Bundling_UnLock
AS
 EXECUTE dbo.sp_Queue_Update_Params 'Bundling', 'numParam_Value', '0'


