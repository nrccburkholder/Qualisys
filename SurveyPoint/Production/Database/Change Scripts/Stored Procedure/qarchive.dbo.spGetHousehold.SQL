/****** Object:  StoredProcedure [dbo].[spGetHousehold]    Script Date: 08/09/2006 12:57:58 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetHousehold]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spGetHousehold]
GO
/****** Object:  StoredProcedure [dbo].[spGetHousehold]    Script Date: 08/09/2006 12:57:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spGetHousehold]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE dbo.spGetHousehold (@RespondentID int) 
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
