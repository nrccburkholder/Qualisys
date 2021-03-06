/****** Object:  StoredProcedure [dbo].[insert_EventLog_WITHDATE]    Script Date: 08/09/2006 16:29:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_EventLog_WITHDATE]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_EventLog_WITHDATE]
GO
/****** Object:  StoredProcedure [dbo].[insert_EventLog_WITHDATE]    Script Date: 08/09/2006 16:29:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_EventLog_WITHDATE]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE insert_EventLog_WITHDATE
	(@EventLogID 	[int] OUTPUT,
	 @EventDate [datetime], 
	 @EventID 	[int],
	 @UserID 	[int],
	 @RespondentID 	[int],
	 @EventParameters 	[varchar](100))

AS 
BEGIN

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

IF @EventDate > CAST(CONVERT(varchar(10), GETDATE(), 101) AS datetime) 
	SET @EventDate = GETDATE()

INSERT INTO [QMS].[dbo].[EventLog] 
	 ( [EventDate],
	 [EventID],
	 [UserID],
	 [RespondentID],
	 [EventParameters]) 
 
VALUES 
	( @EventDate,
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
