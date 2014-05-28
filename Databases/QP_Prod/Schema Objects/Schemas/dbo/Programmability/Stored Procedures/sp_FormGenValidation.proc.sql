/****** Object:  Stored Procedure dbo.sp_FormGenValidation    Script Date: 8/27/99 1:07:18 PM ******/
/****** Object:  Stored Procedure dbo.sp_FormGenValidation    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: Check the validity of the FormGen batch, and rollback errors if necessary. */
/*            */
/* Modifications:  7/12/99 - Dan Archuleta - Changed the Reference to sp_FGE_CleanUpErrors to */
/*          sp_FG_CleanUpErrors.    */
/* 9/29/1999 DV - The OrphanCodeTag check will now be done in PCLGen, since it can handle */
/* searching for the strings better.       */
/************************************************************************************************/
CREATE PROCEDURE sp_FormGenValidation 
 @FrmGenDate varchar(22) 
AS
 DECLARE @FG_Time datetime
 SELECT @FG_Time = CONVERT(datetime, @FrmGenDate)
 EXECUTE dbo.sp_FGE_QuestionExists @FG_Time
 EXECUTE dbo.sp_FGE_ScalesExist @FG_Time
 EXECUTE dbo.sp_FGE_TextBoxExists @FG_Time
/* EXECUTE dbo.sp_FGE_OrphanCodeTag @FG_Time*/
 EXECUTE dbo.sp_FG_CleanUpErrors @FrmGenDate


