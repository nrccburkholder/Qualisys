/****** Object:  StoredProcedure [dbo].[set_MailingProperties]    Script Date: 08/09/2006 12:58:40 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_MailingProperties]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[set_MailingProperties]
GO
/****** Object:  StoredProcedure [dbo].[set_MailingProperties]    Script Date: 08/09/2006 12:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_MailingProperties]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[set_MailingProperties] 
(
	@RespondentID int
)
AS
BEGIN

DECLARE @EventDate datetime
DECLARE @EventCount int
DECLARE getMailingCodes CURSOR FOR
	SELECT EventDate
	FROM EventLog
	WHERE RespondentID = @RespondentID
	AND EventID = 4000
	ORDER BY EventDate

SET @EventCount = 0

OPEN getMailingCodes
FETCH getMailingCodes INTO @EventDate
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @EventCount = @EventCount + 1
	DECLARE @PropertyName varchar(100)
	SET @PropertyName = ''MAILING'' + CAST(@EventCount AS varchar(10))
	EXEC [set_DateProperty] @RespondentID, @PropertyName, @EventDate
	FETCH getMailingCodes into @EventDate
END
CLOSE getMailingCodes 
DEALLOCATE getMailingCodes 

END

' 
END
GO
