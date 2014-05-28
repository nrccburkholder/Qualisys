/****** Object:  Stored Procedure dbo.sp_FG_Rollback_SentMailing    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes SentMailing data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:            */
/************************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback_SentMailing
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.SentMailing
   WHERE datGenerated = @FrmGenDate


