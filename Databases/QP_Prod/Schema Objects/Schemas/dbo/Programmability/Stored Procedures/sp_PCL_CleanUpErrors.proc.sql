/****** Object:  Stored Procedure dbo.sp_PCL_CleanUpErrors    Script Date: 7/12/99 10:57:14 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure calls all the sp_PCL_CleanUpErrors procedures to rollback   */
/*       PCLGen data that was generated but errored as identified in FormGenError. */
/*            */
/* Date Created:  7/12/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_CleanUpErrors
 @FrmGenDate varchar(22)
AS

if exists (select * from dbo.formgenerror where datgenerated = @frmgendate)
begin
 EXECUTE dbo.sp_PCL_Clean_BubbleLoc @FrmGenDate
 EXECUTE dbo.sp_PCL_Clean_CommentLoc @FrmGenDate
 EXECUTE dbo.sp_PCL_Clean_PCLResults @FrmGenDate
 EXECUTE dbo.sp_PCL_Clean_PCLQuestionFrm @FrmGenDate
-- EXECUTE dbo.sp_PCL_Clean_BubblePos @FrmGenDate
-- EXECUTE dbo.sp_PCL_Clean_BubbleItemPos @FrmGenDate
-- EXECUTE dbo.sp_PCL_Clean_CmtLinePos @FrmGenDate
-- EXECUTE dbo.sp_PCL_Clean_CommentPos @FrmGenDate 
 EXECUTE dbo.sp_PCL_Clean_PCLOutput @FrmGenDate
 EXECUTE dbo.sp_PCL_Clean_PCLGenLog @FrmGenDate
end


