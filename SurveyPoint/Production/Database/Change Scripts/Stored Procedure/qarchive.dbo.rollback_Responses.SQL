/****** Object:  StoredProcedure [dbo].[rollback_Responses]    Script Date: 08/10/2006 10:23:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[rollback_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[rollback_Responses]
GO
/****** Object:  StoredProcedure [dbo].[rollback_Responses]    Script Date: 08/10/2006 10:23:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[rollback_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[rollback_Responses] 
	(
		@RespondentID int,
		@RollbackDate datetime
	)
AS
BEGIN
	-- clear current responses
	DELETE FROM Responses WHERE RespondentID = @RespondentID
	
	-- re-insert responses from rollback date
	INSERT INTO Responses (RespondentID, SurveyQuestionID, AnswerCategoryID, ResponseText, UserID)
	SELECT     RespondentID, SurveyQuestionID, AnswerCategoryID, ResponseText, UserID
	FROM         Responses_jn
	WHERE     (RespondentID = @RespondentID) 
		AND (jn_datetime <= @RollbackDate) AND (@RollbackDate < jn_endtime) 
		AND jn_operation <> ''D''

END
' 
END
GO
GRANT EXECUTE ON [dbo].[rollback_Responses] TO [reporter]
GO
