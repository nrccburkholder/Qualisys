/****** Object:  StoredProcedure [dbo].[cleanup_TestMode]    Script Date: 08/08/2006 14:39:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cleanup_TestMode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cleanup_TestMode]
GO
/****** Object:  StoredProcedure [dbo].[cleanup_TestMode]    Script Date: 08/08/2006 14:39:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cleanup_TestMode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[cleanup_TestMode]
(
	@RespondentID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SurveyInstanceID int

	SET SELECT @SurveyInstanceID = SurveyInstanceID FROM Respondents WHERE RespondentID = @RespondentID

	DELETE FROM EventLog WHERE RespondentID = @RespondentID
	DELETE FROM RespondentProperties WHERE RespondentID = @RespondentID
	DELETE FROM Responses WHERE RespondentID = @RespondentID
	DELETE FROM Respondents WHERE RespondentID = @RespondentID

	DELETE FROM SurveyInstanceProperties WHERE SurveyInstanceID = @SurveyInstanceID
	DELETE FROM SurveyInstanceEvents WHERE SurveyInstanceID = @SurveyInstanceID
	DELETE FROM SurveyInstances WHERE SurveyInstanceID = @SurveyInstanceID

	SET NOCOUNT OFF

END
' 
END
GO
