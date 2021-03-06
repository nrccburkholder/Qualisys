/****** Object:  StoredProcedure [dbo].[get_ScriptScreenTextCategoriesList]    Script Date: 08/11/2006 13:05:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_ScriptScreenTextCategoriesList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_ScriptScreenTextCategoriesList]
GO
/****** Object:  StoredProcedure [dbo].[get_ScriptScreenTextCategoriesList]    Script Date: 08/11/2006 13:05:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_ScriptScreenTextCategoriesList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE dbo.get_ScriptScreenTextCategoriesList
(
	@ScriptID int
) 
AS
BEGIN

SET NOCOUNT ON

CREATE TABLE #AnswerCategoryList
(
	ScreenOrder int,
	AnswerValue int,
	AnswerCategoryID int,
	AnswerText varchar(100)		
)

INSERT INTO #AnswerCategoryList (ScreenOrder, AnswerValue, AnswerCategoryID, AnswerText)
SELECT     ItemOrder, - 9999, -9999, CAST(ItemOrder AS varchar) + ''. '' + Title
FROM         ScriptScreens ss
WHERE     (SurveyQuestionID IS NOT NULL) AND (ScriptID = @ScriptID) AND EXISTS
                          (SELECT     ac.AnswerCategoryID
                            FROM          SurveyQuestions sq INNER JOIN
                                                   AnswerCategories ac ON sq.QuestionID = ac.QuestionID INNER JOIN
                                                   ScriptScreenCategories ssc ON ac.AnswerCategoryID = ssc.AnswerCategoryID
                            WHERE      ss.ScriptScreenID = ssc.ScriptScreenID AND ss.SurveyQuestionID = sq.SurveyQuestionID AND ac.AnswerCategoryTypeID IN (2, 3, 5, 6, 8))
ORDER BY ItemOrder

INSERT INTO #AnswerCategoryList (ScreenOrder, AnswerValue, AnswerCategoryID, AnswerText)
SELECT     ss.ItemOrder, ac.AnswerValue, ssc.AnswerCategoryID, dbo.TruncateStr('' - '' + CAST(ac.AnswerValue AS varchar) + '') '' + ssc.Text, 100, 1)
FROM         ScriptScreens ss INNER JOIN
                      SurveyQuestions sq ON ss.SurveyQuestionID = sq.SurveyQuestionID INNER JOIN
                      ScriptScreenCategories ssc ON ss.ScriptScreenID = ssc.ScriptScreenID INNER JOIN
                      AnswerCategories ac ON ssc.AnswerCategoryID = ac.AnswerCategoryID AND sq.QuestionID = ac.QuestionID
WHERE     (ss.ScriptID = @ScriptID) AND (ac.AnswerCategoryTypeID IN (2, 3, 5, 6, 8))

SELECT AnswerCategoryID, AnswerText FROM #AnswerCategoryList
ORDER BY ScreenOrder, AnswerValue

DROP TABLE #AnswerCategoryList

SET NOCOUNT OFF

END
' 
END
GO
GRANT EXECUTE ON [dbo].[get_ScriptScreenTextCategoriesList] TO [reporter]
GO
