/****** Object:  StoredProcedure [dbo].[clear_SurveyTasks]    Script Date: 08/08/2006 15:57:55 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[clear_SurveyTasks]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[clear_SurveyTasks]
GO
/****** Object:  StoredProcedure [dbo].[clear_SurveyTasks]    Script Date: 08/08/2006 15:57:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[clear_SurveyTasks]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.clear_SurveyTasks
	(
		@SurveyInstanceID int,
		@ProtocolStepID int,
		@UserID int
	)
AS
BEGIN
SET NOCOUNT ON

INSERT INTO SurveyInstanceProtocolSteps
	(SurveyInstanceID, ProtocolStepID, ClearedTimeStamp, ClearedUserID)
VALUES (@SurveyInstanceID, @ProtocolStepID, GETDATE(), @UserID)
                     
END


' 
END
GO
