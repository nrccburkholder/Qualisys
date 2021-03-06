/****** Object:  StoredProcedure [dbo].[select_ResponseByNum]    Script Date: 08/10/2006 10:09:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[select_ResponseByNum]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[select_ResponseByNum]
GO
/****** Object:  StoredProcedure [dbo].[select_ResponseByNum]    Script Date: 08/10/2006 10:09:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[select_ResponseByNum]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE [dbo].[select_ResponseByNum]
(
		@UserID int, 				-- User making the change
		@RespondentID int,			-- RespondentID to look at
		@QuestionNum int,			-- Question number to change
		@AnswerValue int,			-- new Answer value
		@ResponseText varchar(1000) = '''',	-- answer text - only used if the answer category is oepn ended
		@Select tinyint = 1			-- Set to 1 or 0 to select or deselect
)
AS
BEGIN
	DECLARE @SurveyQuestionID int

	SET @SurveyQuestionID = dbo.GetSurveyQuestionIDFromNum(@RespondentID, @QuestionNum)

	EXEC select_Response @UserID, @RespondentID, @SurveyQuestionID, @AnswerValue, @ResponseText, @Select

END

' 
END
GO
GRANT EXECUTE ON [dbo].[select_ResponseByNum] TO [reporter]
GO
