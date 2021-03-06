/****** Object:  StoredProcedure [dbo].[get_Household]    Script Date: 08/09/2006 15:23:17 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_Household]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_Household]
GO
/****** Object:  StoredProcedure [dbo].[get_Household]    Script Date: 08/09/2006 15:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_Household]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE dbo.get_Household (@RespondentID int) 
AS
BEGIN

DECLARE @TelephoneDay varchar(10)
DECLARE @TelephoneEvening varchar(10)
DECLARE @ClientID int
DECLARE @SurveyInstanceDate datetime

SET	SELECT     @TelephoneDay = Respondents.TelephoneDay, @TelephoneEvening = Respondents.TelephoneEvening, 
		      @ClientID = SurveyInstances.ClientID, @SurveyInstanceDate = SurveyInstances.InstanceDate
	FROM         Respondents INNER JOIN SurveyInstances ON Respondents.SurveyInstanceID = SurveyInstances.SurveyInstanceID
	WHERE     (Respondents.RespondentID = @RespondentID)


SELECT DISTINCT     RespondentID, FirstName, LastName, SurveyName, ClientName, SurveyInstanceName
FROM         	          v_HouseholdsByTelephone
WHERE     	         (RespondentID <> @RespondentID) AND (Telephone IN (@TelephoneDay, @TelephoneEvening)) 
		         AND (ClientID = @ClientID) AND (InstanceDate = @SurveyInstanceDate)
                      
END


' 
END
GO
GRANT EXECUTE ON [dbo].[get_Household] TO [reporter]
GO
