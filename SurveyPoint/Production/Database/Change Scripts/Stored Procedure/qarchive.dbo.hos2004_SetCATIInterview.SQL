/****** Object:  StoredProcedure [dbo].[hos2004_SetCATIInterview]    Script Date: 08/09/2006 16:19:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SetCATIInterview]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SetCATIInterview]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SetCATIInterview]    Script Date: 08/09/2006 16:19:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SetCATIInterview]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[hos2004_SetCATIInterview] 
(
	@RespondentID int,
	@UserID int,
	@EventID int
)
AS
BEGIN
DECLARE @CATI_INTERVIEWER_CODE varchar(100)
SET @CATI_INTERVIEWER_CODE = ''CATI_INTERVIEWER''
DECLARE @CATIInterviewer int
SET @CATIInterviewer = NULL
IF @EventID > 0 
SET SELECT @CATIInterviewer = UserID FROM EventLog 
	WHERE RespondentID = @RespondentID 
	AND EventLogID = (SELECT MAX(EventLogID) FROM EventLog WHERE RespondentID = @RespondentID AND EventID = @EventID)
	
DECLARE @FlagValue varchar(8)

IF (@CATIInterviewer IS NULL)
  SET @FlagValue = ''99999999''
ELSE
  SET @FlagValue = CAST((20000000 + @CATIInterviewer) AS varchar(8))

EXEC dbo.spSetRespondentProperty @RespondentID, @CATI_INTERVIEWER_CODE, @FlagValue

END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SetCATIInterview] TO [reporter]
GO
