/****** Object:  StoredProcedure [dbo].[cahps_AppropriatelySkipped]    Script Date: 08/09/2006 13:18:53 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_AppropriatelySkipped]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_AppropriatelySkipped]
GO
/****** Object:  StoredProcedure [dbo].[cahps_AppropriatelySkipped]    Script Date: 08/09/2006 13:18:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_AppropriatelySkipped]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE [dbo].[cahps_AppropriatelySkipped] 
(
	@RespondentID int, 
	@UserID int
)
AS
BEGIN
	DECLARE @SurveyID int

	-- get the survey id of the respondent
	SET SELECT @SurveyID =  si.SurveyID 
		FROM  Respondents r INNER JOIN SurveyInstances si 
		ON r.SurveyInstanceID = si.SurveyInstanceID
		WHERE     (r.RespondentID = @RespondentID)

	IF @SurveyID = 19
		EXEC cahps_AppropriatelySkipped_AC @RespondentID, @UserID
	ELSE IF @SurveyID = 28
		EXEC cahps_AppropriatelySkipped_IBC @RespondentID, @UserID
	ELSE IF @SurveyID = 27
		EXEC cahps_AppropriatelySkipped_CC @RespondentID, @UserID
	ELSE IF @SurveyID = 29
		EXEC cahps_AppropriatelySkipped_CM @RespondentID, @UserID
	ELSE IF @SurveyID = 30
		EXEC cahps_AppropriatelySkipped_AC_Spanish @RespondentID, @UserID
	ELSE
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_AppropriatelySkipped: Skip routine not run for respondent. Does not belong to a listed survey.''

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_AppropriatelySkipped] TO [reporter]
GO
