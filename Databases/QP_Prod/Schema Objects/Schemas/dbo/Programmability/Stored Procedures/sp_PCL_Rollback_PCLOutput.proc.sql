/****** Object:  Stored Procedure dbo.sp_PCL_Rollback_PCLOutput    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure deletes PCLOutput data related to a specific Form Gen  */
/*       batch.         */
/*            */
/* Modified by:  Dan Archuleta - 7/1/1999 - Changed name from sp_FG_Rollback_PCLOutput.  */
/*       - Modified to use joins instead of nested   */      
/*         non-correlated sub-queries.    */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback_PCLOutput
 @FrmGenDate varchar(22)
AS
 DELETE 
  FROM dbo.PCLOutput
   FROM dbo.PCLOutput PO, dbo.SentMailing SM 
    WHERE PO.SentMail_id = SM.SentMail_id  
    AND datGenerated = @FrmGenDate


