/****** Object:  Stored Procedure dbo.sp_FG_Rollback_PCLNeeded    Script Date: 7/12/99 10:57:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_FG_Rollback_PCLNeeded    Script Date: 5/17/99 10:59:57 AM ******/
/****************************************************************************************
 * Business Purpose: Used to delete the PCLNeeded records on surveys that are being *
 *       rolled back.         *
 * Created By: Dan Archuleta        *
 * Date Created: 5/17/99        *
 ****************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback_PCLNeeded 
 @FrmGenDate varchar(22)
AS
 DELETE dbo.PCLNeeded
  FROM dbo.PCLNeeded PCLN, dbo.SentMailing SM
   WHERE PCLN.SentMail_id = SM.SentMail_id 
         AND SM.datGenerated = @FrmGenDate


