/****** Object:  StoredProcedure [dbo].[hos2004_ExcludeFlag]    Script Date: 08/09/2006 16:19:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_ExcludeFlag]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_ExcludeFlag]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_ExcludeFlag]    Script Date: 08/09/2006 16:19:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_ExcludeFlag]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[hos2004_ExcludeFlag] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
DECLARE @EXCLUDE_FLAG_CODE varchar(100)
SET @EXCLUDE_FLAG_CODE = ''EXCLUDE_FLAG''

IF (EXISTS (SELECT 1 FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID IN (4999, 5999))))
  EXEC dbo.spSetRespondentProperty @RespondentID, @EXCLUDE_FLAG_CODE, ''1''
ELSE
  EXEC dbo.spSetRespondentProperty @RespondentID, @EXCLUDE_FLAG_CODE, ''2''

END
  

' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_ExcludeFlag] TO [reporter]
GO
