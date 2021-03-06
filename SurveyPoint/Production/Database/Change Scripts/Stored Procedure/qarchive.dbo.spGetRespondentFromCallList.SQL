/****** Object:  StoredProcedure [dbo].[spGetRespondentFromCallList]    Script Date: 08/09/2006 12:57:49 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetRespondentFromCallList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spGetRespondentFromCallList]
GO
/****** Object:  StoredProcedure [dbo].[spGetRespondentFromCallList]    Script Date: 08/09/2006 12:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetRespondentFromCallList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE dbo.spGetRespondentFromCallList 
(
	@RespondentId int, 
	@UserId int,
	@LogEventId int
)
AS
BEGIN TRAN
/*
This procedure is tricky.
and there are two entirely different cases: normal respondents,  and respondents by household.
*/

IF (SELECT dbo.HasHousehold(@RespondentID)) = 0
	/* Lock respondent only - not part of household */
	EXEC get_RespondentFromCallList @RespondentID, @UserID, @LogEventID
ELSE
	/* lock all the records of the household */
	EXEC get_HouseholdFromCallList @RespondentID, @UserID, @LogEventID
	
COMMIT TRAN

' 
END
GO
GRANT EXECUTE ON [dbo].[spGetRespondentFromCallList] TO [reporter]
GO
