/****** Object:  StoredProcedure [dbo].[hos2004_FinalizeRespondent]    Script Date: 08/09/2006 16:19:16 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_FinalizeRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_FinalizeRespondent]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_FinalizeRespondent]    Script Date: 08/09/2006 16:19:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_FinalizeRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE [dbo].[hos2004_FinalizeRespondent] 
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
IF (@SurveyID NOT IN (20, 32))
	BEGIN
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_FinalizeRespondent: Finalize routine not run for respondent. Does not belong to a listed survey.''
		RETURN	
	END

-- flag respondent that it has been processed by finalize routine
EXEC insert_EventLog @EventLogID = NULL, @EventID = 2400, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_FinalizeRespondent.''

-- run respondent thru finalize routines
EXEC dbo.fill_MissingResponses @RespondentID, @UserID
EXEC dbo.check_BadAddressAndTelephone @RespondentID, @UserID
EXEC dbo.hos2004_UpdateCompletionCode @RespondentID
EXEC dbo.hos2004_SurveyDisposition @RespondentID, @UserID
EXEC dbo.hos2004_SurveyRound @RespondentID, @UserID
EXEC dbo.hos2004_SurveyAudit @RespondentID, @UserID
EXEC dbo.hos2004_SurveyDate @RespondentID, @UserID
EXEC dbo.hos2004_MCOPhone @RespondentID, @UserID
EXEC dbo.hos2004_SpanishFlag @RespondentID, @UserID
EXEC dbo.hos2004_ExcludeFlag @RespondentID, @UserID
EXEC dbo.hos2004_SurveyLanguage @RespondentID, @UserID

END

SET QUOTED_IDENTIFIER OFF
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_FinalizeRespondent] TO [reporter]
GO
