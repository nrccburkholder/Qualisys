/****** Object:  StoredProcedure [dbo].[hos2004_SurveyRound]    Script Date: 08/09/2006 16:28:23 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyRound]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SurveyRound]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SurveyRound]    Script Date: 08/09/2006 16:28:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyRound]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE    PROCEDURE [dbo].[hos2004_SurveyRound] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

DELETE FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3040 AND EventParameters LIKE ''hos2004_SurveyRound:%''

DECLARE @SURVEY_ROUND_CODE varchar(100)
SET @SURVEY_ROUND_CODE = ''SURVEY_ROUND''

-- Mailed survey completed by telephone
IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''T10'', ''T11'', ''T31'') 
  AND EXISTS (SELECT 1 FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID = 2006)) 
  EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''MT''
-- Mailing
ELSE IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''M10'', ''M11'', ''M31'') 
  BEGIN
    IF EXISTS (SELECT 1 FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID = 2006) AND (EventParameters = ''1''))
      EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''M1''
    ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID = 2006) AND ((EventParameters = '''') OR (EventParameters IS NULL)))
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyRound: Missing mailing id in batching code, unable to determine survey round.''
    ELSE
      EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''M2''
	  
  END

-- Telephone
ELSE IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''T10'', ''T11'', ''T31'') 
  BEGIN
    DECLARE @CallCount int
    SET SELECT @CallCount = CallsMade FROM Respondents WHERE RespondentID = @RespondentID
    
    IF (@CallCount = 0 OR @CallCount = 1)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T1''
	ELSE IF (@CallCount = 2)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T2''
	ELSE IF (@CallCount = 3)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T3''
	ELSE IF (@CallCount = 4)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T4''
	ELSE IF (@CallCount = 5)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T5''
	ELSE IF (@CallCount > 5 )
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T6''
	ELSE
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyRound: Missing calls made, unable to determine survey round.''
		
  END

-- Non-completion
ELSE
	EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''NC''
	
END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SurveyRound] TO [reporter]
GO
