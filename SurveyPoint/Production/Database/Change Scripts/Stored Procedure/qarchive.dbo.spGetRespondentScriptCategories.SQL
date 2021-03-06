/****** Object:  StoredProcedure [dbo].[spGetRespondentScriptCategories]    Script Date: 08/09/2006 12:57:44 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetRespondentScriptCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spGetRespondentScriptCategories]
GO
/****** Object:  StoredProcedure [dbo].[spGetRespondentScriptCategories]    Script Date: 08/09/2006 12:57:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetRespondentScriptCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE dbo.spGetRespondentScriptCategories
(
	@RespondentID int,
	@ScriptID int
)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT     ssc.ScriptID, ssc.ScriptScreenID, ssc.SurveyQuestionID, ssc.QuestionTypeID, 
			   ssc.ScriptScreenCategoryID, ssc.AnswerCategoryID, ssc.AnswerValue, ssc.AnswerText, 
			   ssc.AnswerCategoryTypeID, ssc.ShowCategory, ssc.JumpToScriptScreenID, r.ResponseID, 
			   CASE WHEN ISNULL(r.ResponseID,0) > 0 THEN 1 ELSE 0 END AS ResponseStatus, 
			   r.ResponseText
	FROM         
		(SELECT     ScriptID, ScriptScreenID, SurveyQuestionID, ScriptScreenCategoryID, 
					AnswerCategoryID, AnswerValue,[Text] AS AnswerText, QuestionTypeID, 
					AnswerCategoryTypeID, ShowCategory, JumpToScriptScreenID
		FROM          dbo.v_ScriptScreenCategories
		WHERE      (ScriptID = @ScriptID)) ssc 
	LEFT OUTER JOIN
		(SELECT     ResponseID, RespondentID, SurveyQuestionID, AnswerCategoryID, ResponseText
		FROM          dbo.Responses
		WHERE      (RespondentID = @RespondentID)) r 
	ON ssc.SurveyQuestionID = r.SurveyQuestionID AND ssc.AnswerCategoryID = r.AnswerCategoryID
	ORDER BY ssc.ScriptID, ssc.ScriptScreenID, ssc.ScriptScreenCategoryID	

END
' 
END
GO
GRANT EXECUTE ON [dbo].[spGetRespondentScriptCategories] TO [reporter]
GO
