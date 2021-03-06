/****** Object:  StoredProcedure [dbo].[delete_EventLog]    Script Date: 08/09/2006 13:39:32 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_EventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_EventLog]
GO
/****** Object:  StoredProcedure [dbo].[delete_EventLog]    Script Date: 08/09/2006 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_EventLog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [delete_EventLog]
	(@EventLogID 	[int])

AS begin
begin tran

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

DELETE [QMS].[dbo].[EventLog] 

WHERE 
	( [EventLogID]	 = @EventLogID)


commit tran
end

' 
END
GO
