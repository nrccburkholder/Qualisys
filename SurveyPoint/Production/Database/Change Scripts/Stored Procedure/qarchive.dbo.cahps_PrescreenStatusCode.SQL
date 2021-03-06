/****** Object:  StoredProcedure [dbo].[cahps_PrescreenStatusCode]    Script Date: 08/08/2006 14:21:23 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_PrescreenStatusCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_PrescreenStatusCode]
GO
/****** Object:  StoredProcedure [dbo].[cahps_PrescreenStatusCode]    Script Date: 08/08/2006 14:21:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_PrescreenStatusCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_PrescreenStatusCode] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''PRESCREEN_STATUS_CODE''

	DECLARE @Prescreen varchar(1)
	SET SELECT @Prescreen = dbo.GetRespondentPropertyValue(@RespondentID, ''PRESCREEN'')
	IF (@Prescreen IS NULL) OR (@Prescreen = '''')
		SET SELECT @Prescreen = dbo.GetRespondentPropertyValue(@RespondentID, ''PRESCREEN_CODE'')

	IF @Prescreen IN ( ''1'', ''2'', ''3'')
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, @Prescreen
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''9''

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_PrescreenStatusCode] TO [reporter]
GO
