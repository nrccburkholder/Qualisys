/****** Object:  StoredProcedure [dbo].[cahps_MemberCity]    Script Date: 08/08/2006 14:16:10 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberCity]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_MemberCity]
GO
/****** Object:  StoredProcedure [dbo].[cahps_MemberCity]    Script Date: 08/08/2006 14:16:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberCity]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_MemberCity] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''MEMBER_CITY''

	DECLARE @City varchar(30)
	SET SELECT @City = LEFT(UPPER(ISNULL(City, '''')) + SPACE (30), 30) FROM Respondents WHERE RespondentID = @RespondentID

	EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, @City

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_MemberCity] TO [reporter]
GO
