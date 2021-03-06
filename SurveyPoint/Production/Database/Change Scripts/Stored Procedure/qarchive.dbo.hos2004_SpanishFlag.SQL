/****** Object:  StoredProcedure [dbo].[hos2004_SpanishFlag]    Script Date: 08/09/2006 16:19:47 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SpanishFlag]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SpanishFlag]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SpanishFlag]    Script Date: 08/09/2006 16:19:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SpanishFlag]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[hos2004_SpanishFlag] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
DECLARE @SPANISH_FLAG_CODE varchar(100)
SET @SPANISH_FLAG_CODE = ''SPANISH_FLAG''

IF (EXISTS (SELECT 1 FROM Respondents WHERE (RespondentID = @RespondentID) AND (SurveyInstanceID IN (810, 813))))
  EXEC dbo.spSetRespondentProperty @RespondentID, @SPANISH_FLAG_CODE, ''1''
ELSE
  EXEC dbo.spSetRespondentProperty @RespondentID, @SPANISH_FLAG_CODE, ''2''

END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SpanishFlag] TO [reporter]
GO
