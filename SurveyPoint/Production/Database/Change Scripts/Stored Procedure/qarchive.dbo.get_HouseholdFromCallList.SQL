/****** Object:  StoredProcedure [dbo].[get_HouseholdFromCallList]    Script Date: 08/09/2006 15:23:27 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_HouseholdFromCallList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_HouseholdFromCallList]
GO
/****** Object:  StoredProcedure [dbo].[get_HouseholdFromCallList]    Script Date: 08/09/2006 15:23:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_HouseholdFromCallList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE   PROCEDURE dbo.get_HouseholdFromCallList 
(
	@RespondentId int, 
	@UserId int,
	@LogEventId int
)
AS
BEGIN TRAN
/*
For Households, you need to lock the entire household and check the entire household
as a single unit.
*/

DECLARE @a int 
DECLARE @x int 
DECLARE abc_household CURSOR FOR 
SELECT     RespondentID
FROM         Respondents
WHERE     respondentID IN
	(SELECT     hsld.respondentID
	FROM          vw_CallList t, v_HouseholdsByTelephone hsld
	WHERE      t .RespondentID = (@RespondentId) AND 
	(hsld.Telephone IN (t .TelephoneDay, t .TelephoneEvening)) 
	AND (hsld.ClientID = t .ClientID) AND 
	(hsld.InstanceDate = t .InstanceDate) AND 
	NOT EXISTS
		(SELECT     ''x''
		FROM          eventlog el
		WHERE      el.respondentID = hsld.respondentID AND 
		eventDate > dateadd(hour, - 1, getdate()) AND 
		eventID = @LogEventID AND 
		eventlogid =
			(SELECT     MAX(Eventlogid)
			FROM          eventlog el2
			WHERE      el2.respondentID = hsld.respondentID
			AND el2.eventDate > dateadd(hour, 
			- 1, getdate())
			)
		)
	)
FOR UPDATE 

SET              @x = NULL
OPEN abc_household 
FETCH abc_household INTO @a

WHILE @@fetch_status = 0 
BEGIN
	SET              @x = 1
	FETCH abc_household INTO @a
END 

CLOSE abc_household 
DEALLOCATE abc_household 

IF @x IS NOT NULL
	EXEC dbo.spInsertHouseholdEventLog @RespondentID, @UserID, @LogEventID, '''' 
ELSE
	SET @RespondentID = - 1

SELECT     @RespondentID 

COMMIT TRAN
' 
END
GO
GRANT EXECUTE ON [dbo].[get_HouseholdFromCallList] TO [reporter]
GO
