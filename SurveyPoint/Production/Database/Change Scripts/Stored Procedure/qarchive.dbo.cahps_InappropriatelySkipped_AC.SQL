/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_AC]    Script Date: 08/08/2006 14:06:31 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_AC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_InappropriatelySkipped_AC]
GO
/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_AC]    Script Date: 08/08/2006 14:06:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_AC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE    PROCEDURE [dbo].[cahps_InappropriatelySkipped_AC] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

	DECLARE @QuestionNum int
	DECLARE @HasCorrection int
	SET @HasCorrection = 0 

	-- Look for non-missing responses in survey
	DECLARE myResponse CURSOR FOR
	SELECT     sq.ItemOrder
	FROM         SurveyQuestions sq INNER JOIN
	                      Responses r ON sq.SurveyQuestionID = r.SurveyQuestionID INNER JOIN
	                      AnswerCategories ac ON r.AnswerCategoryID = ac.AnswerCategoryID AND sq.QuestionID = ac.QuestionID
	WHERE     (sq.SurveyID = 19) AND (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryTypeID <> 7)
	
	OPEN myResponse
	FETCH myResponse INTO @QuestionNum
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @QuestionNum = 5
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 4) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 5, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 6
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 4) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 6, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 7
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 6) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 7, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 9
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 8) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 9, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 11
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 10) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 11, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 12
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 10) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 12, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 14
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 13) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 14, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 16
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 15) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 16, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 17
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 15) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 17, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 19
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 18) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 19, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 20
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 18) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 20, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 23
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 23, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 24
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 24, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 25
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 25, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 26
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 26, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 27
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 27, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 28
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 28, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 29
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 29, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 30
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 30, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 31
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 31, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 32
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 32, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 33
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 33, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 34
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 22) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 34, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 36
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 35) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 36, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 37
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 35) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 37, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 38
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 35) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 38, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 40
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 39) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 40, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 42
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 41) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 42, @AnswerValue = 9				
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 44
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 43) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 44, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 45
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 43) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 44) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 45, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 46
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 43) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 45) = 8
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 46, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 48
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 47) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 48, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 53
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 53, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 54
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 53) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 54, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 55
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 54) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 55, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 56
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 56, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 57
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 57, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END

		-- get next response
		FETCH myResponse INTO @QuestionNum

	END
	
	CLOSE myResponse
	DEALLOCATE myResponse

	IF @HasCorrection = 1
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_CorrectionResponses: Corrections were made to responses''

END

' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_InappropriatelySkipped_AC] TO [reporter]
GO
