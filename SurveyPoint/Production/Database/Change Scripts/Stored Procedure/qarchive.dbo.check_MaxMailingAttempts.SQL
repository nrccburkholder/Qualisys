/****** Object:  StoredProcedure [dbo].[check_MaxMailingAttempts]    Script Date: 08/08/2006 14:39:18 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[check_MaxMailingAttempts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[check_MaxMailingAttempts]
GO
/****** Object:  StoredProcedure [dbo].[check_MaxMailingAttempts]    Script Date: 08/08/2006 14:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[check_MaxMailingAttempts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[check_MaxMailingAttempts] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (3001, 3002, 3003, 3010, 3011, 3012, 3020, 3021, 3022, 3030, 3031, 3032, 3033, 3034, 3035)) AND 
	(EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (5001, 5002, 5003))
	OR EXISTS (SELECT 1 FROM Respondents WHERE RespondentID = @RespondentID AND TelephoneDay IS NULL))
   EXEC insert_EventLog @EventLogID = NULL, @EventID = 6034, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = NULL

END

' 
END
GO
GRANT EXECUTE ON [dbo].[check_MaxMailingAttempts] TO [reporter]
GO
