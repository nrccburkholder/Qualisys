/****** Object:  StoredProcedure [dbo].[create_DXView]    Script Date: 08/09/2006 13:36:49 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[create_DXView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[create_DXView]
GO
/****** Object:  StoredProcedure [dbo].[create_DXView]    Script Date: 08/09/2006 13:36:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[create_DXView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE              PROCEDURE create_DXView (
	@SurveyID  int
)
AS
BEGIN

SET NOCOUNT ON

DECLARE @DXTable TABLE
(
	phase int,
	itemorder int,
	textorder varchar(1000),
	subphase int,
	item varchar(6800)
)

DECLARE @viewname varchar(25)

SET @viewname = ''xv_SurveyID_'' + CAST(@SurveyID as varchar(10))

-- Respondent table columns
INSERT INTO @DXTable(phase, itemorder, textorder, subphase, item)
SELECT 1 phase, 1 itemorder, ''x'' textorder, 1 subphase,
''CREATE VIEW ''+ dbo.dxv_column_name(@viewname) + '' AS 
SELECT 
r.RespondentID, 
r.RespondentKey, 
r.SurveyInstanceID, 
r.FirstName, 
r.MiddleInitial, 
r.LastName, 
r.Address1, 
r.Address2, 
r.City, 
r.State, 
r.PostalCode, 
r.PostalCodeExt, 
r.TelephoneDay, 
r.TelephoneEvening, 
r.Email, 
r.DOB, 
r.Gender, 
r.ClientRespondentID, 
r.SSN, 
r.BatchID, 
r.MailingSeedFlag, 
si.[Name] AS SurveyInstanceName, 
c.[Name] AS ClientName, 
c.ClientID, 
r.CallsMade, 
r.Final, 
r.NextContact, 
dbo.CompletionAge(r.RespondentID) AS CompletionAge, 
p.name AS ProtocolName, '' + 
CAST(SurveyID AS varchar(10)) + '' AS SurveyID, 
'''''' + Name + '''''' AS SurveyName'' AS item
FROM Surveys
WHERE SurveyID = @SurveyID
UNION ALL
-- Answer values for single select question type
SELECT 2 phase, sq.ItemOrder, '''', 1 subphase,
  '', 
dbo.dxv_response_value(r.RespondentID, '' + 
    CONVERT(varchar(10),sq.SurveyquestionID) + '') as Q'' + CONVERT(varchar(10), sq.ItemOrder) + ''_0'' AS item 
FROM surveyQuestions sq, questions q
LEFT OUTER JOIN AnswerCategories ac
ON q.QuestionID = ac.QuestionID
WHERE sq.SurveyID = @SurveyID
AND sq.QuestionID = q.QuestionID
AND q.QuestionTypeID = 1
GROUP BY sq.SurveyQuestionID, sq.ItemOrder, ShortDesc
HAVING COUNT(*) > 1 -- so if there is one answer category,  skip the value,  and just show the text
UNION ALL
-- Answer texts for single select question type
SELECT 2 AS phase, sq.ItemOrder, '''' AS Expr1, 2 AS subphase, 
   '', 
dbo.dxv_response_text(r.RespondentID, '' + 
   CONVERT(varchar(10), sq.SurveyQuestionID) +
   '') AS Q'' + CONVERT(varchar(10), sq.ItemOrder) + 
   ''_0_DESC'' AS item
FROM SurveyQuestions sq, Questions q
WHERE sq.SurveyID = @SurveyID
AND sq.questionID = q.QuestionID
AND q.QuestionTypeID = 1
UNION ALL 
-- Answer values for other question types
select 2 phase, sq.ItemOrder, '''', ac.AnswerValue subphase,
   '', 
dbo.dxv_is_Selected(r.RespondentID, '' + 
   CONVERT(varchar(10), ac.AnswerCategoryID) +
   '') AS Q'' + CONVERT(varchar(10), sq.ItemOrder) + 
   ''_'' + CONVERT(varchar(10), ac.AnswerValue) AS item
FROM SurveyQuestions sq, Questions q, AnswerCategories ac
WHERE sq.SurveyID = @SurveyID
AND sq.QuestionID = q.QuestionID
AND q.QuestionTypeID <> 1
AND q.QuestionID = ac.QuestionID
UNION ALL
-- Answer text for other question types
select 2 phase, sq.ItemOrder, '''', ac.AnswerValue subphase,
   '', 
dbo.dxv_response_text_multi(r.RespondentID, '' + 
   CONVERT(varchar(10), ac.AnswerCategoryID) +
   '') AS Q'' + CONVERT(varchar(10), sq.ItemOrder) + 
   ''_'' + CONVERT(varchar(10), ac.AnswerValue) + ''_DESC'' AS item
FROM SurveyQuestions sq, Questions q, AnswerCategories ac
WHERE sq.SurveyID = @SurveyID
AND sq.QuestionID = q.QuestionID
AND q.QuestionTypeID <> 1
AND q.QuestionID = ac.QuestionID
UNION ALL
-- Respondent properties
SELECT DISTINCT 3, 1, PropertyName, 1,
   '', 
dbo.dxv_Respondent_PropertyValue(r.RespondentID, '''''' + PropertyName + '''''') AS '' + 
	dbo.dxv_column_name (''PROPERTY_'' + PropertyName)
FROM surveyinstanceproperties sip,
   SurveyInstances si
   WHERE si.SurveyID = @SurveyID
     AND sip.SurveyInstanceID = si.SurveyInstanceID
UNION ALL
SELECT 4, 1, '''', 1,
   '' FROM SurveyInstances si, Protocols p, Clients c, Respondents r
WHERE si.SurveyID = '' + convert(varchar(10),@SurveyID) + '' 
AND si.ProtocolID = p.ProtocolID
AND si.ClientID = c.ClientID
AND si.SurveyInstanceID = r.SurveyInstanceID''

SELECT item FROM @DXTable 
ORDER BY phase, itemorder, subphase


END
' 
END
GO
GRANT EXECUTE ON [dbo].[create_DXView] TO [reporter]
GO
