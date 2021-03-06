/****** Object:  StoredProcedure [dbo].[insert_EventLog]    Script Date: 08/09/2006 16:29:40 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_EventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_EventLog]
GO
/****** Object:  StoredProcedure [dbo].[insert_EventLog]    Script Date: 08/09/2006 16:29:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_EventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE insert_EventLog
	(@EventLogID 	[int] OUTPUT,
	 @EventID 	[int],
	 @UserID 	[int],
	 @RespondentID 	[int],
	 @EventParameters 	[varchar](100))

AS 
BEGIN
IF @EventID IN (3040, 3041, 3042)
BEGIN
	-- check if survey audit has been overriden, if yes - do not insert event
	IF EXISTS (SELECT 1 FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3060 AND EventParameters = @EventParameters)
		RETURN
END

begin transaction

IF @RespondentID IS NOT NULL
BEGIN
	declare abc cursor for select 1
	from respondents
	where
	respondentID = @RespondentID
	for update
	
	declare @x int
	open abc
	fetch abc into @x
	close abc
	deallocate abc
END

INSERT INTO [QMS].[dbo].[EventLog] 
	 ( [EventDate],
	 [EventID],
	 [UserID],
	 [RespondentID],
	 [EventParameters]) 
 
VALUES 
	( GETDATE(),
	 @EventID,
	 @UserID,
	 @RespondentID,
	 @EventParameters)

SET @EventLogID = @@IDENTITY
commit transaction
END


' 
END
GO
