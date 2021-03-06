/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_AC_Spanish]    Script Date: 08/08/2006 14:06:40 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_AC_Spanish]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_InappropriatelySkipped_AC_Spanish]
GO
/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_AC_Spanish]    Script Date: 08/08/2006 14:06:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_AC_Spanish]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE    PROCEDURE [dbo].[cahps_InappropriatelySkipped_AC_Spanish] 
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
	WHERE     (sq.SurveyID = 30) AND (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryTypeID <> 7)
	
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
		ELSE IF @QuestionNum = 11
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 10) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 11, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 14
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 13) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 14, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 15
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 13) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 15, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 17
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 16) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 17, @AnswerValue = 9
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
		ELSE IF @QuestionNum = 22
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 21) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 22, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 23
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 21) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 23, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 26
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 26, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 27
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 26) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 27, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 29
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 29, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 30
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 29) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 30, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 32
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 32, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 33
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 33, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 34
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 34, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 35
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 35, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 36
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 36, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 37
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 37, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 38
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 38, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 39
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 25) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 39, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 41
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 40) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 41, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 42
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 40) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 42, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 43
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 40) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 43, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 45
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 44) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 45, @AnswerValue = 9
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
		ELSE IF @QuestionNum = 51
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 50) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 51, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 52
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 50) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 51) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 52, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 53
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 50) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 52) = 8
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 53, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 72
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 54) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 72, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 60
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 59) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 60, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 61
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 59) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 60) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 61, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 62
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 59) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 61) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 62, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 63
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 59) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 63, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 64
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 59) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 64, @AnswerValue = 9
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
GRANT EXECUTE ON [dbo].[cahps_InappropriatelySkipped_AC_Spanish] TO [reporter]
GO
