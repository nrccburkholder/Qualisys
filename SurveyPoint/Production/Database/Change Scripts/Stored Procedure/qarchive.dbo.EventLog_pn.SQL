/****** Object:  StoredProcedure [dbo].[EventLog_pn]    Script Date: 08/09/2006 14:42:14 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[EventLog_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[EventLog_pn]
GO
/****** Object:  StoredProcedure [dbo].[EventLog_pn]    Script Date: 08/09/2006 14:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[EventLog_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure EventLog_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       EventLog
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           EventLog''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @EventLogID int
declare @EventDate datetime
declare @EventID int
declare @UserID int
declare @RespondentID int
declare @EventParameters varchar(3000)
declare @SurveyInstanceID int
declare @SurveyID int
declare @ClientID int
declare @EventTypeID int

	declare @jn_mindate datetime
	declare @jn_maxdate datetime
	declare @jn_loop_count int
	
	
	if ((@mode =0) or (@mode = 1))
	  begin
	  set nocount on
		if (@mode = 1) 
		  begin
		  /* This mindate will not look at the production server
		  The other mindate will */
		  select @jn_mindate = isnull(dateadd(hour,-1,max(jn_datetime)),''10-jun-1970'')
		  from EventLog_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.EventLog_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
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
from goliath.qms.dbo.EventLog_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @EventLogID
,@EventDate
,@EventID
,@UserID
,@RespondentID
,@EventParameters
,@SurveyInstanceID
,@SurveyID
,@ClientID
,@EventTypeID
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''EventLog_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing EventLog_jn */
		delete 
		from EventLog_jn
		where 
[EventLogID] = @EventLogID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from EventLog_jn b
			where 
     a.[EventLogID]= b.[EventLogID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from EventLog_jn a
where
a.[EventLogID] = @EventLogID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from EventLog_jn 
where 
[EventLogID] = @EventLogID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from EventLog
		where 
[EventLogID] = @EventLogID
end
else
begin
	
			update EventLog
			set 
   [EventDate]= @EventDate
,  [EventID]= @EventID
,  [UserID]= @UserID
,  [RespondentID]= @RespondentID
,  [EventParameters]= @EventParameters
,  [SurveyInstanceID]= @SurveyInstanceID
,  [SurveyID]= @SurveyID
,  [ClientID]= @ClientID
,  [EventTypeID]= @EventTypeID
		where 
[EventLogID] = @EventLogID

		
		
		
		

		
		insert into EventLog (
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
 @EventLogID
,@EventDate
,@EventID
,@UserID
,@RespondentID
,@EventParameters
,@SurveyInstanceID
,@SurveyID
,@ClientID
,@EventTypeID
where not exists (Select ''x'' from EventLog where 
[EventLogID] = @EventLogID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into EventLog_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
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
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @EventLogID
,@EventDate
,@EventID
,@UserID
,@RespondentID
,@EventParameters
,@SurveyInstanceID
,@SurveyID
,@ClientID
,@EventTypeID
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @EventLogID
,@EventDate
,@EventID
,@UserID
,@RespondentID
,@EventParameters
,@SurveyInstanceID
,@SurveyID
,@ClientID
,@EventTypeID

end
close read_main
deallocate read_main

  print ''EventLog_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.EventLog_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from EventLog_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.EventLog_jn  a,
		EventLog_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[EventLogID]= b.[EventLogID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from EventLog a
where not exists (
select ''x''
from goliath.qms.dbo.EventLog b
where 
     a.[EventLogID]= b.[EventLogID]
)





print '' step 2: update ''

	update f 
	set 
   f.[EventDate]= a.[EventDate]
,  f.[EventID]= a.[EventID]
,  f.[UserID]= a.[UserID]
,  f.[RespondentID]= a.[RespondentID]
,  f.[EventParameters]= a.[EventParameters]
,  f.[SurveyInstanceID]= a.[SurveyInstanceID]
,  f.[SurveyID]= a.[SurveyID]
,  f.[ClientID]= a.[ClientID]
,  f.[EventTypeID]= a.[EventTypeID]
 from EventLog f,goliath.qms.dbo.EventLog a
	where 
     a.[EventLogID]= f.[EventLogID]
and (
   a.[EventDate] != f.[EventDate]
or  a.[EventID] != f.[EventID]
or  a.[UserID] != f.[UserID]
or (a.[RespondentID]  is null and f.[RespondentID] is not null) or (a.[RespondentID]  is not null and f.[RespondentID] is null) or  (a.[RespondentID] != f.[RespondentID])
or (a.[EventParameters]  is null and f.[EventParameters] is not null) or (a.[EventParameters]  is not null and f.[EventParameters] is null) or  (a.[EventParameters] != f.[EventParameters])
or (a.[SurveyInstanceID]  is null and f.[SurveyInstanceID] is not null) or (a.[SurveyInstanceID]  is not null and f.[SurveyInstanceID] is null) or  (a.[SurveyInstanceID] != f.[SurveyInstanceID])
or (a.[SurveyID]  is null and f.[SurveyID] is not null) or (a.[SurveyID]  is not null and f.[SurveyID] is null) or  (a.[SurveyID] != f.[SurveyID])
or (a.[ClientID]  is null and f.[ClientID] is not null) or (a.[ClientID]  is not null and f.[ClientID] is null) or  (a.[ClientID] != f.[ClientID])
or (a.[EventTypeID]  is null and f.[EventTypeID] is not null) or (a.[EventTypeID]  is not null and f.[EventTypeID] is null) or  (a.[EventTypeID] != f.[EventTypeID])
)
	
	
	

print '' Step 3: insert''
insert into EventLog(
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
 a.[EventLogID]
,a.[EventDate]
,a.[EventID]
,a.[UserID]
,a.[RespondentID]
,a.[EventParameters]
,a.[SurveyInstanceID]
,a.[SurveyID]
,a.[ClientID]
,a.[EventTypeID]
 from goliath.qms.dbo.EventLog a
where not exists (select ''x''
from  EventLog b
 where 
     a.[EventLogID]= b.[EventLogID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from EventLog a
where not exists (
select ''x''
from goliath.qms.dbo.EventLog b
where 
     a.[EventLogID]= b.[EventLogID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from EventLog f,goliath.qms.dbo.EventLog a
	where 
     a.[EventLogID]= f.[EventLogID]
and (
   a.[EventDate] != f.[EventDate]
or  a.[EventID] != f.[EventID]
or  a.[UserID] != f.[UserID]
or (a.[RespondentID]  is null and f.[RespondentID] is not null) or (a.[RespondentID]  is not null and f.[RespondentID] is null) or  (a.[RespondentID] != f.[RespondentID])
or (a.[EventParameters]  is null and f.[EventParameters] is not null) or (a.[EventParameters]  is not null and f.[EventParameters] is null) or  (a.[EventParameters] != f.[EventParameters])
or (a.[SurveyInstanceID]  is null and f.[SurveyInstanceID] is not null) or (a.[SurveyInstanceID]  is not null and f.[SurveyInstanceID] is null) or  (a.[SurveyInstanceID] != f.[SurveyInstanceID])
or (a.[SurveyID]  is null and f.[SurveyID] is not null) or (a.[SurveyID]  is not null and f.[SurveyID] is null) or  (a.[SurveyID] != f.[SurveyID])
or (a.[ClientID]  is null and f.[ClientID] is not null) or (a.[ClientID]  is not null and f.[ClientID] is null) or  (a.[ClientID] != f.[ClientID])
or (a.[EventTypeID]  is null and f.[EventTypeID] is not null) or (a.[EventTypeID]  is not null and f.[EventTypeID] is null) or  (a.[EventTypeID] != f.[EventTypeID])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.EventLog a
where not exists (select ''x''
from  EventLog b
 where 
     a.[EventLogID]= b.[EventLogID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from EventLog_jn a
where not exists (
select ''x''
from goliath.qms.dbo.EventLog_jn b
where 
     a.[EventLogID]= b.[EventLogID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from EventLog_jn f,goliath.qms.dbo.EventLog_jn a
	where 
     a.[EventLogID]= f.[EventLogID]
and a.jn_datetime = f.jn_datetime and (
   a.[EventDate] != f.[EventDate]
or  a.[EventID] != f.[EventID]
or  a.[UserID] != f.[UserID]
or (a.[RespondentID]  is null and f.[RespondentID] is not null) or (a.[RespondentID]  is not null and f.[RespondentID] is null) or  (a.[RespondentID] != f.[RespondentID])
or (a.[EventParameters]  is null and f.[EventParameters] is not null) or (a.[EventParameters]  is not null and f.[EventParameters] is null) or  (a.[EventParameters] != f.[EventParameters])
or (a.[SurveyInstanceID]  is null and f.[SurveyInstanceID] is not null) or (a.[SurveyInstanceID]  is not null and f.[SurveyInstanceID] is null) or  (a.[SurveyInstanceID] != f.[SurveyInstanceID])
or (a.[SurveyID]  is null and f.[SurveyID] is not null) or (a.[SurveyID]  is not null and f.[SurveyID] is null) or  (a.[SurveyID] != f.[SurveyID])
or (a.[ClientID]  is null and f.[ClientID] is not null) or (a.[ClientID]  is not null and f.[ClientID] is null) or  (a.[ClientID] != f.[ClientID])
or (a.[EventTypeID]  is null and f.[EventTypeID] is not null) or (a.[EventTypeID]  is not null and f.[EventTypeID] is null) or  (a.[EventTypeID] != f.[EventTypeID])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.EventLog_jn a
where not exists (select ''x''
from  EventLog_jn b
 where 
     a.[EventLogID]= b.[EventLogID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           EventLog done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
