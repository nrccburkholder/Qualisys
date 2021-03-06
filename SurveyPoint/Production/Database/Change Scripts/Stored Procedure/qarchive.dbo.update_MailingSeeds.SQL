/****** Object:  StoredProcedure [dbo].[update_MailingSeeds]    Script Date: 08/09/2006 12:54:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_MailingSeeds]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_MailingSeeds]
GO
/****** Object:  StoredProcedure [dbo].[update_MailingSeeds]    Script Date: 08/09/2006 12:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_MailingSeeds]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [update_MailingSeeds]
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
	 @Email 	[varchar](50))

AS 
BEGIN

UPDATE [QMS].[dbo].[Respondents] 

SET   [SurveyInstanceID]	 = @SurveyInstanceID,
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
	 [MailingSeedFlag]	 = 1 

WHERE 
	( [RespondentID]	 = @RespondentID)

END


' 
END
GO
