/****** Object:  Stored Procedure dbo.sp_FG_Rollback    Script Date: 7/12/99 10:57:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_FG_Rollback    Script Date: 4/26/99 9:19:51 AM ******/
/************************************************************************************************/
/* Business Purpose: This procedure calls all the sp_fg_rollback procedures to rollback a  */
/*       Form Gen batch.        */            
/*            */
/* Modified by:  Dan Archuleta - 5/17/1999        */
/*            */
/* Modified by:  Daniel Vansteenburg - 5/5/1999       */
/*            */
/* Modified by:  Dan Archuleta - 7/1/1999 - Removed the PCL Gen rollback procedures.  */
/************************************************************************************************/
CREATE PROCEDURE sp_FG_Rollback
 @FrmGenDate varchar(22)
AS
-- EXECUTE dbo.sp_FG_Rollback_IndivTables @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback_SchedMail @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback_QuesForm @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback_Update_SchMail @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback_SentMailing @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback_Send_Alert @FrmGenDate


