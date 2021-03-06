/****** Object:  StoredProcedure [dbo].[hos2004_SurveyLanguage]    Script Date: 08/09/2006 16:27:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyLanguage]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SurveyLanguage]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SurveyLanguage]    Script Date: 08/09/2006 16:27:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyLanguage]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[hos2004_SurveyLanguage] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @SURVEY_LANGUAGE varchar(50)
	SET @SURVEY_LANGUAGE = ''SURVEY_LANGUAGE ''

	IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''T10'', ''T11'', ''T31'') 
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''1'' -- English
	ELSE IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''M10'', ''M11'', ''M31'') 
	BEGIN
		DECLARE @SurveyInstanceID int
		SET SELECT @SurveyInstanceID = SurveyInstanceID FROM Respondents WHERE RespondentID = @RespondentID
	
		IF @SurveyInstanceID IN (76, 77, 78, 409, 811, 812, 814,927) 
			EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''1'' -- English
		ELSE IF @SurveyInstanceID IN (79, 810, 813)
			EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''2'' -- Spanish
		ELSE IF @SurveyInstanceID IN (81, 815)
			EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''4'' -- Chinese
		ELSE
			EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''3'' -- NA

	END
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''3'' -- NA

END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SurveyLanguage] TO [reporter]
GO
