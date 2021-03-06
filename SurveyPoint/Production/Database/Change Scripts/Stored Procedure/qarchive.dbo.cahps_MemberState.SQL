/****** Object:  StoredProcedure [dbo].[cahps_MemberState]    Script Date: 08/08/2006 14:21:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberState]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_MemberState]
GO
/****** Object:  StoredProcedure [dbo].[cahps_MemberState]    Script Date: 08/08/2006 14:21:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberState]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_MemberState] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @PROPERTY_NAME varchar(50)
	SET @PROPERTY_NAME = ''MEMBER_STATE''

	DECLARE @State varchar(2)
	SET SELECT @State = LEFT(UPPER(ISNULL(State, '''')) + SPACE (2), 2) FROM Respondents WHERE RespondentID = @RespondentID

	EXEC dbo.spSetRespondentProperty @RespondentID, @PROPERTY_NAME, @State

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_MemberState] TO [reporter]
GO
