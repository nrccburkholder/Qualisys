/****** Object:  StoredProcedure [dbo].[cahps_FinalizeRespondent]    Script Date: 08/08/2006 14:05:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_FinalizeRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_FinalizeRespondent]
GO
/****** Object:  StoredProcedure [dbo].[cahps_FinalizeRespondent]    Script Date: 08/08/2006 14:05:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_FinalizeRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE [dbo].[cahps_FinalizeRespondent] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
-- Clear previous audit flags
DELETE FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3040 AND EventParameters LIKE ''cahps_%''

-- Get survey id of the respondent
DECLARE @SurveyID int
SET @SurveyID = [dbo].GetRespondentSurveyID(@RespondentID) 

-- Check that respondent is in correct survey, if not correct survey - flag and exit routine
IF (@SurveyID NOT IN (19, 27, 28, 29, 30))
	BEGIN
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_FinalizeRespondent: Finalize routine not run for respondent. Does not belong to a listed survey.''
		RETURN	
	END

-- Delete Appropriately Skipped Responses, So the appropriately skipped routine may be re-run
DELETE FROM Responses 
	WHERE  ResponseID IN 
	(SELECT     ResponseID
	FROM         Responses INNER JOIN
	                      AnswerCategories ON Responses.AnswerCategoryID = AnswerCategories.AnswerCategoryID
	WHERE     (AnswerCategories.AnswerText LIKE ''Appropriately Skipped'') AND (Responses.RespondentID = @RespondentID))

-- Run cahps routines
EXEC cahps_SurveyDisposition @RespondentID, @UserID
EXEC cahps_SurveyRound @RespondentID, @UserID
EXEC cahps_SurveyLanguage @RespondentID, @UserID
EXEC cahps_MemberGender @RespondentID, @UserID
EXEC cahps_MemberYearOfBirth @RespondentID, @UserID
EXEC cahps_MemberCity @RespondentID, @UserID
EXEC cahps_MemberState @RespondentID, @UserID
EXEC cahps_MemberCity @RespondentID, @UserID
EXEC cahps_FluShot @RespondentID, @UserID
IF @SurveyID IN (27, 29)
	BEGIN
	EXEC cahps_PrescreenStatusCode @RespondentID, @UserID
	EXEC cahps_SampleCode @RespondentID, @UserID
	END
EXEC cahps_MCOAddress @RespondentID, @UserID
EXEC cahps_MCOTelephone @RespondentID, @UserID
	EXEC fill_MissingResponses @RespondentID, @UserID
IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''M10'', ''M31'', ''T10'', ''T31'')
	BEGIN
	EXEC cahps_AppropriatelySkipped @RespondentID, @UserID
	EXEC cahps_InappropriatelySkipped @RespondentID, @UserID
	END

END
' 
END
GO
