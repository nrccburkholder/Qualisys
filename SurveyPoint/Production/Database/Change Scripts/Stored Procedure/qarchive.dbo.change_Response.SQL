/****** Object:  StoredProcedure [dbo].[change_Response]    Script Date: 08/08/2006 14:39:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[change_Response]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[change_Response]
GO
/****** Object:  StoredProcedure [dbo].[change_Response]    Script Date: 08/08/2006 14:39:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[change_Response]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE dbo.change_Response(
		@RespondentID int, 		-- the respondent to change 
		@SurveyQuestionID int, 		-- the survey question to change
		@AnswerValue int, 		-- the value of the answer categories to change
		@ResponseText varchar(1000)	-- new response text
)
AS
BEGIN
DECLARE @AnswerCategoryID int		-- Answer Category appropriate for entering text values in the response
DECLARE @AnswerCategoryTypeID int       -- used to determine if we use the response text
DECLARE @ResponseID int			-- Response ID if the response already exists

/* find the survey question,  the question,  and the first answer category which is open answer or select item open answer */
DECLARE getPrepInfo CURSOR FOR
	SELECT ac.AnswerCategoryID,
               ac.AnswerCategoryTypeID
	FROM SurveyQuestions sq,
	     answerCategories ac
	WHERE sq.SurveyQuestionID = @SurveyQuestionID
	  AND sq.QuestionID = ac.QuestionID
          AND ac.AnswerValue = @AnswerValue

/* get the first row -- there might be more than one */
OPEN getPrepInfo
FETCH getPrepInfo INTO @AnswerCategoryID, @AnswerCategoryTypeID
CLOSE getPrepInfo
DEALLOCATE getPrepInfo

IF @AnswerCategoryTypeID NOT IN (2,3,5,6,8) -- If we are not an open ended question
  SET @ResponseText = '''' -- Disable the response text

SET @ResponseText = ISNULL(@ResponseText,'''') -- just in case

/* See if there is an existing response with the value */
DECLARE findExistingResponse CURSOR FOR
	SELECT r.ResponseID
	FROM Responses r
	WHERE r.RespondentID = @RespondentID
	  AND r.SurveyQuestionID = @SurveyQuestionID

SET @ResponseID = null
OPEN findExistingResponse
FETCH findExistingResponse into @ResponseID
CLOSE findExistingResponse
DEALLOCATE findExistingResponse

IF @ResponseID IS NULL  -- if we couldnt find one
  BEGIN
  INSERT INTO Responses(RespondentID,
	SurveyQuestionID,
	AnswerCategoryID,
        responseText)
  VALUES (@RespondentID,
          @SurveyQuestionID,
          @AnswerCategoryID,@ResponseText)
  END
ELSE   -- we found one
  BEGIN
  UPDATE Responses
	  SET AnswerCategoryID = @AnswerCategoryID,
	  ResponseText = @ResponseText
	  WHERE ResponseID = @ResponseID
  END

END
' 
END
GO
