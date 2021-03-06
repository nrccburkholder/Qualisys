/****** Object:  StoredProcedure [dbo].[cahps_FluShot]    Script Date: 08/08/2006 14:05:05 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_FluShot]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_FluShot]
GO
/****** Object:  StoredProcedure [dbo].[cahps_FluShot]    Script Date: 08/08/2006 14:05:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_FluShot]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_FluShot] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''FLU_SHOT''

	DECLARE @FluFlag varchar(1)
	SET SELECT @FluFlag = dbo.GetRespondentPropertyValue(@RespondentID, ''FLU_FLAG'')

	IF @FluFlag IN ( ''1'', ''2'')
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, @FluFlag
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, ''3''

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_FluShot] TO [reporter]
GO
