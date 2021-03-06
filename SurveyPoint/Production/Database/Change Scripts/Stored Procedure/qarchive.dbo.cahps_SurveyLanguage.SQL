/****** Object:  StoredProcedure [dbo].[cahps_SurveyLanguage]    Script Date: 08/08/2006 14:29:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SurveyLanguage]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_SurveyLanguage]
GO
/****** Object:  StoredProcedure [dbo].[cahps_SurveyLanguage]    Script Date: 08/08/2006 14:29:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SurveyLanguage]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_SurveyLanguage] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @SURVEY_LANGUAGE varchar(50)
	SET @SURVEY_LANGUAGE = ''SURVEY_LANGUAGE ''

	IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3012, 3022, 3010, 3020)) AND (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 1)
	BEGIN
		DECLARE @SurveyInstanceID int
		SET SELECT @SurveyInstanceID = SurveyInstanceID FROM Respondents WHERE RespondentID = @RespondentID
	
		IF @SurveyInstanceID IN (605)
			EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''2'' -- Spanish
		ELSE
			EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''1'' -- English

	END
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_LANGUAGE, ''3'' -- NA

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_SurveyLanguage] TO [reporter]
GO
