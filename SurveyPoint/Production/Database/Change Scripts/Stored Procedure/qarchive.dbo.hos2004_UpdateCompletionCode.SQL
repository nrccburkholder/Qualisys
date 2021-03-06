/****** Object:  StoredProcedure [dbo].[hos2004_UpdateCompletionCode]    Script Date: 08/09/2006 16:28:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_UpdateCompletionCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_UpdateCompletionCode]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_UpdateCompletionCode]    Script Date: 08/09/2006 16:28:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_UpdateCompletionCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE           PROCEDURE [dbo].[hos2004_UpdateCompletionCode]
(
	@RespondentID int
)
AS
BEGIN 

DECLARE @EventID int

SET @EventID = NULL
SET SELECT @EventID = EventID FROM EventLog 
	WHERE (EventID IN (3010, 3020, 3030, 3033)) AND
	(CAST(EventParameters AS decimal(9,1)) >= 50.0) AND
	RespondentID = @RespondentID

IF @EventID IS NOT NULL
	UPDATE EventLog SET EventID = EventID + 1
	WHERE RespondentID = @RespondentID
	AND EventID = @EventID

END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_UpdateCompletionCode] TO [reporter]
GO
