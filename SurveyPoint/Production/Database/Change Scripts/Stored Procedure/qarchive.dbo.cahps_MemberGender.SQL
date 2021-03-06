/****** Object:  StoredProcedure [dbo].[cahps_MemberGender]    Script Date: 08/08/2006 14:21:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberGender]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_MemberGender]
GO
/****** Object:  StoredProcedure [dbo].[cahps_MemberGender]    Script Date: 08/08/2006 14:21:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberGender]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_MemberGender] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @MEMBER_GENDER varchar(50)
	SET @MEMBER_GENDER = ''MEMBER_GENDER''

	DECLARE @Gender varchar(1)
	SET SELECT @Gender = UPPER(Gender) FROM Respondents WHERE RespondentID = @RespondentID

	IF @Gender = ''M''
		EXEC dbo.spSetRespondentProperty @RespondentID, @MEMBER_GENDER, ''1'' -- Male
	ELSE IF @Gender = ''F''
		EXEC dbo.spSetRespondentProperty @RespondentID, @MEMBER_GENDER, ''2'' -- Female
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @MEMBER_GENDER, ''9'' -- Missing

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_MemberGender] TO [reporter]
GO
