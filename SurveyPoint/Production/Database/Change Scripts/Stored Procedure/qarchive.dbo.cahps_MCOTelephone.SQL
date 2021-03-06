/****** Object:  StoredProcedure [dbo].[cahps_MCOTelephone]    Script Date: 08/08/2006 14:15:31 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MCOTelephone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_MCOTelephone]
GO
/****** Object:  StoredProcedure [dbo].[cahps_MCOTelephone]    Script Date: 08/08/2006 14:15:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MCOTelephone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_MCOTelephone] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''MCO_TELEPHONE''

	IF EXISTS (SELECT 1 FROM Respondents WHERE RespondentID = @RespondentID AND (TelephoneDay IS NULL OR TelephoneDay = ''''))
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''2'' -- No Telephone
	ELSE IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 5001)
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''2'' -- No Telephone
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''1'' -- Has Telephone

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_MCOTelephone] TO [reporter]
GO
