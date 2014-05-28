/****** Object:  Stored Procedure dbo.sp_Queue_Printing_AddInstance    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Printing_AddInstance    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Printing_AddInstance
 @IsAdded bit OUTPUT,
 @LastDate varchar(22) OUTPUT
AS
 DECLARE @BundlingRunning bit 
 BEGIN TRANSACTION
 EXECUTE dbo.sp_Queue_BundleStatus @BundlingRunning OUTPUT, @LastDate OUTPUT
 
 IF @BundlingRunning = 1
  SELECT @IsAdded = 0
 ELSE  
  BEGIN
   SELECT @IsAdded = 1
   EXECUTE dbo.sp_Queue_Printing_NewInstance
  END 
 COMMIT TRANSACTION


