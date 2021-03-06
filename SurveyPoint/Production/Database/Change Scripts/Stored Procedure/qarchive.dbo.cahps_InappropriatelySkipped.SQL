/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped]    Script Date: 08/08/2006 14:06:26 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_InappropriatelySkipped]
GO
/****** Object:  StoredProcedure [dbo].[cahps_InappropriatelySkipped]    Script Date: 08/08/2006 14:06:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_InappropriatelySkipped]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_InappropriatelySkipped] 
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
		EXEC cahps_InappropriatelySkipped_AC @RespondentID, @UserID
	ELSE IF @SurveyID = 28
		EXEC cahps_InappropriatelySkipped_IBC @RespondentID, @UserID
	ELSE IF @SurveyID = 27
		EXEC cahps_InappropriatelySkipped_CC @RespondentID, @UserID
	ELSE IF @SurveyID = 29
		EXEC cahps_InappropriatelySkipped_CM @RespondentID, @UserID
	ELSE IF @SurveyID = 30
		EXEC cahps_InappropriatelySkipped_AC_Spanish @RespondentID, @UserID
	ELSE
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_InappropriatelySkipped: Skip routine not run for respondent. Does not belong to a listed survey.''

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_InappropriatelySkipped] TO [reporter]
GO
