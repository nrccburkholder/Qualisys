/****** Object:  Stored Procedure dbo.sp_AuditTrail    Script Date: 6/9/99 4:36:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_AuditTrail    Script Date: 3/12/99 4:16:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_AuditTrail    Script Date: 12/7/98 2:34:53 PM ******/
/* Written by: Joel Ford (Cap Gemini)
** Date:  May 19, 1998
**
** All parameters are required 
*/
CREATE PROCEDURE sp_AuditTrail
@EventTypeID int,
@EmployeeID int,
@ModuleID char(10),
@StudyID int,
@SurveyID int,
@EventDate char(20)
AS
 INSERT INTO QualPro_syslogs
 (EventType_id, 
  Employee_id,
  datEvent_dt,
  strModule,
  Study_id,
  Survey_id)
 VALUES 
 (@EventTypeID,
  @EmployeeID,
  getdate(), 		-- Use to be: @EventDate,
  @ModuleID,
  @StudyID,
  @SurveyID)
 if @@error <> 0
  begin
   raiserror(14043, 16, -1, 'Failed to insert Audit Entry')
   return(1)
  end
 return(0)


