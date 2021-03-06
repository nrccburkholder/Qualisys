/****** Object:  StoredProcedure [dbo].[generate_Script]    Script Date: 08/09/2006 15:15:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[generate_Script]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[generate_Script]
GO
/****** Object:  StoredProcedure [dbo].[generate_Script]    Script Date: 08/09/2006 15:15:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[generate_Script]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE generate_Script(
   @SurveyID int                  -- the survey id to copy from
 )
AS
BEGIN

DECLARE @ScriptID int

/* create script record */
INSERT INTO Scripts (SurveyID, ScriptTypeID, Name, Description, CompletenessLevel, FollowSkips, CalcCompleteness, DefaultScript)
	SELECT SurveyID, 1, Name, Description, 100, 1, 1, 0 FROM Surveys WHERE SurveyID = @SurveyID

SET @ScriptID = @@IDENTITY

UPDATE Scripts SET Name = Name + '' ('' + CAST(@ScriptID AS varchar) + '') auto-generated'' WHERE ScriptID = @ScriptID

/*create script screens */
INSERT INTO ScriptScreens (ScriptID, SurveyQuestionID, Title, Text, CalculationTypeID, ItemOrder)
	SELECT @ScriptID, sq.SurveyQuestionID, q.ShortDesc, q.Text, 3 AS CalculationTypeID, sq.ItemOrder 
	FROM SurveyQuestions sq INNER JOIN Questions q ON sq.QuestionID = q.QuestionID
	WHERE sq.SurveyID = @SurveyID ORDER BY sq.ItemOrder
	
/* create script screen categories */
INSERT INTO ScriptScreenCategories (ScriptScreenID, AnswerCategoryID, JumpToScriptScreenID, Text) 
	SELECT ss.ScriptScreenID, ac.AnswerCategoryID, 0 AS JumpToScriptScreenID, ac.AnswerText AS Text
	FROM ScriptScreens ss INNER JOIN SurveyQuestions sq ON ss.SurveyQuestionID = sq.SurveyQuestionID 
	INNER JOIN Questions q ON sq.QuestionID = q.QuestionID INNER JOIN 
	AnswerCategories ac ON q.QuestionID = ac.QuestionID 
	WHERE ss.ScriptID = @ScriptID ORDER BY ss.ScriptScreenID, ac.AnswerCategoryID

/*return generated script id */
SELECT @ScriptID

END
' 
END
GO
GRANT EXECUTE ON [dbo].[generate_Script] TO [reporter]
GO
