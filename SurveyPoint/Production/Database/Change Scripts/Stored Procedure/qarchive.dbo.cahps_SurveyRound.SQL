/****** Object:  StoredProcedure [dbo].[cahps_SurveyRound]    Script Date: 08/08/2006 14:38:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SurveyRound]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_SurveyRound]
GO
/****** Object:  StoredProcedure [dbo].[cahps_SurveyRound]    Script Date: 08/08/2006 14:38:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SurveyRound]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE    PROCEDURE [dbo].[cahps_SurveyRound] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
DECLARE @SURVEY_ROUND_CODE varchar(100)
SET @SURVEY_ROUND_CODE = ''SURVEY_ROUND''

-- Mailed survey completed by telephone
IF EXISTS (SELECT 1 FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID = 2006)) 
  AND EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3022, 3032, 3035))
  AND (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 1)
  EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''MT''
-- Mailing
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3012))
  AND (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 1)
  BEGIN
    DECLARE @SurveyMailings int
    DECLARE @SurveyInstanceID int

    SET SELECT @SurveyMailings = COUNT(*) FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID = 4000)
    SET SELECT @SurveyInstanceID = SurveyInstanceID FROM Respondents WHERE (RespondentID = @RespondentID) 

    IF @SurveyMailings = 1
      EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''M1''
    ELSE IF @SurveyMailings > 1 AND @SurveyInstanceID NOT IN (601)
      EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''M2''
    ELSE IF @SurveyMailings = 2 AND @SurveyInstanceID IN (601)
      EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''M2''
    ELSE IF @SurveyMailings > 2 AND @SurveyInstanceID IN (601)
      EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''M3''
    ELSE
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyRound: Has verification complete, but no mailing code.''

  END

-- Telephone
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3022, 3032, 3035))
  AND (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 1)
  BEGIN
    DECLARE @CallCount int
    SET SELECT @CallCount = CallsMade FROM Respondents WHERE RespondentID = @RespondentID
    
    IF (@CallCount = 0 OR @CallCount = 1)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T1''
	ELSE IF (@CallCount = 2)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T2''
	ELSE IF (@CallCount > 2)
		EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''T3''
	ELSE
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyRound: Has cati complete, but no call codes.''
		
  END

-- Non-completion
ELSE
	EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_ROUND_CODE, ''NC''
	
END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_SurveyRound] TO [reporter]
GO
