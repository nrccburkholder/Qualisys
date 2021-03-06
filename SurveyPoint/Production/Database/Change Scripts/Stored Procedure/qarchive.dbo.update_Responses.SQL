/****** Object:  StoredProcedure [dbo].[update_Responses]    Script Date: 08/09/2006 10:18:18 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Responses]
GO
/****** Object:  StoredProcedure [dbo].[update_Responses]    Script Date: 08/09/2006 10:18:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [update_Responses]
	(@ResponseID 	[int],
	 @RespondentID 	[int],
	 @SurveyQuestionID 	[int] output,
	 @AnswerCategoryID 	[int],
	 @ResponseText 	[varchar](1000),
	 @UserID [int] = NULL)

AS
BEGIN

--Get survey question id based on answer category id and respondent id
SELECT     @SurveyQuestionID = sq.SurveyQuestionID
FROM         Questions q INNER JOIN
                      AnswerCategories ac ON q.QuestionID = ac.QuestionID INNER JOIN
                      SurveyQuestions sq ON q.QuestionID = sq.QuestionID INNER JOIN
                      SurveyInstances si INNER JOIN
                      Respondents r ON si.SurveyInstanceID = r.SurveyInstanceID ON sq.SurveyID = si.SurveyID
WHERE     (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryID = @AnswerCategoryID)

UPDATE [Responses]
SET   [RespondentID]	 = @RespondentID,
	 [SurveyQuestionID]	 = @SurveyQuestionID,
	 [AnswerCategoryID]	 = @AnswerCategoryID,
	 [ResponseText]	 = @ResponseText,
	[UserID] = @UserID

WHERE 
	( [ResponseID]	 = @ResponseID)

END

' 
END
GO
