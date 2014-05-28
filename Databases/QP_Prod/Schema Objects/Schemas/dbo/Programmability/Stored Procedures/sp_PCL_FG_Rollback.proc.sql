/****** Object:  Stored Procedure dbo.sp_PCL_FG_Rollback    Script Date: 7/12/99 10:57:15 AM ******/
/************************************************************************************************/
/*            */
/* Business Purpose: This procedure calls all the sp_PCL_rollback and sp_FG_rollback procedures */
/*       to rollback PCLGen and Form Gen data related to a specific Form Gen batch. */
/*            */
/* Date Created:  7/1/1999          */
/*            */
/* Created by:  Dan Archuleta          */
/*            */
/************************************************************************************************/
CREATE PROCEDURE sp_PCL_FG_Rollback
 @FrmGenDate varchar(22)
AS
 EXECUTE dbo.sp_PCL_Rollback @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback_PCLNeeded @FrmGenDate
 EXECUTE dbo.sp_FG_Rollback @FrmGenDate


