/****** Object:  StoredProcedure [dbo].[select_Response]    Script Date: 08/10/2006 10:10:08 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[select_Response]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[select_Response]
GO
/****** Object:  StoredProcedure [dbo].[select_Response]    Script Date: 08/10/2006 10:10:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[select_Response]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE    PROCEDURE select_Response
(
		@UserID int, 				-- User making the selection
		@RespondentID int,			-- RespondentID to look at
		@SurveyQuestionID int,			-- Question short description to read
		@AnswerValue int,			-- new Answer value
		@ResponseText varchar(1000) = '''',	-- answer text - only used if the answer category is oepn ended
		@Select tinyint = 1			-- Set to 1 or 0 to select or deselect
)
AS
BEGIN

DECLARE @QuestionTypeID int		-- Type of question (single or multiselect)
DECLARE @AnswerCategoryID int		-- Answer Category appropriate for entering text values in the response
DECLARE @AnswerCategoryTypeID int	-- used to determine if we use the response text
DECLARE @ResponseID int		-- Response ID if the response already exists

/* find the survey question,  the question,  and the first answer category which is open answer or select item open answer */
DECLARE getPrepInfo CURSOR FOR
	SELECT     q.QuestionTypeID, ac.AnswerCategoryID, ac.AnswerCategoryTypeID
	FROM         SurveyQuestions sq INNER JOIN
	                      Questions q ON sq.QuestionID = q.QuestionID INNER JOIN
	                      AnswerCategories ac ON q.QuestionID = ac.QuestionID
	WHERE     (sq.SurveyQuestionID = @SurveyQuestionID)
		AND (ac.AnswerValue = @AnswerValue)

/* get the first row -- there might be more than one */
OPEN getPrepInfo
FETCH getPrepInfo INTO @QuestionTypeID, @AnswerCategoryID, @AnswerCategoryTypeID
CLOSE getPrepInfo
DEALLOCATE getPrepInfo

IF @Select = 0 AND @QuestionTypeID = 1		-- Deselect all response from single select question
	DELETE FROM Responses WHERE RespondentID = @RespondentID AND SurveyQuestionID = @SurveyQuestionID
ELSE IF @Select = 0 AND @QuestionTypeID > 1	-- Deselect response from other question type (multi-select, open answer)
	DELETE FROM Responses WHERE RespondentID = @RespondentID AND AnswerCategoryID = @AnswerCategoryID
ELSE IF @Select = 1 AND @QuestionTypeID = 1	-- Select response for single select question
	EXEC  change_Response @RespondentID, @SurveyQuestionID, @AnswerValue, @ResponseText
ELSE IF @Select = 1 AND @QuestionTypeID > 1	-- Select response for other question types
   BEGIN
	IF @AnswerCategoryTypeID NOT IN (2,3,5,6,7,8) -- If we are not an open ended question
		SET @ResponseText = '''' -- Disable the response text
	
	SET @ResponseText = ISNULL(@ResponseText,'''') -- just in case
	
	/* See if there is an existing response with the value */
	DECLARE findExistingResponse CURSOR FOR
		SELECT r.ResponseID
		FROM Responses r
		WHERE r.RespondentID = @RespondentID
		  AND r.SurveyQuestionID = @SurveyQuestionID
		  AND r.AnswerCategoryID = @AnswerCategoryID
	
	SET @ResponseID = null
	OPEN findExistingResponse
	FETCH findExistingResponse INTO @ResponseID
	CLOSE findExistingResponse
	DEALLOCATE findExistingResponse
	
	IF @ResponseID IS NULL  -- did we find an existing record?
	   BEGIN
		-- We did not find an existing record, create a new one
		INSERT INTO Responses(RespondentID, SurveyQuestionID, AnswerCategoryID, ResponseText, UserID)
		VALUES (@RespondentID, @SurveyQuestionID, @AnswerCategoryID, @ResponseText, @UserID)
	   END
	ELSE
	   BEGIN
		-- we found one
		UPDATE Responses
		SET ResponseText = @ResponseText, UserID = @UserID
		WHERE ResponseID=@ResponseID
	   END
   END

END
' 
END
GO
GRANT EXECUTE ON [dbo].[select_Response] TO [reporter]
GO
