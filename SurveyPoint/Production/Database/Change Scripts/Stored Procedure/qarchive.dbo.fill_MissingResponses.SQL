/****** Object:  StoredProcedure [dbo].[fill_MissingResponses]    Script Date: 08/09/2006 15:15:46 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[fill_MissingResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[fill_MissingResponses]
GO
/****** Object:  StoredProcedure [dbo].[fill_MissingResponses]    Script Date: 08/09/2006 15:15:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[fill_MissingResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[fill_MissingResponses] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

-- Get respondent''s survey id
DECLARE @SurveyID int
SET SELECT     @SurveyID  = SurveyInstances.SurveyID
FROM         Respondents INNER JOIN
                      SurveyInstances ON Respondents.SurveyInstanceID = SurveyInstances.SurveyInstanceID
WHERE     (Respondents.RespondentID = @RespondentID)

-- Insert in missing category responses for survey questions that do not already have a missing answer category response
INSERT INTO Responses(RespondentID, SurveyQuestionID, AnswerCategoryID, ResponseText, UserID) 
SELECT     @RespondentID AS RespondentID, sq.SurveyQuestionID, MIN(ac.AnswerCategoryID) AS AnswerCategoryID, '''' AS ResponseText, @UserID 
FROM         AnswerCategories ac INNER JOIN
                      Questions q ON ac.QuestionID = q.QuestionID INNER JOIN
                      SurveyQuestions sq ON q.QuestionID = sq.QuestionID
WHERE     (sq.SurveyID = @SurveyID) AND (ac.AnswerCategoryTypeID = 7) AND (NOT EXISTS
                          (SELECT     1
                            FROM          AnswerCategories x INNER JOIN
                                                   Responses r ON x.AnswerCategoryID = r.AnswerCategoryID
                            WHERE      (r.RespondentID = @RespondentID) AND (r.SurveyQuestionID = sq.SurveyQuestionID)))
GROUP BY sq.SurveyQuestionID

END
' 
END
GO
