/****** Object:  StoredProcedure [dbo].[cahps_MemberYearOfBirth]    Script Date: 08/08/2006 14:21:17 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberYearOfBirth]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[cahps_MemberYearOfBirth]
GO
/****** Object:  StoredProcedure [dbo].[cahps_MemberYearOfBirth]    Script Date: 08/08/2006 14:21:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[cahps_MemberYearOfBirth]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  PROCEDURE [dbo].[cahps_MemberYearOfBirth] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @MEMBER_YOB varchar(50)
	SET @MEMBER_YOB = ''MEMBER_BIRTH_YEAR''

	DECLARE @DOB datetime
	SET SELECT @DOB = DOB FROM Respondents WHERE RespondentID = @RespondentID

	IF @DOB >= GETDATE()
    		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''cahps_MemberYearOfBirth: Respondent DOB is in the future.''

	IF @DOB IS NOT NULL
		BEGIN
		DECLARE @YEAROFBIRTH varchar(4)
		SET @YEAROFBIRTH = CAST(YEAR(@DOB) AS varchar(4))
		EXEC dbo.spSetRespondentProperty @RespondentID, @MEMBER_YOB, @YEAROFBIRTH
		END
	ELSE
		EXEC dbo.spSetRespondentProperty @RespondentID, @MEMBER_YOB, ''9999'' -- Missing

END
' 
END
GO
GRANT EXECUTE ON [dbo].[cahps_MemberYearOfBirth] TO [reporter]
GO
