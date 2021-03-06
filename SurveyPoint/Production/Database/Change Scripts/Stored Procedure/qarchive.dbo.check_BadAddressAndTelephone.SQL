/****** Object:  StoredProcedure [dbo].[check_BadAddressAndTelephone]    Script Date: 08/08/2006 14:39:08 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[check_BadAddressAndTelephone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[check_BadAddressAndTelephone]
GO
/****** Object:  StoredProcedure [dbo].[check_BadAddressAndTelephone]    Script Date: 08/08/2006 14:39:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[check_BadAddressAndTelephone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[check_BadAddressAndTelephone]
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @BadAddress int
	DECLARE @BadTelephone int

	SET @BadAddress = 0
	SET @BadTelephone = 0

	SET SELECT @BadAddress = COUNT(*) FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2064, 4003)
	SET SELECT @BadTelephone = COUNT(*) FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2065, 5001, 5002, 5003)

	IF (@BadAddress > 0 AND @BadTelephone > 0)
		INSERT INTO EventLog(EventDate, EventID, UserID, RespondentID) VALUES(GETDATE(), 2062, @UserID, @RespondentID)

	SET NOCOUNT OFF

END
' 
END
GO
GRANT EXECUTE ON [dbo].[check_BadAddressAndTelephone] TO [reporter]
GO
