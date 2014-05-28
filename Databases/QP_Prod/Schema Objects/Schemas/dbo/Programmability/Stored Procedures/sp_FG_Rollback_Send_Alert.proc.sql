/****** Object:  Stored Procedure dbo.sp_FG_Rollback_Send_Alert    Script Date: 7/12/99 10:57:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_FG_Rollback_Send_Alert    Script Date: 4/26/99 9:19:24 AM ******/
/* This procedure will encompass future enhancements in which Alerts can be sent out. */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
/* 8/2/1999 Daniel Vansteenburg - Added code to send out pages using sp_raiseerror. */
CREATE PROCEDURE sp_FG_Rollback_Send_Alert
 @FrmGenDate varchar(22)
AS
 declare @sqlstr varchar(255)
 select @sqlstr = 'SELECT DISTINCT FGE.ScheduledMailing_id,FGE.datGenerated,FGET.FGErrorType_dsc FROM dbo.FormGenError FGE,dbo.FormGenErrorType FGET WHERE FGE.FGErrorType_id = FGET.FGErrorType_id AND FGE.datGenerated = ''' + @FrmGenDate + ''''
 exec dbo.sp_RaiseError 2, 'FormGen', @sqlstr


