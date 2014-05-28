/****** Object:  Stored Procedure dbo.sp_Queue_Bundle    Script Date: 11/4/2004 3:31:39 PM ******/


/****** Object:  Stored Procedure dbo.sp_Queue_Bundle    Script Date: 7/15/99 3:57:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Bundle    Script Date: 7/15/99 10:03:50 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: Executes bundling.          */
/*            */
/* Parameters: - @Status (Output Parameter)       */
/*      - Return Values:        */
/*    - 1: Cannot bundle because bundling is running in another process */
/*    - 2: Cannot bundle because printing is running in another process */
/*    - 3: Cannot bundle because PCLGen is running in another process (DG 12/9/1999) */
/*    - 0: Bundling Ran Successfully      */
/*            */
/* Date Created:  7/13/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/* Modified:  3/14/02  -Felix Gomez                */
/* Added @strPclOutput         */
/*            */
/************************************************************************************************/
CREATE  PROCEDURE sp_Queue_Bundle 
 @Status int OUTPUT, @strPclOutput varchar(30) = 'dbo.pcloutput'
AS
 DECLARE @IsBundlingRunning bit
 DECLARE @IsPrintingRunning bit
 DECLARE @IsPCLGenRunning bit
 BEGIN TRANSACTION
 EXECUTE dbo.sp_Queue_BundleStatus @IsBundlingRunning OUTPUT
 EXECUTE dbo.sp_Queue_PrintStatus @IsPrintingRunning OUTPUT
 EXECUTE dbo.sp_Queue_PCLGenStatus @IsPCLGenRunning OUTPUT
 IF @IsBundlingRunning = 1
  BEGIN
   SELECT @Status = 1
   COMMIT TRANSACTION
  END
 ELSE IF @IsPrintingRunning = 1
  BEGIN
   SELECT @Status = 2
   COMMIT TRANSACTION
  END
 ELSE IF @IsPCLGenRunning = 1
  BEGIN
   SELECT @Status = 3
   COMMIT TRANSACTION
  END
 ELSE 
  BEGIN
   SELECT @Status = 0
   EXECUTE dbo.sp_Queue_Bundling_Lock
   COMMIT TRANSACTION
  
   EXECUTE dbo.sp_Queue_BundleUp --@strPclOutput
   BEGIN TRANSACTION
   EXECUTE dbo.sp_Queue_Bundling_LogTime
   EXECUTE dbo.sp_Queue_Bundling_UnLock
  
   COMMIT TRANSACTION     
  END


