/****** Object:  StoredProcedure [dbo].[CopySurvey]    Script Date: 08/08/2006 16:46:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CopySurvey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[CopySurvey]
GO
/****** Object:  StoredProcedure [dbo].[CopySurvey]    Script Date: 08/08/2006 16:46:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CopySurvey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE dbo.CopySurvey(
	@SurveyID [int],	@UserID [int]
)AS
/*
This procedure will copy a survey and its related surveyquestions, associated scritps,script screens,  and screen categories.
It will return a select list containing the new surveyID number.
The survey name will be updated to be : Copy x%% old name.Ohwer x%% is x appended with the new open survey id number available.  Note that the next available id numbermight not be the same as the actual new id number.  This is just a hack to make the name unique.
Oh yeah,  if the name is too big,  it will be truncated to 100 chatacters. The description is the same
Currently,  the surveyquota is not copied.
Written by Hibbard M. Engler 2/21/2003*/
BEGIN
DECLARE @NewSurveyID int
/* Lets make the new survey first */INSERT INTO Surveys(  Name,  Description,  CreatedByUserID,  CreatedOnDate,  Active)SELECT SUBSTRING(a.Name + '' ('' + CONVERT(varchar(5),b.nextid) + '')'',1,100),	Description, @UserID, GETDATE(), ActiveFROM Surveys a,(SELECT MAX(SurveyID)+1 nextid from Surveys ) bWHERE a.SurveyID = @SurveyID
/* get the new id number */SET @NewSurveyID = @@Identity
/*Debug query:select * from Surveys where SurveyID in (@NewSurveyID,@SurveyID)*/
/* SurveyQuestions Because there is no natural unique key for surveyQuestions,  we will have to create a mapping table#sqmap
Which maps the old survey question to the new one.*/
CREATE TABLE #sqmap
(
	OldSQID int,
	NewSQID int,	UNIQUE (oldsqID,newSQID)
)
DECLARE abc CURSOR FORSELECT SurveyQuestionID FROM SurveyQuestions WHERE surveyID = @SurveyID
DECLARE @SurveyQuestionID int
DECLARE @NewSurveyQuestionID int
OPEN abc
FETCH abc INTO @SurveyQuestionIDWHILE @@FETCH_STATUS = 0BEGIN
	/* copy the survey question */	INSERT INTO SurveyQuestions(SurveyID,QuestionID,DisplayNumber,ItemOrder)	SELECT @NewSurveyID,QuestionID,DisplayNumber,ItemOrder	FROM SurveyQuestions	WHERE SurveyQuestionID = @SurveyQuestionID	
	SET @NewSurveyQuestionID = @@IDENTITY	
	/* Map the survey question */	INSERT INTO #sqmap(newsqid,oldsqid) VALUES (@NewSurveyQuestionID,@SurveyQuestionID)	
	/* get the next record */	FETCH abc INTO @SurveyQuestionID
END
CLOSE abc
DEALLOCATE abc
/*debug query:SELECT * FROM sURVEYqUESTIONS where SurveyID in (@NewSurveyID,@SurveyID)order by SurveyID,QuestionID*/

/*
Now to do scripts.  Because there is no natural unique key on scripts,  we will have to have a temporarymapping table that maps the new scripts to the old scripts
*/
CREATE TABLE #scriptmap
(
	NewScriptID int, 
	OldScriptID int, 
	unique (OldScriptID,NewScriptID)
)
DECLARE abc CURSOR FORSELECT ScriptID FROM scripts WHERE surveyID = @SurveyID
DECLARE @ScriptID int
DECLARE @NewScriptID int
OPEN abc
FETCH abc INTO @ScriptID
WHILE @@FETCH_STATUS = 0BEGIN
	/* insert one at a time */	INSERT INTO scripts(SurveyID,ScriptTypeID,Name,Description,CompletenessLevel,	FollowSkips,CalcCompleteness,DefaultScript)	
	SELECT @NewSurveyID,ScriptTypeID,Name,Description,CompletenessLevel,	FollowSkips,CalcCompleteness,DefaultScript
	FROM Scripts WHERE ScriptID= @ScriptID		/* get the new id */
	SET @NewScriptID = @@Identity	
	/* update out mapping table */	INSERT INTO #scriptmap(NewScriptID,OldScriptID) VALUES (@NewScriptID,@ScriptID)	
		/* Get the next row */	FETCH abc INTO @ScriptID
END
CLOSE abc
DEALLOCATE abc
/*debug queries:select * from scripts where surveyID in (@newsurveyID,@SurveyID)select * from #scriptmap*/

/*
Script ScreensHere we will use #scritpmap to map the new script to the old ones.Because there is no natural unique key for Script Screens,  we need another mapping table#ScriptScreenMap*/
CREATE TABLE #ScriptScreenMap (	OldScriptScreenID int,	NewScriptScreenID int,	UNIQUE (OldScriptScreenID,NewScriptScreenID))DECLARE abc CURSOR FORSELECT ScriptScreenID FROM scriptScreens 
WHERE ScriptID IN (SELECT OldScriptID FROM #Scriptmap)
DECLARE @ScriptScreenID int
DECLARE @NewScriptScreenID int
OPEN abc
FETCH abc INTO @ScriptScreenID
WHILE @@FETCH_STATUS = 0BEGIN
	INSERT INTO ScriptScreens(		ScriptID,		SurveyQuestionID,		Title,		Text,		CalculationTypeID,		ItemOrder)	SELECT b.NewScriptID,c.NewSQID,Title,[Text],CalculationTypeID,ItemOrder	FROM ScriptScreens a, #scriptMap b,#sqmap c	WHERE b.OldScriptID = a.ScriptID	AND a.SurveyQuestionID = c.oldSQID
	AND a.ScriptScreenID = @ScriptScreenID	
	-- Get the new id
	SET @NewScriptScreenID = @@IDENTITY	
	-- set up the map
	INSERT INTO #ScriptScreenMap(OldScriptScreenID,NewScriptScreenID)
	VALUES (@ScriptScreenID,@NewScriptScreenID)	
	/* get next ocurrence */	FETCH abc INTO @ScriptScreenID
END
CLOSE abc
DEALLOCATE abc
/*Debug queries:select * from ScriptSCreens where scriptID in (select oldScriptID from #scriptmap)select * from ScriptSCreens where scriptID in (select newScriptID from #scriptmap)select * from #ScriptScreenmap*/

/* Script Screen Categories Note -- some JumpToScriptScreenID values are invalid as far as directly referencing scriptscreens.  So for those records,  we just leave the original token code (i.e. 0, -999) as it is.Otherwise,  if the script screen is valid,  we pass its mapped screen*/
INSERT INTO ScriptScreenCategories (ScriptScreenID,AnswerCategoryID,JumpToScriptScreenID,[Text])SELECT b.NewScriptScreenID,a.AnswerCategoryID,ISNULL(c.NewScriptScreenID,a.JumpToScriptScreenID),[Text]FROM #ScriptScreenMap bINNER JOIN ScriptScreenCategories a  ON a.ScriptScreenID = b.OldScriptScreenIDLEFT OUTER JOIN #scriptScreenMap c  ON a.JumpToScriptScreenID = c.OldScriptScreenID
/* debug queries select * from scriptScreenCategories where ScriptScreenID in (select oldScriptScreenID from #ScriptScreenmap)select * from scriptScreenCategories where ScriptScreenID in (select newScriptScreenID from #ScriptScreenmap)*/
DROP TABLE #ScriptScreenmap

DROP TABLE #Scriptmap
DROP TABLE #sqmap
SELECT @newSurveyID 
END



' 
END
GO
