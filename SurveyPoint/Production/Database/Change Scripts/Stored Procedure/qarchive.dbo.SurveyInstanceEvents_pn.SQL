/****** Object:  StoredProcedure [dbo].[SurveyInstanceEvents_pn]    Script Date: 08/09/2006 12:57:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SurveyInstanceEvents_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SurveyInstanceEvents_pn]
GO
/****** Object:  StoredProcedure [dbo].[SurveyInstanceEvents_pn]    Script Date: 08/09/2006 12:57:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SurveyInstanceEvents_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure SurveyInstanceEvents_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       SurveyInstanceEvents
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           SurveyInstanceEvents''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @SurveyInstanceEventID int
declare @SurveyInstanceID int
declare @EventID int
declare @TranslationValue varchar(50)
declare @Final tinyint
declare @NonContactHours int

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
		  from SurveyInstanceEvents_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.SurveyInstanceEvents_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [SurveyInstanceEventID]
,[SurveyInstanceID]
,[EventID]
,[TranslationValue]
,[Final]
,[NonContactHours]
from goliath.qms.dbo.SurveyInstanceEvents_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @SurveyInstanceEventID
,@SurveyInstanceID
,@EventID
,@TranslationValue
,@Final
,@NonContactHours
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''SurveyInstanceEvents_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing SurveyInstanceEvents_jn */
		delete 
		from SurveyInstanceEvents_jn
		where 
[SurveyInstanceEventID] = @SurveyInstanceEventID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from SurveyInstanceEvents_jn b
			where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from SurveyInstanceEvents_jn a
where
a.[SurveyInstanceEventID] = @SurveyInstanceEventID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from SurveyInstanceEvents_jn 
where 
[SurveyInstanceEventID] = @SurveyInstanceEventID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from SurveyInstanceEvents
		where 
[SurveyInstanceEventID] = @SurveyInstanceEventID
end
else
begin
	
			update SurveyInstanceEvents
			set 
   [SurveyInstanceID]= @SurveyInstanceID
,  [EventID]= @EventID
,  [TranslationValue]= @TranslationValue
,  [Final]= @Final
,  [NonContactHours]= @NonContactHours
		where 
[SurveyInstanceEventID] = @SurveyInstanceEventID

		
		
		
		

		
		insert into SurveyInstanceEvents (
 [SurveyInstanceEventID]
,[SurveyInstanceID]
,[EventID]
,[TranslationValue]
,[Final]
,[NonContactHours]
)
		select 
 @SurveyInstanceEventID
,@SurveyInstanceID
,@EventID
,@TranslationValue
,@Final
,@NonContactHours
where not exists (Select ''x'' from SurveyInstanceEvents where 
[SurveyInstanceEventID] = @SurveyInstanceEventID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into SurveyInstanceEvents_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [SurveyInstanceEventID]
,[SurveyInstanceID]
,[EventID]
,[TranslationValue]
,[Final]
,[NonContactHours]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @SurveyInstanceEventID
,@SurveyInstanceID
,@EventID
,@TranslationValue
,@Final
,@NonContactHours
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @SurveyInstanceEventID
,@SurveyInstanceID
,@EventID
,@TranslationValue
,@Final
,@NonContactHours

end
close read_main
deallocate read_main

  print ''SurveyInstanceEvents_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.SurveyInstanceEvents_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from SurveyInstanceEvents_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.SurveyInstanceEvents_jn  a,
		SurveyInstanceEvents_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from SurveyInstanceEvents a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstanceEvents b
where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
)





print '' step 2: update ''

	update f 
	set 
   f.[SurveyInstanceID]= a.[SurveyInstanceID]
,  f.[EventID]= a.[EventID]
,  f.[TranslationValue]= a.[TranslationValue]
,  f.[Final]= a.[Final]
,  f.[NonContactHours]= a.[NonContactHours]
 from SurveyInstanceEvents f,goliath.qms.dbo.SurveyInstanceEvents a
	where 
     a.[SurveyInstanceEventID]= f.[SurveyInstanceEventID]
and (
  (a.[SurveyInstanceID]  is null and f.[SurveyInstanceID] is not null) or (a.[SurveyInstanceID]  is not null and f.[SurveyInstanceID] is null) or  (a.[SurveyInstanceID] != f.[SurveyInstanceID])
or  a.[EventID] != f.[EventID]
or (a.[TranslationValue]  is null and f.[TranslationValue] is not null) or (a.[TranslationValue]  is not null and f.[TranslationValue] is null) or  (a.[TranslationValue] != f.[TranslationValue])
or  a.[Final] != f.[Final]
or  a.[NonContactHours] != f.[NonContactHours]
)
	
	
	

print '' Step 3: insert''
insert into SurveyInstanceEvents(
 [SurveyInstanceEventID]
,[SurveyInstanceID]
,[EventID]
,[TranslationValue]
,[Final]
,[NonContactHours]
)
select 
 a.[SurveyInstanceEventID]
,a.[SurveyInstanceID]
,a.[EventID]
,a.[TranslationValue]
,a.[Final]
,a.[NonContactHours]
 from goliath.qms.dbo.SurveyInstanceEvents a
where not exists (select ''x''
from  SurveyInstanceEvents b
 where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from SurveyInstanceEvents a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstanceEvents b
where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from SurveyInstanceEvents f,goliath.qms.dbo.SurveyInstanceEvents a
	where 
     a.[SurveyInstanceEventID]= f.[SurveyInstanceEventID]
and (
  (a.[SurveyInstanceID]  is null and f.[SurveyInstanceID] is not null) or (a.[SurveyInstanceID]  is not null and f.[SurveyInstanceID] is null) or  (a.[SurveyInstanceID] != f.[SurveyInstanceID])
or  a.[EventID] != f.[EventID]
or (a.[TranslationValue]  is null and f.[TranslationValue] is not null) or (a.[TranslationValue]  is not null and f.[TranslationValue] is null) or  (a.[TranslationValue] != f.[TranslationValue])
or  a.[Final] != f.[Final]
or  a.[NonContactHours] != f.[NonContactHours]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.SurveyInstanceEvents a
where not exists (select ''x''
from  SurveyInstanceEvents b
 where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from SurveyInstanceEvents_jn a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstanceEvents_jn b
where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from SurveyInstanceEvents_jn f,goliath.qms.dbo.SurveyInstanceEvents_jn a
	where 
     a.[SurveyInstanceEventID]= f.[SurveyInstanceEventID]
and a.jn_datetime = f.jn_datetime and (
  (a.[SurveyInstanceID]  is null and f.[SurveyInstanceID] is not null) or (a.[SurveyInstanceID]  is not null and f.[SurveyInstanceID] is null) or  (a.[SurveyInstanceID] != f.[SurveyInstanceID])
or  a.[EventID] != f.[EventID]
or (a.[TranslationValue]  is null and f.[TranslationValue] is not null) or (a.[TranslationValue]  is not null and f.[TranslationValue] is null) or  (a.[TranslationValue] != f.[TranslationValue])
or  a.[Final] != f.[Final]
or  a.[NonContactHours] != f.[NonContactHours]
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.SurveyInstanceEvents_jn a
where not exists (select ''x''
from  SurveyInstanceEvents_jn b
 where 
     a.[SurveyInstanceEventID]= b.[SurveyInstanceEventID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           SurveyInstanceEvents done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
