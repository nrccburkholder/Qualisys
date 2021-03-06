/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_IBC]    Script Date: 08/08/2006 14:15:12 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_IBC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_InappropriatelySkipped_IBC]
GO
/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_IBC]    Script Date: 08/08/2006 14:15:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_IBC]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE     PROCEDURE [dbo].[cahps_InappropriatelySkipped_IBC] 
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
	WHERE     (sq.SurveyID = 28) AND (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryTypeID <> 7)
	
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
		ELSE IF @QuestionNum = 12
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 11) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 12, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 13
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 11) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 13, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 15
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 14) IN (8, 9)
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
		ELSE IF @QuestionNum = 18
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 16) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 18, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 20
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 19) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 20, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 21
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 19) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 21, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 24
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 24, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 25
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 24) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 25, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 26
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 26, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 28
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 26) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 28, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 29
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 29, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 31
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 31, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 32
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 32, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 33
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 33, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 34
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 34, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 35
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 35, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 36
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 36, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 37
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 23) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 37, @AnswerValue = 99
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
		ELSE IF @QuestionNum = 47
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 46) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 47, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 49
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 48) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 49, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 50
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 48) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 49) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 50, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 51
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 48) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 50) = 8
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 51, @AnswerValue = 9
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
		ELSE IF @QuestionNum = 62
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 61) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 62, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 63
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 61) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 62) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 63, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 64
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 61) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 63) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 64, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 65
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 61) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 65, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 66
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 61) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 66, @AnswerValue = 9
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
GRANT EXECUTE ON [dbo].[cahps_InappropriatelySkipped_IBC] TO [reporter]
GO
