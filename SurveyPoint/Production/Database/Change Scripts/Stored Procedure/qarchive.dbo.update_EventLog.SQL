/****** Object:  StoredProcedure [dbo].[update_EventLog]    Script Date: 08/09/2006 12:54:29 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_EventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_EventLog]
GO
/****** Object:  StoredProcedure [dbo].[update_EventLog]    Script Date: 08/09/2006 12:54:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_EventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_EventLog]
	(@EventLogID 	[int],
	 @EventDate 	[datetime],
	 @EventID 	[int],
	 @UserID 	[int],
	 @RespondentID 	[int],
	 @EventParameters 	[varchar](100))

AS 
begin
begin tran




declare abc2 cursor for select 1
from respondents
where
respondentID = @RespondentID
for update

declare abc cursor for select 1
from respondents
where
respondentID in (select RespondentID from eventlog where eventlogid=@eventlogID)
for update

declare @x int
open abc
fetch abc into @x
close abc
deallocate abc

open abc2
fetch abc2 into @x
close abc2
deallocate abc2




UPDATE [QMS].[dbo].[EventLog] 

SET  	 [EventDate]	 = @EventDate,
	 [EventID]	 = @EventID,
	 [UserID]	 = @UserID,
	 [RespondentID]	 = @RespondentID,
	 [EventParameters]	 = @EventParameters 

WHERE 
	( [EventLogID]	 = @EventLogID)


commit tran
end


' 
END
GO
