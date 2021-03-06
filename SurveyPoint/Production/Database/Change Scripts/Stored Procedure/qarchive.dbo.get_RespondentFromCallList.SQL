/****** Object:  StoredProcedure [dbo].[get_RespondentFromCallList]    Script Date: 08/09/2006 15:23:44 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_RespondentFromCallList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_RespondentFromCallList]
GO
/****** Object:  StoredProcedure [dbo].[get_RespondentFromCallList]    Script Date: 08/09/2006 15:23:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_RespondentFromCallList]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.get_RespondentFromCallList 
(
	@RespondentId int, 
	@UserId int,
	@LogEventId int
)
AS
BEGIN TRAN
/*
Lock the respondent record -- ands make sure that no one else has called the respondent (since the top ten list was called )
If the respondent record was locked ok,  insert an eventlog for the given event.

The "no one else has called the respondent" could be a couple of things:
thing 1:  a respondent was called,  and the interview was completed- so the respondent is no longer showing in the view
vw_CallList

Thing 2:  a respondent is in the process of being interviewed-- in which case,  a eventlog with the same event id was recently added.
*/

DECLARE @a int 
DECLARE @x int 

DECLARE bbc CURSOR FOR 
SELECT     RespondentID
FROM         Respondents
WHERE     respondentID = @respondentID AND EXISTS
	(SELECT     ''x''
	FROM          vw_CallList t
	WHERE      RespondentID = (@RespondentId)) AND 
	NOT EXISTS
		(SELECT     ''x''
		FROM          eventlog el
		WHERE      el.respondentID = @respondentID AND 
		eventDate > dateadd(hour, - 1, getdate()) AND 
		eventID = @LogEventID AND eventlogid =
			(SELECT     MAX(Eventlogid)
			FROM          eventlog el2
			WHERE      el2.respondentID = @respondentID AND 
			el2.eventDate > dateadd(hour, - 1, getdate())
		)
	)
FOR UPDATE 

SET @x = NULL
OPEN bbc 
FETCH bbc INTO @x
CLOSE bbc 
DEALLOCATE bbc 

IF @x IS NOT NULL
	INSERT INTO EventLog(UserID, EventID, RespondentID)
	VALUES     (@UserId, @LogEventId, @RespondentID) 
ELSE
	SET @RespondentID = - 1

SELECT     @RespondentID 

COMMIT TRAN
' 
END
GO
GRANT EXECUTE ON [dbo].[get_RespondentFromCallList] TO [reporter]
GO
