/****** Object:  StoredProcedure [dbo].[cahps_AppropriatelySkipped_AC]    Script Date: 08/08/2006 14:01:46 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_AppropriatelySkipped_AC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_AppropriatelySkipped_AC]
GO
/****** Object:  StoredProcedure [dbo].[cahps_AppropriatelySkipped_AC]    Script Date: 08/08/2006 14:01:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_AppropriatelySkipped_AC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE   PROCEDURE [dbo].[cahps_AppropriatelySkipped_AC] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

	DECLARE @QuestionNum int
	
	-- Look for missing responses in Adult Commerical survey
	DECLARE missingResponse CURSOR FOR
	SELECT     sq.ItemOrder
	FROM         SurveyQuestions sq INNER JOIN
	                      Responses r ON sq.SurveyQuestionID = r.SurveyQuestionID INNER JOIN
	                      AnswerCategories ac ON r.AnswerCategoryID = ac.AnswerCategoryID AND sq.QuestionID = ac.QuestionID
	WHERE     (sq.SurveyID = 19) AND (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryTypeID IN (4, 7))
	ORDER BY sq.ItemOrder
	
	OPEN missingResponse
	FETCH missingResponse INTO @QuestionNum
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- check if question can be appropriately skipped
		IF @QuestionNum = 5
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 4) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 5, @AnswerValue = 77
			END
		ELSE IF @QuestionNum = 6
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 4) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 6, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 7
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 6) = 1
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 7, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 9
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 8) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 9, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 11
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 10) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 11, @AnswerValue = 77
			END
		ELSE IF @QuestionNum = 12
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 10) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 12, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 14
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 13) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 14, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 16
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 15) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 16, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 17
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 15) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 17, @AnswerValue = 77
			END
		ELSE IF @QuestionNum = 19
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 18) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 19, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 20
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 18) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 20, @AnswerValue = 77
			END
		ELSE IF @QuestionNum = 23
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 23, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 24
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0 OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 24, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 25
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 25, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 26
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0 OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 26, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 27
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 27, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 28
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 28, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 29
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 29, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 30
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 30, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 31
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 31, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 32
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 32, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 33
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 33, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 34
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) = 0
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 34, @AnswerValue = 77
			END
		ELSE IF @QuestionNum = 36
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 35) IN (2, 3)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 36, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 37
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 35) IN (2, 3)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 37, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 38
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 35) IN (2, 3)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 38, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 40
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 39) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 40, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 42
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 41) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 42, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 44
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 43) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 44, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 45
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 43) = 2 OR (dbo.get_ResponseAnswerValueByNum(@RespondentID, 1) = 6)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 45, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 46
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 43) = 2 OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 45)  IN (1, 2, 7)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 46, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 48
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 47) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 48, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 53
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (2, 3)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 53, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 54
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (2, 3) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 53) IN (1, 2, 4)
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 54, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 55
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (2, 3) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 53) = 4 OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 54) IN (2, 3) 
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 55, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 56
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (2, 3) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 53) = 4 OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 54) IN (2, 3) 
				BEGIN
				IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 55) =  5
					EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 56, @AnswerValue = 5
				ELSE
					EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 56, @AnswerValue = 7
				END
			END
		ELSE IF @QuestionNum = 57
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (2, 3) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 53) = 4 OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 54) IN (2, 3) 
				BEGIN
				IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 55) =  5
					EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 57, @AnswerValue = 5
				ELSE
					EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 57, @AnswerValue = 7
				END
			END
		ELSE IF @QuestionNum = 63
			BEGIN
			IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''T10'', ''T31'')
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 63, @AnswerValue = 7
			END
		ELSE IF @QuestionNum = 64
			BEGIN
			IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''T10'', ''T31'') OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 63) = 2
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 64, @AnswerValue = 7
			END

		-- get next response
		FETCH missingResponse INTO @QuestionNum

	END
	
	CLOSE missingResponse
	DEALLOCATE missingResponse

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_AppropriatelySkipped_AC] TO [reporter]
GO
