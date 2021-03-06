/****** Object:  StoredProcedure [dbo].[hos2004_SurveyDisposition]    Script Date: 08/11/2006 13:09:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyDisposition]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SurveyDisposition]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SurveyDisposition]    Script Date: 08/11/2006 13:09:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyDisposition]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE   PROCEDURE [dbo].[hos2004_SurveyDisposition]
(
	@RespondentID int,
	@UserID int
)
 AS
BEGIN

DELETE FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3040,3041,3042) AND EventParameters LIKE ''hos2004_SurveyDisposition:%''

DECLARE @SURVEY_DISPOSITION_CODE varchar(100)
SET @SURVEY_DISPOSITION_CODE = ''SURVEY_DISPOSITION''

DECLARE @EventID int
SET @EventID = 0

-- M: Ineligible or deceased
IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4004)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M20''
    -- Set all responses to missing
    EXEC [dbo].[clear_Responses] @RespondentID
    EXEC [dbo].[fill_MissingResponses] @RespondentID, @UserID
    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Responses cleared due to deceased respondentM20.''
  END
-- T: Ineligible or deceased
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5014)
  BEGIN
    SET @EventID = 5014
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T20''
    -- Set all responses to missing
    EXEC [dbo].[clear_Responses] @RespondentID
    EXEC [dbo].[fill_MissingResponses] @RespondentID, @UserID
    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Responses cleared due to deceased respondentT20.''
  END
-- M: complete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3012)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M10''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- T: complete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3022, 3032, 3035))
  BEGIN
    SET SELECT TOP 1 @EventID = EventID FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2031, 2033, 2041) ORDER BY EventDate DESC
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T10''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: partially complete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3011)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M11''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- T: partially complete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3021, 3031, 3034))
  BEGIN
    SET SELECT TOP 1 @EventID = EventID FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2031, 2033, 2041) ORDER BY EventDate DESC
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T11''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: incomplete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3010)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M31''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- T: incomplete survey
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3020, 3030, 3033))
  BEGIN
    SET SELECT TOP 1 @EventID = EventID FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2031, 2033, 2041) ORDER BY EventDate DESC
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T31''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: language barrier
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4006)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M23''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- T: language barrier
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5016)
  BEGIN
    SET @EventID = 5016
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T23''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- M: refusal
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4007)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M32''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- T: refusal
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5017)
  BEGIN
    SET @EventID = 5017
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T32''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- M: unavailable
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4008)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M33''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- T: unavailable
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5018)
  BEGIN
    SET @EventID = 5018
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T33''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- M: physically/mentally incapacitated
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4009)
  BEGIN  
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M34''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- T: physically/mentally incapacitated
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5019)
  BEGIN
    SET @EventID = 5019
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T34''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- M: institutionalized
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4010)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M35''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
  END
-- T: institutionalized
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5020)
  BEGIN
    SET @EventID = 5020
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T35''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: bad address/telephone
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 2062)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T24''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: Max mail attempts
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 6034)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M36''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- T: Max telephone attempts
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2063, 6033))
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T36''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: Disenrolled
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4005)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M21''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- T: Disenrolled
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5015)
  BEGIN
    SET @EventID = 5015
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T21''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- M: End stage renal
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 4012)
  BEGIN
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''M22''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- T: End stage renal
ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5998)
  BEGIN
    SET @EventID = 5998
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DISPOSITION_CODE, ''T22''
    -- Flag if there are responses
    IF dbo.HasHosSurveyResponses(@RespondentID) = 1
      EXEC insert_EventLog @EventLogID = NULL, @EventID = 3042, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Has survey responses, please review.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END
-- Unable to determine survey disposition, flag respondent
ELSE
  BEGIN
    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3041, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDisposition: Unable to determine survey disposition.''
    EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID
  END

-- Set CATI Interview property
EXEC dbo.hos2004_SetCATIInterview @RespondentID, @UserID, @EventID

END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SurveyDisposition] TO [reporter]
GO
