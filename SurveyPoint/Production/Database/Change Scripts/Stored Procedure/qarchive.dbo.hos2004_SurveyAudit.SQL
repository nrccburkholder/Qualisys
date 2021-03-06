/****** Object:  StoredProcedure [dbo].[hos2004_SurveyAudit]    Script Date: 08/09/2006 16:21:45 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyAudit]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SurveyAudit]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SurveyAudit]    Script Date: 08/09/2006 16:21:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyAudit]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE    PROCEDURE [dbo].[hos2004_SurveyAudit] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

DELETE FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3040 AND EventParameters LIKE ''hos2004_SurveyAudit:%''

IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3020, 3021, 3022, 3030, 3031, 3032, 3033, 3034, 3035))
	AND ISNULL(dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_ROUND'') , '''') <> ''MT''
BEGIN
	IF dbo.GetResponseAnswerValue(@RespondentID, ''birth year'') = 1 
	  IF (NOT EXISTS (SELECT 1 FROM Respondents WHERE (RespondentID = @RespondentID) AND (CAST(YEAR(DOB) AS varchar(4)) = dbo.GetResponseText(@RespondentID, ''birth year''))))
	    EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Respondent birth year does not match''
	
	IF (dbo.GetResponseAnswerValue(@RespondentID, ''male or female'')  IN (1,2)) AND (NOT EXISTS (SELECT 1 FROM Respondents WHERE (RespondentID = @RespondentID) AND (Gender = CASE dbo.GetResponseAnswerValue(@RespondentID, ''male or female'') WHEN 1 THEN ''M'' WHEN 2 THEN ''F'' ELSE '''' END)))
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Respondent gender does not match''
	
	IF dbo.HasQuestionResponses(@RespondentID, ''Days mental/physical health restricted activities'') = 1 AND
		ISNULL(dbo.GetResponseText(@RespondentID, ''Days physical health not good''), ''0'') IN (''0'', ''00'') AND
		ISNULL(dbo.GetResponseText(@RespondentID, ''Days mental health not good''), ''0'') IN (''0'', ''00'')
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Days mental/physical health restricted activities should be unanswered''
	  
	IF dbo.HasQuestionResponses(@RespondentID, ''Arthritis pain level'') = 1 AND 
		ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Arthritis of the hip or knee''), 9) <> 1 AND
		ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Arthritis of the hand or wrist''), 9) <> 1
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Arthritis pain level should be unanswered''
	
	IF dbo.HasQuestionResponses(@RespondentID, ''Colon or rectal cancer'') = 1 AND 
		ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Any cancer''), 9) <> 1
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Colon or rectal cancer should be unanswered''
	
	IF dbo.HasQuestionResponses(@RespondentID, ''Lung cancer'') = 1 AND 
		ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Any cancer''), 9) <> 1
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Lung cancer should be unanswered''
	
	IF dbo.HasQuestionResponses(@RespondentID, ''Breast cancer'') = 1 AND 
		ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Any cancer''), 9) <> 1
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Breast cancer should be unanswered''
	
	IF dbo.HasQuestionResponses(@RespondentID, ''Prostate cancer'') = 1 AND 
		(ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Any cancer''), 9) <> 1 OR
		ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''Male or female''), 9) <> 1)
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: Prostate cancer should be unanswered''

	IF (dbo.HasQuestionResponses(@RespondentID, ''level of problem with urine leakage'') = 1
		AND ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''urine leakage within last 6 months''), 9) <> 1)
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: level of problem with urine leakage with should be unanswered''
	
	IF (dbo.HasQuestionResponses(@RespondentID, ''discussed urine leakage with doctor'') = 1
		AND ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''level of problem with urine leakage''), 9) NOT IN (1, 2))
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: discussed urine leakage with doctor with should be unanswered''
	
	IF (dbo.HasQuestionResponses(@RespondentID, ''any treatment for urine leakage problem'') = 1
		AND ISNULL(dbo.GetResponseAnswerValue(@RespondentID, ''discussed urine leakage with doctor''), 9) <> 1)
	  EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyAudit: discussed urine leakage with doctor with should be unanswered''

END

END

' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SurveyAudit] TO [reporter]
GO
