/****** Object:  StoredProcedure [dbo].[cahps_SurveyDisposition]    Script Date: 08/08/2006 14:29:45 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SurveyDisposition]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_SurveyDisposition]
GO
/****** Object:  StoredProcedure [dbo].[cahps_SurveyDisposition]    Script Date: 08/08/2006 14:29:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SurveyDisposition]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[cahps_SurveyDisposition]
(
	@RespondentID int,
	@UserID int
)
 AS
BEGIN

DECLARE @SURVEY_DISPOSITION_CODE varchar(100)
SET @SURVEY_DISPOSITION_CODE = ''SURVEY_DISPOSITION''

-- M: Ineligible or deceased
IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4004)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M20''
    -- Set all responses to missing
    EXEC [dbo].[clear_Responses] @RespondentID
    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Responses cleared due to deceased respondentM20.''
  END
-- T: Ineligible or deceased
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5014)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T20''
    -- Set all responses to missing
    EXEC [dbo].[clear_Responses] @RespondentID
    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Responses cleared due to deceased respondentT20.''
  END
-- M: complete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3012) AND (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 1)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M10''
    IF dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 9
       EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Q1 = 9 on complete.''
  END
-- T: complete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3022, 3032, 3035)) AND (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 1)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T10''
    IF dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 9
       EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Q1 = 9 on complete.''
  END
-- M: incomplete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3010)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M31''
  END
-- T: incomplete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3020, 3030, 3033))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T31''
  END
-- M: Disenrolled
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4005) 
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M21''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''
  END
-- T: Disenrolled
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5015) 
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T21''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''
  END
-- T: Disenrolled discovered by survey
ELSE IF  (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 2) AND EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2031,2033, 2041)) 
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T21''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''    
  END
-- M: Disenrolled discovered by survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4005) 
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M21''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''    
  END
ELSE IF  (dbo.GetResponseAnswerValue(@RespondentID,''Health Plan in system is correct?'') = 2) 
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M21''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''    
  END
-- M: language barrier
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4006)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M22''
  END
-- T: language barrier
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5016)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T22''
  END
-- M: refusal
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4007)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M32''
  END
-- T: refusal
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5017)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T32''
  END
-- M: physically/mentally incapacitated
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4009)
  BEGIN  
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M24''
  END
-- T: physically/mentally incapacitated
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5019)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T24''
  END
-- M: bad address (mail-only protocols)
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2062, 4003) AND SurveyInstanceID IN (603))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M23''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''caphs_SurveyDisposition: Has survey responses, please review.''
  END
-- M: Max mail attempts
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (5001, 5002, 5003, 6034))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M33''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''
  END
-- T: bad address/telephone
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2062, 5001))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T23''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''
  END
-- T: Max telephone attempts
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2063, 6033))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T33''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Has survey responses, please review.''
  END
-- M: max mail attempts (mail-only protocols)
ELSE IF EXISTS (SELECT 1 FROM Respondents WHERE RespondentID = @RespondentID AND SurveyInstanceID IN (603))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M33''
    -- Flag if there are responses
    IF dbo.HasSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''caphs_SurveyDisposition: Has survey responses, please review.''
  END
-- Unable to determine survey disposition, flag respondent
ELSE
  BEGIN
    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SurveyDisposition: Unable to determine survey disposition.''
  END

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_SurveyDisposition] TO [reporter]
GO
