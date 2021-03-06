/****** Object:  StoredProcedure [dbo].[cahps_MCOAddress]    Script Date: 08/08/2006 14:15:18 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MCOAddress]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_MCOAddress]
GO
/****** Object:  StoredProcedure [dbo].[cahps_MCOAddress]    Script Date: 08/08/2006 14:15:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MCOAddress]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_MCOAddress] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''MCO_ADDRESS''

	IF EXISTS (SELECT 1 FROM Respondents WHERE RespondentID = @RespondentID AND (Address1 IS NULL OR Address1 = ''''))
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''2'' -- No Address
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''1'' -- Has Address

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_MCOAddress] TO [reporter]
GO
