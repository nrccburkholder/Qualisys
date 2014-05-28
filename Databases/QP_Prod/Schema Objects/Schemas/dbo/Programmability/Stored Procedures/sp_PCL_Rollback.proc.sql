/****** Object:  Stored Procedure dbo.sp_PCL_Rollback    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure calls all the sp_PCL_rollback procedures to rollback   */
/*       PCLGen data related to a specific Form Gen batch.    */
/*            */
/* Date Created:  7/1/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_Rollback
 @FrmGenDate varchar(22)
AS
 EXECUTE dbo.sp_PCL_Rollback_BubbleLoc @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_CommentLoc @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_PCLResults @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_PCLQuestionFrm @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_BubblePos @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_BubbleItemPos @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_CmtLinePos @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_CommentPos @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_PCLOutput @FrmGenDate
 EXECUTE dbo.sp_PCL_Rollback_PCLGenLog @FrmGenDate


