/****** Object:  StoredProcedure [dbo].[tmpfixeventlog]    Script Date: 08/10/2006 09:24:23 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tmpfixeventlog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[tmpfixeventlog]
GO
/****** Object:  StoredProcedure [dbo].[tmpfixeventlog]    Script Date: 08/10/2006 09:24:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tmpfixeventlog]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure tmpfixeventlog(@a int, @l int)
as
begin
insert into EventLog_jn (
jn_operation,jn_user,jn_datetime,jn_endtime,
jn_notes,jn_appln,jn_session,
 [EventLogID]
,[EventDate]
,[EventID]
,[UserID]
,[RespondentID]
,[EventParameters]
,[SurveyInstanceID]
,[SurveyID]
,[ClientID]
,[EventTypeID]
)
select
''I'',current_user,''11-feb-1970'',CAST(''2500-12-27 12:00:00.000'' 
  AS datetime),null,null,@@SPID,
 [EventLogID]
,[EventDate]
,[EventID]
,[UserID]
,[RespondentID]
,[EventParameters]
,[SurveyInstanceID]
,[SurveyID]
,[ClientID]
,[EventTypeID]
from eventlog
where eventlogID >= @a
and eventlogID < @a+@l
end

' 
END
GO
