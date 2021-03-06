/****** Object:  StoredProcedure [dbo].[check_HasHousehold]    Script Date: 08/08/2006 14:39:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[check_HasHousehold]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[check_HasHousehold]
GO
/****** Object:  StoredProcedure [dbo].[check_HasHousehold]    Script Date: 08/08/2006 14:39:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[check_HasHousehold]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[check_HasHousehold] 
(
	@RespondentID int
)
AS
BEGIN
/*
Check if respondent has telephone
respondents with no telephone should NEVER go thru get_HouseholdFromCallList
get_HouseholdFromCallList will not be able to match these respondents.
Always process these respondent using get_RespondentFromCallList
*/
DECLARE @NoTelephone int
SET @NoTelephone = 
	 (SELECT CASE isnull(TelephoneDay, '''') WHEN '''' THEN 
		CASE isnull(TelephoneEvening, '''') WHEN '''' THEN 
		1 ELSE 0 END 
	ELSE 0 END
	FROM         Respondents
	WHERE     RespondentID = @RespondentID)

/*
Check if respondent belongs to a survey instance with household grouping.  Also get the client id and the 
survey telephone day 
*/
DECLARE @GroupByHousehold int
SET @GroupByHousehold = (SELECT     SurveyInstances.GroupByHousehold
			FROM         SurveyInstances INNER JOIN
                      Respondents ON SurveyInstances.SurveyInstanceID = Respondents.SurveyInstanceID
			WHERE     (Respondents.RespondentID = @RespondentID))

IF @GroupByHousehold = 0 OR @NoTelephone = 1
	/* No Household*/
	SELECT 0
ELSE
BEGIN
	/* Check for multiple respondents in household*/
	DECLARE @HouseholdCount int
	SET @HouseholdCount = (SELECT dbo.GetHouseholdCount(@RespondentID))
	
	IF @HouseholdCount > 0 
		/*Has Household*/
		SELECT 1
	ELSE
		SELECT 0

END
	
END

' 
END
GO
GRANT EXECUTE ON [dbo].[check_HasHousehold] TO [reporter]
GO
