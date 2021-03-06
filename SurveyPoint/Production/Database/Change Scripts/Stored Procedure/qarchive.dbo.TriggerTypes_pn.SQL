/****** Object:  StoredProcedure [dbo].[TriggerTypes_pn]    Script Date: 08/09/2006 12:54:54 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TriggerTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TriggerTypes_pn]
GO
/****** Object:  StoredProcedure [dbo].[TriggerTypes_pn]    Script Date: 08/09/2006 12:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TriggerTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure TriggerTypes_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       TriggerTypes
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           TriggerTypes''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @TriggerTypeID int
declare @TriggerTypeName varchar(100)
declare @IntroCode varchar(2000)
declare @ExitCode varchar(2000)
declare @Description varchar(2000)
declare @DevDescription varchar(2000)

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
		  from TriggerTypes_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.TriggerTypes_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [TriggerTypeID]
,[TriggerTypeName]
,[IntroCode]
,[ExitCode]
,[Description]
,[DevDescription]
from goliath.qms.dbo.TriggerTypes_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @TriggerTypeID
,@TriggerTypeName
,@IntroCode
,@ExitCode
,@Description
,@DevDescription
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''TriggerTypes_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing TriggerTypes_jn */
		delete 
		from TriggerTypes_jn
		where 
[TriggerTypeID] = @TriggerTypeID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from TriggerTypes_jn b
			where 
     a.[TriggerTypeID]= b.[TriggerTypeID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from TriggerTypes_jn a
where
a.[TriggerTypeID] = @TriggerTypeID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from TriggerTypes_jn 
where 
[TriggerTypeID] = @TriggerTypeID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from TriggerTypes
		where 
[TriggerTypeID] = @TriggerTypeID
end
else
begin
	
			update TriggerTypes
			set 
   [TriggerTypeName]= @TriggerTypeName
,  [IntroCode]= @IntroCode
,  [ExitCode]= @ExitCode
,  [Description]= @Description
,  [DevDescription]= @DevDescription
		where 
[TriggerTypeID] = @TriggerTypeID

		
		
		
		

		
		insert into TriggerTypes (
 [TriggerTypeID]
,[TriggerTypeName]
,[IntroCode]
,[ExitCode]
,[Description]
,[DevDescription]
)
		select 
 @TriggerTypeID
,@TriggerTypeName
,@IntroCode
,@ExitCode
,@Description
,@DevDescription
where not exists (Select ''x'' from TriggerTypes where 
[TriggerTypeID] = @TriggerTypeID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into TriggerTypes_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [TriggerTypeID]
,[TriggerTypeName]
,[IntroCode]
,[ExitCode]
,[Description]
,[DevDescription]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @TriggerTypeID
,@TriggerTypeName
,@IntroCode
,@ExitCode
,@Description
,@DevDescription
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @TriggerTypeID
,@TriggerTypeName
,@IntroCode
,@ExitCode
,@Description
,@DevDescription

end
close read_main
deallocate read_main

  print ''TriggerTypes_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.TriggerTypes_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from TriggerTypes_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.TriggerTypes_jn  a,
		TriggerTypes_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[TriggerTypeID]= b.[TriggerTypeID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from TriggerTypes a
where not exists (
select ''x''
from goliath.qms.dbo.TriggerTypes b
where 
     a.[TriggerTypeID]= b.[TriggerTypeID]
)





print '' step 2: update ''

	update f 
	set 
   f.[TriggerTypeName]= a.[TriggerTypeName]
,  f.[IntroCode]= a.[IntroCode]
,  f.[ExitCode]= a.[ExitCode]
,  f.[Description]= a.[Description]
,  f.[DevDescription]= a.[DevDescription]
 from TriggerTypes f,goliath.qms.dbo.TriggerTypes a
	where 
     a.[TriggerTypeID]= f.[TriggerTypeID]
and (
   a.[TriggerTypeName] != f.[TriggerTypeName]
or (a.[IntroCode]  is null and f.[IntroCode] is not null) or (a.[IntroCode]  is not null and f.[IntroCode] is null) or  (a.[IntroCode] != f.[IntroCode])
or (a.[ExitCode]  is null and f.[ExitCode] is not null) or (a.[ExitCode]  is not null and f.[ExitCode] is null) or  (a.[ExitCode] != f.[ExitCode])
or (a.[Description]  is null and f.[Description] is not null) or (a.[Description]  is not null and f.[Description] is null) or  (a.[Description] != f.[Description])
or (a.[DevDescription]  is null and f.[DevDescription] is not null) or (a.[DevDescription]  is not null and f.[DevDescription] is null) or  (a.[DevDescription] != f.[DevDescription])
)
	
	
	

print '' Step 3: insert''
insert into TriggerTypes(
 [TriggerTypeID]
,[TriggerTypeName]
,[IntroCode]
,[ExitCode]
,[Description]
,[DevDescription]
)
select 
 a.[TriggerTypeID]
,a.[TriggerTypeName]
,a.[IntroCode]
,a.[ExitCode]
,a.[Description]
,a.[DevDescription]
 from goliath.qms.dbo.TriggerTypes a
where not exists (select ''x''
from  TriggerTypes b
 where 
     a.[TriggerTypeID]= b.[TriggerTypeID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from TriggerTypes a
where not exists (
select ''x''
from goliath.qms.dbo.TriggerTypes b
where 
     a.[TriggerTypeID]= b.[TriggerTypeID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from TriggerTypes f,goliath.qms.dbo.TriggerTypes a
	where 
     a.[TriggerTypeID]= f.[TriggerTypeID]
and (
   a.[TriggerTypeName] != f.[TriggerTypeName]
or (a.[IntroCode]  is null and f.[IntroCode] is not null) or (a.[IntroCode]  is not null and f.[IntroCode] is null) or  (a.[IntroCode] != f.[IntroCode])
or (a.[ExitCode]  is null and f.[ExitCode] is not null) or (a.[ExitCode]  is not null and f.[ExitCode] is null) or  (a.[ExitCode] != f.[ExitCode])
or (a.[Description]  is null and f.[Description] is not null) or (a.[Description]  is not null and f.[Description] is null) or  (a.[Description] != f.[Description])
or (a.[DevDescription]  is null and f.[DevDescription] is not null) or (a.[DevDescription]  is not null and f.[DevDescription] is null) or  (a.[DevDescription] != f.[DevDescription])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.TriggerTypes a
where not exists (select ''x''
from  TriggerTypes b
 where 
     a.[TriggerTypeID]= b.[TriggerTypeID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from TriggerTypes_jn a
where not exists (
select ''x''
from goliath.qms.dbo.TriggerTypes_jn b
where 
     a.[TriggerTypeID]= b.[TriggerTypeID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from TriggerTypes_jn f,goliath.qms.dbo.TriggerTypes_jn a
	where 
     a.[TriggerTypeID]= f.[TriggerTypeID]
and a.jn_datetime = f.jn_datetime and (
   a.[TriggerTypeName] != f.[TriggerTypeName]
or (a.[IntroCode]  is null and f.[IntroCode] is not null) or (a.[IntroCode]  is not null and f.[IntroCode] is null) or  (a.[IntroCode] != f.[IntroCode])
or (a.[ExitCode]  is null and f.[ExitCode] is not null) or (a.[ExitCode]  is not null and f.[ExitCode] is null) or  (a.[ExitCode] != f.[ExitCode])
or (a.[Description]  is null and f.[Description] is not null) or (a.[Description]  is not null and f.[Description] is null) or  (a.[Description] != f.[Description])
or (a.[DevDescription]  is null and f.[DevDescription] is not null) or (a.[DevDescription]  is not null and f.[DevDescription] is null) or  (a.[DevDescription] != f.[DevDescription])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.TriggerTypes_jn a
where not exists (select ''x''
from  TriggerTypes_jn b
 where 
     a.[TriggerTypeID]= b.[TriggerTypeID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           TriggerTypes done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
