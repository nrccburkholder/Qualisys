/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_CM]    Script Date: 08/08/2006 14:06:56 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_CM]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_InappropriatelySkipped_CM]
GO
/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped_CM]    Script Date: 08/08/2006 14:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped_CM]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE    PROCEDURE [dbo].[cahps_InappropriatelySkipped_CM] 
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
	WHERE     (sq.SurveyID = 29) AND (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryTypeID <> 7)
	
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
		ELSE IF @QuestionNum = 10
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 9) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 10, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 11
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 9) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 11, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 13
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 12) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 13, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 15
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 14) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 15, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 16
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 14) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 16, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 18
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 17) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 18, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 20
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 19) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 20, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 21
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 19) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 21, @AnswerValue = 9
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
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 24, @AnswerValue = 99
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 26
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 26, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 28
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 26) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 28, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 29
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 29, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 30
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 29) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 30, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 31
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 31, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 32
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 32, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 33
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 33, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 34
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 34, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 35
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 35, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 36
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 36, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 37
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 37, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 38
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 38, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 39
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 38) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 39, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 40
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 38) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 40, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 41
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 41, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 42
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 42, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 43
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 42) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 43, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 44
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 42) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 44, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 45
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 42) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 45, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 46
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 46, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 47
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 46) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 47, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 48
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 46) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 48, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 49
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 46) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 49, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 50
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 46) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 50, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 51
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 27) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 51, @AnswerValue = 99
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
		ELSE IF @QuestionNum = 56
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 55) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 56, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 58
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 57) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 58, @AnswerValue = 9
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
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 59) IN (8, 9)
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
		ELSE IF @QuestionNum = 64
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 63) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 64, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 65
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 63) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 64) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 65, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 67
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 66) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 67, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 68
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 66) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 67) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 68, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 70
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 69) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 70, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 71
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 69) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 70) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 71, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 73
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 72) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 73, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 75
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 74) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 75, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 77
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 76) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 77, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 79
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 78) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 79, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 81
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 80) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 81, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 83
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 82) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 83, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 84
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 83) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 84, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 85
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 84) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 85, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 87
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 86) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 87, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 90
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 89) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 90, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 91
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 89) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 90) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 91, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 94
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 93) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 94, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 95
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 93) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 94) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 95, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 97
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 96) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 97, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 98
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 96) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 97) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 98, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 100
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 99) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 100, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 101
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 99) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 100) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 101, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 103
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 102) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 103, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 104
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 102) IN (8, 9) OR dbo.get_ResponseAnswerValueByNum(@RespondentID, 103) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 104, @AnswerValue = 9
				SET @HasCorrection = 1
				END
			END
		ELSE IF @QuestionNum = 106
			BEGIN
			IF dbo.get_ResponseAnswerValueByNum(@RespondentID, 105) IN (8, 9)
				BEGIN
				EXEC dbo.select_ResponseByNum @UserID = @UserID, @RespondentID = @RespondentID, @QuestionNum = 106, @AnswerValue = 9
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
GRANT EXECUTE ON [dbo].[cahps_InappropriatelySkipped_CM] TO [reporter]
GO
