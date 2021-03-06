/****** Object:  StoredProcedure [dbo].[hos2004_MCOPhone]    Script Date: 08/09/2006 16:19:27 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_MCOPhone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_MCOPhone]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_MCOPhone]    Script Date: 08/09/2006 16:19:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_MCOPhone]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[hos2004_MCOPhone] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
DECLARE @MCO_PHONE_CODE varchar(100)
SET @MCO_PHONE_CODE = ''MCO_PHONE''

IF (EXISTS (SELECT 1 FROM Respondents WHERE (RespondentID = @RespondentID) AND (TelephoneDay IS NOT NULL OR TelephoneDay = '''') 
	AND (NOT EXISTS (SELECT 1 FROM EventLog WHERE (EventLog.RespondentID = Respondents.RespondentID) AND (EventLog.EventID = 5001)))))
  EXEC dbo.spSetRespondentProperty @RespondentID, @MCO_PHONE_CODE, ''1''
ELSE
  EXEC dbo.spSetRespondentProperty @RespondentID, @MCO_PHONE_CODE, ''2''

END

' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_MCOPhone] TO [reporter]
GO
