/****** Object:  Stored Procedure dbo.sp_Queue_Printing_RemoveInstan    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Printing_RemoveInstan    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Printing_RemoveInstan 
AS
 DECLARE @PrintingInstances int
 DECLARE @strPrintingInstances varchar(50)
 BEGIN TRANSACTION
 
 EXECUTE dbo.sp_Queue_Printing_NumRunning @PrintingInstances OUTPUT
 IF @PrintingInstances > 0 
  BEGIN 
  
   SELECT @PrintingInstances = @PrintingInstances - 1
   SELECT @strPrintingInstances = CONVERT(varchar(50), @PrintingInstances)
   EXECUTE dbo.sp_Queue_Update_Params 'Printing', 'numParam_Value', @strPrintingInstances
  END 
 COMMIT TRANSACTION


