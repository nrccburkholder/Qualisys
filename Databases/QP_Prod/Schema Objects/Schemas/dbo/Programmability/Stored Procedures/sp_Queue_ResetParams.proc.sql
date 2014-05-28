/****** Object:  Stored Procedure dbo.sp_Queue_ResetParams    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_ResetParams    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_ResetParams AS
 EXECUTE dbo.sp_Queue_Update_Params 'Bundling', 'numParam_Value', '0'
 EXECUTE dbo.sp_Queue_Update_Params 'Printing', 'numParam_Value', '0'


