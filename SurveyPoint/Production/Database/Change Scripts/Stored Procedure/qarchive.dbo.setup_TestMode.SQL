/****** Object:  StoredProcedure [dbo].[setup_TestMode]    Script Date: 08/09/2006 12:58:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[setup_TestMode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[setup_TestMode]
GO
/****** Object:  StoredProcedure [dbo].[setup_TestMode]    Script Date: 08/09/2006 12:58:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[setup_TestMode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE [dbo].[setup_TestMode] 
(
	@ScriptID int
)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @SurveyID int
	DECLARE @ClientID int
	DECLARE @SurveyInstanceID int

	SET SELECT @SurveyID = SurveyID FROM Scripts WHERE ScriptID = @ScriptID

	SET @ClientID = 27 -- Test Mode Client

	INSERT INTO SurveyInstances (SurveyID, ClientID, ProtocolID, Name, InstanceDate, StartDate, Active, GroupByHousehold)
	VALUES (@SurveyID, @ClientID, 0, ''TEST INSTANCE'', GETDATE(), GETDATE(), 0, 0)
	SET @SurveyInstanceID = @@IDENTITY

	INSERT INTO Respondents(SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, TelephoneDay, TelephoneEvening, DOB, 
	              Gender, ClientRespondentID, SSN, BatchID, MailingSeedFlag, CallsMade, Final, NextContact)
	VALUES     (@SurveyInstanceID, ''JANE'', ''X'', ''DOE'', ''ADDRESS1'', ''ADDRESS2'', ''CITY'', ''CA'', ''ZIP'', ''5555555555'', ''5555555555'', ''1950-01-01'', 
			''F'', ''000000'', ''5555555555'', 555, 0, 0, 0, GETDATE())	

	SELECT @@IDENTITY

	SET NOCOUNT OFF

END
' 
END
GO
