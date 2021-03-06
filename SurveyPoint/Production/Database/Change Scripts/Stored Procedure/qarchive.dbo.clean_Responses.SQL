/****** Object:  StoredProcedure [dbo].[clean_Responses]    Script Date: 08/08/2006 14:39:25 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[clean_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[clean_Responses]
GO
/****** Object:  StoredProcedure [dbo].[clean_Responses]    Script Date: 08/08/2006 14:39:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[clean_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[clean_Responses] 
(
	@RespondentID int
)
AS
BEGIN

DECLARE @SurveyQuestionID int
DECLARE @KeepResponseID int

DECLARE badSurveyQuestions CURSOR FOR
	SELECT r.SurveyQuestionID, MAX(r.ResponseID) AS KeepResponseID
	FROM Questions q INNER JOIN
              SurveyQuestions sq ON q.QuestionID = sq.QuestionID INNER JOIN
              Responses r ON sq.SurveyQuestionID = r.SurveyQuestionID INNER JOIN
              Respondents rp ON r.RespondentID = rp.RespondentID INNER JOIN
              SurveyInstances si ON rp.SurveyInstanceID = si.SurveyInstanceID AND sq.SurveyID = si.SurveyID
	WHERE (q.QuestionTypeID <> 2) AND (r.RespondentID = @RespondentID)
	GROUP BY r.SurveyQuestionID
	HAVING      (COUNT(r.ResponseID) > 1)

OPEN badSurveyQuestions 
FETCH badSurveyQuestions INTO @SurveyQuestionID, @KeepResponseID

WHILE @@FETCH_STATUS = 0
	BEGIN
	DELETE FROM Responses WHERE (RespondentID = @RespondentID) AND (SurveyQuestionID = @SurveyQuestionID) AND (ResponseID <> @KeepResponseID)
	FETCH badSurveyQuestions INTO @SurveyQuestionID, @KeepResponseID
	END

CLOSE badSurveyQuestions
DEALLOCATE badSurveyQuestions

END
' 
END
GO
