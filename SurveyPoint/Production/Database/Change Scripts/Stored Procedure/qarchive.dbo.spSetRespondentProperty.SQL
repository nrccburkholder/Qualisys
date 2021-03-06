/****** Object:  StoredProcedure [dbo].[spSetRespondentProperty]    Script Date: 08/09/2006 12:57:22 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spSetRespondentProperty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spSetRespondentProperty]
GO
/****** Object:  StoredProcedure [dbo].[spSetRespondentProperty]    Script Date: 08/09/2006 12:57:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spSetRespondentProperty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE dbo.spSetRespondentProperty
	(
		@RespondentID int,
		@PropertyName varchar(100),
		@PropertyValue varchar(100)
	)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @RespondentPropertyID int
	SET @RespondentPropertyID = NULL
	SET SELECT @RespondentPropertyID = RespondentPropertyID FROM RespondentProperties WHERE RespondentID = @RespondentID AND PropertyName = @PropertyName
	IF (@RespondentPropertyID IS NOT NULL)
		EXEC  update_RespondentProperties @RespondentPropertyID = @RespondentPropertyID, @RespondentID = @RespondentID, @PropertyName = @PropertyName, @PropertyValue = @PropertyValue
	ELSE
		EXEC  insert_RespondentProperties @RespondentPropertyID = NULL, @RespondentID = @RespondentID, @PropertyName = @PropertyName, @PropertyValue = @PropertyValue
	
	SET NOCOUNT OFF

	RETURN 

END
' 
END
GO
GRANT EXECUTE ON [dbo].[spSetRespondentProperty] TO [reporter]
GO
