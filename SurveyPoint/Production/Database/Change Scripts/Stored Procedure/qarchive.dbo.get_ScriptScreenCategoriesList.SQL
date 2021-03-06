/****** Object:  StoredProcedure [dbo].[get_ScriptScreenCategoriesList]    Script Date: 08/09/2006 15:24:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_ScriptScreenCategoriesList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_ScriptScreenCategoriesList]
GO
/****** Object:  StoredProcedure [dbo].[get_ScriptScreenCategoriesList]    Script Date: 08/09/2006 15:24:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_ScriptScreenCategoriesList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE dbo.get_ScriptScreenCategoriesList
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
SELECT     ItemOrder, -9999, -9999, CAST(ItemOrder as varchar) + ''. '' + Title
FROM         ScriptScreens
WHERE     (SurveyQuestionID IS NOT NULL) AND (ScriptID = @ScriptID)
ORDER BY ItemOrder


INSERT INTO #AnswerCategoryList (ScreenOrder, AnswerValue, AnswerCategoryID, AnswerText)
SELECT     ss.ItemOrder, ac.AnswerValue, ssc.AnswerCategoryID, dbo.TruncateStr('' - '' + CAST(ac.AnswerValue AS varchar) + '') '' + ssc.Text, 100, 1)
FROM         ScriptScreens ss INNER JOIN
                      SurveyQuestions sq ON ss.SurveyQuestionID = sq.SurveyQuestionID INNER JOIN
                      ScriptScreenCategories ssc ON ss.ScriptScreenID = ssc.ScriptScreenID INNER JOIN
                      AnswerCategories ac ON ssc.AnswerCategoryID = ac.AnswerCategoryID AND sq.QuestionID = ac.QuestionID
WHERE     (ss.ScriptID = @ScriptID)

SELECT AnswerCategoryID, AnswerText FROM #AnswerCategoryList
ORDER BY ScreenOrder, AnswerValue

DROP TABLE #AnswerCategoryList

SET NOCOUNT OFF

END

' 
END
GO
GRANT EXECUTE ON [dbo].[get_ScriptScreenCategoriesList] TO [reporter]
GO
