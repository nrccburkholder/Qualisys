/****** Object:  StoredProcedure [dbo].[update_Respondents]    Script Date: 08/09/2006 10:18:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Respondents]
GO
/****** Object:  StoredProcedure [dbo].[update_Respondents]    Script Date: 08/09/2006 10:18:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'






CREATE PROCEDURE update_Respondents
	(@RespondentID 	[int],
	 @SurveyInstanceID 	[int],
	 @FirstName 	[varchar](100),
	 @MiddleInitial 	[varchar](10),
	 @LastName 	[varchar](100),
	 @Address1 	[varchar](250),
	 @Address2 	[varchar](250),
	 @City 	[varchar](100),
	 @State 	[char](2),
	 @PostalCode 	[varchar](50),
	 @TelephoneDay 	[varchar](50),
	 @TelephoneEvening 	[varchar](50),
	 @Email 	[varchar](50),
	 @DOB 	[datetime],
	 @Gender 	[char](1),
	 @ClientRespondentID 	[varchar](50),
	 @SSN 	[varchar](50),
	 @BatchID 	[int],
	 @SurveyID [int] OUTPUT,
	 @ClientID [int] OUTPUT,
	 @SurveyInstanceName [varchar](100) OUTPUT,
	 @SurveyName [varchar](100) OUTPUT,
	 @ClientName [varchar](100) OUTPUT, 
	 @PostalCodeExt [varchar](10) = null)

AS 

UPDATE [Respondents] 

SET  [SurveyInstanceID]	 = @SurveyInstanceID,
	 [FirstName]	 = @FirstName,
	 [MiddleInitial]	 = @MiddleInitial,
	 [LastName]	 = @LastName,
	 [Address1]	 = @Address1,
	 [Address2]	 = @Address2,
	 [City]	 = @City,
	 [State]	 = @State,
	 [PostalCode]	 = @PostalCode,
	 [TelephoneDay]	 = @TelephoneDay,
	 [TelephoneEvening]	 = @TelephoneEvening,
	 [Email]	 = @Email,
	 [DOB]	 = @DOB,
	 [Gender]	 = @Gender,
	 [ClientRespondentID]	 = @ClientRespondentID,
	 [SSN]	 = @SSN,
	 [BatchID]	 = @BatchID,
	 [PostalCodeExt] = @PostalCodeExt

WHERE 
	( [RespondentID]	 = @RespondentID)
	
SELECT @SurveyID = SurveyID, @ClientID = ClientID, @SurveyInstanceName = SurveyInstanceName,
       @SurveyName = SurveyName, @ClientName = ClientName FROM vw_Respondents 
       WHERE RespondentID = @RespondentID

' 
END
GO
