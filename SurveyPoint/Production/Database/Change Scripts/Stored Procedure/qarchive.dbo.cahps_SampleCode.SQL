/****** Object:  StoredProcedure [dbo].[cahps_SampleCode]    Script Date: 08/08/2006 14:29:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SampleCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_SampleCode]
GO
/****** Object:  StoredProcedure [dbo].[cahps_SampleCode]    Script Date: 08/08/2006 14:29:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_SampleCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_SampleCode] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''SAMPLE_CODE''

	DECLARE @Code varchar(1)
	SET SELECT @Code = dbo.GetRespondentPropertyValue(@RespondentID, ''SAMPLE: CODE'')

	IF @Code = ''A''
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''1''
	ELSE IF @Code = ''B''
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''2''
	ELSE IF @Code = ''1''
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''1''
	ELSE IF @Code = ''2''
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''2''
	ELSE
    		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_SampleCode: Unable to determine sample code''



END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_SampleCode] TO [reporter]
GO
