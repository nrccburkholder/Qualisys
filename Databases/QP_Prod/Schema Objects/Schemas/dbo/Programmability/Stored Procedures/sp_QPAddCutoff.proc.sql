/****** Object:  Stored Procedure dbo.sp_QPAddCutoff    Script Date: 7/15/09 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddCutoff    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddCutoff    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QPAddCutoff    Script Date: 12/7/98 2:34:55 PM ******/
CREATE PROCEDURE sp_QPAddCutoff
@mintSurvey_id int,
@mintEmployeeID int,
@IDKey int OUTPUT
As
BEGIN TRANSACTION
 INSERT INTO Cutoff
 (Survey_id, datCutoffDate, Employee_id)
 VALUES
 ( @mintSurvey_id, getdate(), @mintEmployeeID)
 SELECT @IDKey = SCOPE_IDENTITY()
COMMIT TRANSACTION


