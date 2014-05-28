/****** Object:  Stored Procedure dbo.sp_Queue_Printing_NewInstance    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Printing_NewInstance    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Printing_NewInstance
AS
 DECLARE @PrintingInstances int
 DECLARE @strPrintingInstances varchar(50)
 EXECUTE dbo.sp_Queue_Printing_NumRunning @PrintingInstances OUTPUT
 SELECT @PrintingInstances = @PrintingInstances + 1
 SELECT @strPrintingInstances = CONVERT(varchar(50), @PrintingInstances)
 EXECUTE dbo.sp_Queue_Update_Params 'Printing', 'numParam_Value', @strPrintingInstances


