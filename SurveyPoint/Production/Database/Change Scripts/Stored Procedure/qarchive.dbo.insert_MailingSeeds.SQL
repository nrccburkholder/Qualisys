/****** Object:  StoredProcedure [dbo].[insert_MailingSeeds]    Script Date: 08/09/2006 16:55:59 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_MailingSeeds]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_MailingSeeds]
GO
/****** Object:  StoredProcedure [dbo].[insert_MailingSeeds]    Script Date: 08/09/2006 16:55:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_MailingSeeds]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [insert_MailingSeeds]
	(@RespondentID 	[int] output,
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
	 @Email 	[varchar](50))

AS 
BEGIN

INSERT INTO [QMS].[dbo].[Respondents] 
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
	 [MailingSeedFlag]) 
 
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
	 @Email, 1)

SELECT @RespondentID = @@IDENTITY

END



' 
END
GO
