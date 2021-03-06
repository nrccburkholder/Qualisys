/****** Object:  StoredProcedure [dbo].[senior_PostProcessing]    Script Date: 08/10/2006 10:09:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[senior_PostProcessing]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[senior_PostProcessing]
GO
/****** Object:  StoredProcedure [dbo].[senior_PostProcessing]    Script Date: 08/10/2006 10:09:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[senior_PostProcessing]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[senior_PostProcessing] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
-- Get survey id of the respondent
DECLARE @SurveyID int
SET @SurveyID = [dbo].GetRespondentSurveyID(@RespondentID) 

-- Check that respondent is in correct survey, if not correct survey - flag and exit routine
IF (@SurveyID NOT IN (8, 24, 31))
	BEGIN
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''senior_PostProcessing: Finalize routine not run for respondent. Does not belong to a listed survey.''
		RETURN	
	END

EXEC compute_SeniorScoresForRespondent @RespondentID
EXEC senior_CheckAudits @RespondentID, @UserID
EXEC compute_SeniorRiskFactorDummyQuestion @RespondentID
EXEC insert_SeniorHealthScores @RespondentID

/* Set Birthdate Property */
DECLARE @dob datetime
SET SELECT @dob = DOB FROM Respondents WHERE RespondentID = @RespondentID
IF @dob IS NOT NULL EXEC set_DateProperty @RespondentID, ''DATE_OF_BIRTH'', @dob

END
' 
END
GO
GRANT EXECUTE ON [dbo].[senior_PostProcessing] TO [reporter]
GO
