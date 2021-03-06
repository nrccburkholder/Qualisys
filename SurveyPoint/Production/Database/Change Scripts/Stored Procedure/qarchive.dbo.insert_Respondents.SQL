/****** Object:  StoredProcedure [dbo].[insert_Respondents]    Script Date: 08/09/2006 16:37:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Respondents]
GO
/****** Object:  StoredProcedure [dbo].[insert_Respondents]    Script Date: 08/09/2006 16:37:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'






CREATE PROCEDURE insert_Respondents
	(@RespondentID 	[int] OUTPUT,
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
BEGIN

INSERT INTO [Respondents] 
	 ( [SurveyInstanceID],
	 [FirstName],
	 [MiddleInitial],
	 [LastName],
	 [Address1],
	 [Address2],
	 [City],
	 [State],
	 [PostalCode],
	 [TelephoneDay],
	 [TelephoneEvening],
	 [Email],
	 [DOB],
	 [Gender],
	 [ClientRespondentID],
	 [SSN],
	 [BatchID],
	 [MailingSeedFlag], 
	 [PostalCodeExt]) 
 
VALUES 
	(@SurveyInstanceID,
	 @FirstName,
	 @MiddleInitial,
	 @LastName,
	 @Address1,
	 @Address2,
	 @City,
	 @State,
	 @PostalCode,
	 @TelephoneDay,
	 @TelephoneEvening,
	 @Email,
	 @DOB,
	 @Gender,
	 @ClientRespondentID,
	 @SSN,
	 @BatchID,
	 0, 
	 @PostalCodeExt)

SET @RespondentID = @@IDENTITY

SELECT @SurveyID = SurveyID, @ClientID = ClientID, @SurveyInstanceName = SurveyInstanceName,
       @SurveyName = SurveyName, @ClientName = ClientName FROM vw_Respondents 
       WHERE RespondentID = @RespondentID

RETURN 

END

' 
END
GO
