/****** Object:  StoredProcedure [dbo].[spFileDefColumns]    Script Date: 08/09/2006 12:58:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spFileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spFileDefColumns]
GO
/****** Object:  StoredProcedure [dbo].[spFileDefColumns]    Script Date: 08/09/2006 12:58:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spFileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.spFileDefColumns
	@filedefid int
AS
BEGIN
	--prepares a list of data columns, questions, and properties that could be included in an import/export.
	--djw 7/25/2002

	DECLARE @t TABLE (name varchar(250))
	DECLARE @fdtype int

	SET @fdtype = (SELECT FileDefTypeId FROM FileDefs WHERE FileDefId = @filedefid)
	
	-- Respondent table columns
	IF @fdtype = 1
		INSERT INTO @t
		SELECT ''Respondent: '' + UPPER(sc.name) AS identifier FROM 
    		syscolumns sc INNER JOIN sysobjects so ON sc.id = so.id 
		WHERE so.name LIKE ''vw_Respondents'' ORDER BY colid
	ELSE
		INSERT INTO @t
		SELECT ''Respondent: '' + UPPER(sc.name) AS identifier FROM 
    		syscolumns sc INNER JOIN sysobjects so ON sc.id = so.id 
		WHERE so.name LIKE ''Respondents'' AND UPPER(sc.name) NOT IN (''MAILINGSEEDFLAG'',''BATCHID'') ORDER BY colid
	
	-- Exisiting respondent properties
	INSERT INTO @t
		SELECT * FROM
		(
			select  ''Property: '' + UPPER(PropertyName) AS [name]
			from filedefs fd,surveyinstances si,surveyInstanceProperties sip
			where fd.filedefid=@filedefid
			and si.surveyid = fd.surveyid
			and si.surveyinstanceid = sip.surveyinstanceid
			union
			select ''Property: '' + UPPER(PropertyName) AS [name]
			from filedefs fd,surveyinstances si,surveyinstanceproperties sip
			where fd.filedefid=@filedefid
			and si.clientid = fd.clientid
			and si.surveyinstanceid = sip.surveyinstanceid
		) x
		ORDER BY [name]

	-- Include survey question columns for exports only
	IF @fdtype = 1
	BEGIN
		INSERT INTO @t
		SELECT     ''Q'' + CAST(dbo.vr_SurveyQuestions.SurveyQuestionOrder AS varchar) + ''.'' + CAST(dbo.vr_SurveyQuestions.QuestionPartID AS varchar) 
					+ '': '' + CAST(dbo.vr_Questions.QuestionDesc AS varchar(100)) AS Question
		FROM         dbo.vr_SurveyQuestions INNER JOIN
					dbo.vr_Questions ON dbo.vr_SurveyQuestions.QuestionID = dbo.vr_Questions.QuestionID AND 
					dbo.vr_SurveyQuestions.QuestionPartID = dbo.vr_Questions.QuestionPartID
		WHERE SurveyID = (SELECT SurveyID FROM FileDefs WHERE FileDefID = @FileDefID)
		ORDER BY dbo.vr_SurveyQuestions.SurveyID, dbo.vr_SurveyQuestions.SurveyQuestionOrder

		INSERT INTO @t
		SELECT     ''Q'' + CAST(dbo.vr_SurveyQuestions.SurveyQuestionOrder AS varchar(100)) + ''.'' + CAST(dbo.vr_SurveyQuestions.QuestionPartID AS varchar) 
					+ '' DESC: '' + CAST(dbo.vr_Questions.QuestionDesc AS varchar(100)) AS Question
		FROM         dbo.vr_SurveyQuestions INNER JOIN
					dbo.vr_Questions ON dbo.vr_SurveyQuestions.QuestionID = dbo.vr_Questions.QuestionID AND 
					dbo.vr_SurveyQuestions.QuestionPartID = dbo.vr_Questions.QuestionPartID
		WHERE SurveyID = (SELECT SurveyID FROM FileDefs WHERE FileDefID = @FileDefID)
		ORDER BY dbo.vr_SurveyQuestions.SurveyID, dbo.vr_SurveyQuestions.SurveyQuestionOrder

	END

	SELECT * FROM @t

END
' 
END
GO
GRANT EXECUTE ON [dbo].[spFileDefColumns] TO [reporter]
GO
