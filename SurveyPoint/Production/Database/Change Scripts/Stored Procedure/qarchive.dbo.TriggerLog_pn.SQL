/****** Object:  StoredProcedure [dbo].[TriggerLog_pn]    Script Date: 08/10/2006 09:16:07 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TriggerLog_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[TriggerLog_pn]
GO
/****** Object:  StoredProcedure [dbo].[TriggerLog_pn]    Script Date: 08/10/2006 09:16:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[TriggerLog_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure TriggerLog_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       TriggerLog
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           TriggerLog''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @TriggerLogID int
declare @TriggerID int
declare @TriggerIDValue1 int
declare @TriggerIDValue2 int
declare @TriggerIDValue3 int
declare @TriggerIDValue4 int
declare @CompleteDate datetime
declare @StatusFlag int
declare @ParameterValues varchar(2000)

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
		  from TriggerLog_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.TriggerLog_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [TriggerLogID]
,[TriggerID]
,[TriggerIDValue1]
,[TriggerIDValue2]
,[TriggerIDValue3]
,[TriggerIDValue4]
,[CompleteDate]
,[StatusFlag]
,[ParameterValues]
from goliath.qms.dbo.TriggerLog_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @TriggerLogID
,@TriggerID
,@TriggerIDValue1
,@TriggerIDValue2
,@TriggerIDValue3
,@TriggerIDValue4
,@CompleteDate
,@StatusFlag
,@ParameterValues
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''TriggerLog_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing TriggerLog_jn */
		delete 
		from TriggerLog_jn
		where 
[TriggerLogID] = @TriggerLogID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from TriggerLog_jn b
			where 
     a.[TriggerLogID]= b.[TriggerLogID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from TriggerLog_jn a
where
a.[TriggerLogID] = @TriggerLogID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from TriggerLog_jn 
where 
[TriggerLogID] = @TriggerLogID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from TriggerLog
		where 
[TriggerLogID] = @TriggerLogID
end
else
begin
	
			update TriggerLog
			set 
   [TriggerID]= @TriggerID
,  [TriggerIDValue1]= @TriggerIDValue1
,  [TriggerIDValue2]= @TriggerIDValue2
,  [TriggerIDValue3]= @TriggerIDValue3
,  [TriggerIDValue4]= @TriggerIDValue4
,  [CompleteDate]= @CompleteDate
,  [StatusFlag]= @StatusFlag
,  [ParameterValues]= @ParameterValues
		where 
[TriggerLogID] = @TriggerLogID

		
		
		
		

		
		insert into TriggerLog (
 [TriggerLogID]
,[TriggerID]
,[TriggerIDValue1]
,[TriggerIDValue2]
,[TriggerIDValue3]
,[TriggerIDValue4]
,[CompleteDate]
,[StatusFlag]
,[ParameterValues]
)
		select 
 @TriggerLogID
,@TriggerID
,@TriggerIDValue1
,@TriggerIDValue2
,@TriggerIDValue3
,@TriggerIDValue4
,@CompleteDate
,@StatusFlag
,@ParameterValues
where not exists (Select ''x'' from TriggerLog where 
[TriggerLogID] = @TriggerLogID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into TriggerLog_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [TriggerLogID]
,[TriggerID]
,[TriggerIDValue1]
,[TriggerIDValue2]
,[TriggerIDValue3]
,[TriggerIDValue4]
,[CompleteDate]
,[StatusFlag]
,[ParameterValues]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @TriggerLogID
,@TriggerID
,@TriggerIDValue1
,@TriggerIDValue2
,@TriggerIDValue3
,@TriggerIDValue4
,@CompleteDate
,@StatusFlag
,@ParameterValues
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @TriggerLogID
,@TriggerID
,@TriggerIDValue1
,@TriggerIDValue2
,@TriggerIDValue3
,@TriggerIDValue4
,@CompleteDate
,@StatusFlag
,@ParameterValues

end
close read_main
deallocate read_main

  print ''TriggerLog_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.TriggerLog_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from TriggerLog_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.TriggerLog_jn  a,
		TriggerLog_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[TriggerLogID]= b.[TriggerLogID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from TriggerLog a
where not exists (
select ''x''
from goliath.qms.dbo.TriggerLog b
where 
     a.[TriggerLogID]= b.[TriggerLogID]
)





print '' step 2: update ''

	update f 
	set 
   f.[TriggerID]= a.[TriggerID]
,  f.[TriggerIDValue1]= a.[TriggerIDValue1]
,  f.[TriggerIDValue2]= a.[TriggerIDValue2]
,  f.[TriggerIDValue3]= a.[TriggerIDValue3]
,  f.[TriggerIDValue4]= a.[TriggerIDValue4]
,  f.[CompleteDate]= a.[CompleteDate]
,  f.[StatusFlag]= a.[StatusFlag]
,  f.[ParameterValues]= a.[ParameterValues]
 from TriggerLog f,goliath.qms.dbo.TriggerLog a
	where 
     a.[TriggerLogID]= f.[TriggerLogID]
and (
   a.[TriggerID] != f.[TriggerID]
or  a.[TriggerIDValue1] != f.[TriggerIDValue1]
or  a.[TriggerIDValue2] != f.[TriggerIDValue2]
or  a.[TriggerIDValue3] != f.[TriggerIDValue3]
or  a.[TriggerIDValue4] != f.[TriggerIDValue4]
or  a.[CompleteDate] != f.[CompleteDate]
or  a.[StatusFlag] != f.[StatusFlag]
or (a.[ParameterValues]  is null and f.[ParameterValues] is not null) or (a.[ParameterValues]  is not null and f.[ParameterValues] is null) or  (a.[ParameterValues] != f.[ParameterValues])
)
	
	
	

print '' Step 3: insert''
insert into TriggerLog(
 [TriggerLogID]
,[TriggerID]
,[TriggerIDValue1]
,[TriggerIDValue2]
,[TriggerIDValue3]
,[TriggerIDValue4]
,[CompleteDate]
,[StatusFlag]
,[ParameterValues]
)
select 
 a.[TriggerLogID]
,a.[TriggerID]
,a.[TriggerIDValue1]
,a.[TriggerIDValue2]
,a.[TriggerIDValue3]
,a.[TriggerIDValue4]
,a.[CompleteDate]
,a.[StatusFlag]
,a.[ParameterValues]
 from goliath.qms.dbo.TriggerLog a
where not exists (select ''x''
from  TriggerLog b
 where 
     a.[TriggerLogID]= b.[TriggerLogID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from TriggerLog a
where not exists (
select ''x''
from goliath.qms.dbo.TriggerLog b
where 
     a.[TriggerLogID]= b.[TriggerLogID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from TriggerLog f,goliath.qms.dbo.TriggerLog a
	where 
     a.[TriggerLogID]= f.[TriggerLogID]
and (
   a.[TriggerID] != f.[TriggerID]
or  a.[TriggerIDValue1] != f.[TriggerIDValue1]
or  a.[TriggerIDValue2] != f.[TriggerIDValue2]
or  a.[TriggerIDValue3] != f.[TriggerIDValue3]
or  a.[TriggerIDValue4] != f.[TriggerIDValue4]
or  a.[CompleteDate] != f.[CompleteDate]
or  a.[StatusFlag] != f.[StatusFlag]
or (a.[ParameterValues]  is null and f.[ParameterValues] is not null) or (a.[ParameterValues]  is not null and f.[ParameterValues] is null) or  (a.[ParameterValues] != f.[ParameterValues])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.TriggerLog a
where not exists (select ''x''
from  TriggerLog b
 where 
     a.[TriggerLogID]= b.[TriggerLogID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from TriggerLog_jn a
where not exists (
select ''x''
from goliath.qms.dbo.TriggerLog_jn b
where 
     a.[TriggerLogID]= b.[TriggerLogID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from TriggerLog_jn f,goliath.qms.dbo.TriggerLog_jn a
	where 
     a.[TriggerLogID]= f.[TriggerLogID]
and a.jn_datetime = f.jn_datetime and (
   a.[TriggerID] != f.[TriggerID]
or  a.[TriggerIDValue1] != f.[TriggerIDValue1]
or  a.[TriggerIDValue2] != f.[TriggerIDValue2]
or  a.[TriggerIDValue3] != f.[TriggerIDValue3]
or  a.[TriggerIDValue4] != f.[TriggerIDValue4]
or  a.[CompleteDate] != f.[CompleteDate]
or  a.[StatusFlag] != f.[StatusFlag]
or (a.[ParameterValues]  is null and f.[ParameterValues] is not null) or (a.[ParameterValues]  is not null and f.[ParameterValues] is null) or  (a.[ParameterValues] != f.[ParameterValues])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.TriggerLog_jn a
where not exists (select ''x''
from  TriggerLog_jn b
 where 
     a.[TriggerLogID]= b.[TriggerLogID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           TriggerLog done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
