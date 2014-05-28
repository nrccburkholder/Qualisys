/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_PCLGenLog    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes PCLGenLog data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:  Dan Archuleta - 7/1/1999 - Changed name from sp_FG_Rollback_PCLGenLog.  */
/*       - Modified to use joins instead of nested   */      
/*         non-correlated sub-queries.    */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_PCLGenLog
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.PCLGenLog
   FROM dbo.PCLGenLog PGL, dbo.SentMailing SM
    WHERE PGL.SentMail_id = SM.SentMail_id    AND SM.datgenerated = @FrmGenDate


