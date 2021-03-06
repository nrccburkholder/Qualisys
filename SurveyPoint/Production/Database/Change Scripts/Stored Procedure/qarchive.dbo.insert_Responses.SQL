/****** Object:  StoredProcedure [dbo].[insert_Responses]    Script Date: 08/09/2006 16:38:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Responses]
GO
/****** Object:  StoredProcedure [dbo].[insert_Responses]    Script Date: 08/09/2006 16:38:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [insert_Responses]
	(@ResponseID 	[int] output,
	 @RespondentID 	[int],
	 @SurveyQuestionID 	[int] output,
	 @AnswerCategoryID 	[int],
	 @ResponseText 	[varchar](1000),
	@UserID [int] = NULL)

AS
BEGIN

SELECT     @SurveyQuestionID = sq.SurveyQuestionID
FROM         Questions q INNER JOIN
                      AnswerCategories ac ON q.QuestionID = ac.QuestionID INNER JOIN
                      SurveyQuestions sq ON q.QuestionID = sq.QuestionID INNER JOIN
                      SurveyInstances si INNER JOIN
                      Respondents r ON si.SurveyInstanceID = r.SurveyInstanceID ON sq.SurveyID = si.SurveyID
WHERE     (r.RespondentID = @RespondentID) AND (ac.AnswerCategoryID = @AnswerCategoryID)


INSERT INTO [Responses] 
	 ( [RespondentID],
	 [SurveyQuestionID],
	 [AnswerCategoryID],
	 [ResponseText],
	[UserID]) 
 
VALUES 
	( @RespondentID,
	 @SurveyQuestionID,
	 @AnswerCategoryID,
	 @ResponseText,
	@UserID)

SET @ResponseID = @@IDENTITY

END


' 
END
GO
