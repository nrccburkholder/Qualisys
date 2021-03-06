/****** Object:  StoredProcedure [dbo].[spInsertHouseholdEventLog]    Script Date: 08/09/2006 12:57:40 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spInsertHouseholdEventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spInsertHouseholdEventLog]
GO
/****** Object:  StoredProcedure [dbo].[spInsertHouseholdEventLog]    Script Date: 08/09/2006 12:57:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spInsertHouseholdEventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE dbo.spInsertHouseholdEventLog (  @RespondentID int,	-- The respondentID of one of the respondents in the household
  @userID int,			-- The userID that is doing the logging
  @EventID int,			-- the Event ID for the eventlog
  @EventParameters varchar(100)  -- The optional event Parameter.
) 
AS
/* This procedure will insert an eventlog for the respondent,  and also for any other
respondents in the same household.  A household is a collection of respondents with either
the same daytime telephone or the same nighttime telephone number-- who have the same client
and have a survey instance date that is the same */
BEGIN/* first of all- log an event under the current respondent id */INSERT INTO EventLog(EventID,UserID,RespondentID,EventParameters)VALUES (@EventID,@UserID,@RespondentID,@EventParameters)
/*OK - Find out the telephone number and client info for the event-- this will identify the household */DECLARE @TelephoneDay varchar(10)DECLARE @TelephoneEvening varchar(10)DECLARE @ClientID intDECLARE @SurveyInstanceDate datetime
SET	SELECT	@TelephoneDay = Respondents.TelephoneDay, @TelephoneEvening = Respondents.TelephoneEvening, 			@ClientID = SurveyInstances.ClientID, @SurveyInstanceDate = SurveyInstances.InstanceDate	FROM	Respondents INNER JOIN SurveyInstances ON Respondents.SurveyInstanceID = SurveyInstances.SurveyInstanceID	WHERE	(Respondents.RespondentID = @RespondentID)
/* Now insert any other respondents that are in the same household */INSERT INTO EventLog(EventID,UserID,RespondentID,EventParameters) SELECT DISTINCT	@EventID,@UserID,RespondentID,@EventParametersFROM			v_HouseholdsByTelephoneWHERE			(RespondentID <> @RespondentID) 				AND (Telephone IN (@TelephoneDay, @TelephoneEvening)) 				AND (ClientID = @ClientID) AND (InstanceDate = @SurveyInstanceDate)END

' 
END
GO
GRANT EXECUTE ON [dbo].[spInsertHouseholdEventLog] TO [reporter]
GO
