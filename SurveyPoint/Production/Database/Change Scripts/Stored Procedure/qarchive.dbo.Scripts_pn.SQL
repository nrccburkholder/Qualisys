/****** Object:  StoredProcedure [dbo].[Scripts_pn]    Script Date: 08/10/2006 10:22:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Scripts_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Scripts_pn]
GO
/****** Object:  StoredProcedure [dbo].[Scripts_pn]    Script Date: 08/10/2006 10:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Scripts_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Scripts_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Scripts
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Scripts''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @ScriptID int
declare @SurveyID int
declare @ScriptTypeID int
declare @Name varchar(100)
declare @Description varchar(1000)
declare @CompletenessLevel decimal(18,0)
declare @FollowSkips tinyint
declare @CalcCompleteness tinyint
declare @DefaultScript tinyint

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
		  from Scripts_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Scripts_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ScriptID]
,[SurveyID]
,[ScriptTypeID]
,[Name]
,[Description]
,[CompletenessLevel]
,[FollowSkips]
,[CalcCompleteness]
,[DefaultScript]
from goliath.qms.dbo.Scripts_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ScriptID
,@SurveyID
,@ScriptTypeID
,@Name
,@Description
,@CompletenessLevel
,@FollowSkips
,@CalcCompleteness
,@DefaultScript
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Scripts_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Scripts_jn */
		delete 
		from Scripts_jn
		where 
[ScriptID] = @ScriptID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from Scripts_jn b
			where 
     a.[ScriptID]= b.[ScriptID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from Scripts_jn a
where
a.[ScriptID] = @ScriptID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from Scripts_jn 
where 
[ScriptID] = @ScriptID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from Scripts
		where 
[ScriptID] = @ScriptID
end
else
begin
	
			update Scripts
			set 
   [SurveyID]= @SurveyID
,  [ScriptTypeID]= @ScriptTypeID
,  [Name]= @Name
,  [Description]= @Description
,  [CompletenessLevel]= @CompletenessLevel
,  [FollowSkips]= @FollowSkips
,  [CalcCompleteness]= @CalcCompleteness
,  [DefaultScript]= @DefaultScript
		where 
[ScriptID] = @ScriptID

		
		
		
		

		
		insert into Scripts (
 [ScriptID]
,[SurveyID]
,[ScriptTypeID]
,[Name]
,[Description]
,[CompletenessLevel]
,[FollowSkips]
,[CalcCompleteness]
,[DefaultScript]
)
		select 
 @ScriptID
,@SurveyID
,@ScriptTypeID
,@Name
,@Description
,@CompletenessLevel
,@FollowSkips
,@CalcCompleteness
,@DefaultScript
where not exists (Select ''x'' from Scripts where 
[ScriptID] = @ScriptID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into Scripts_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ScriptID]
,[SurveyID]
,[ScriptTypeID]
,[Name]
,[Description]
,[CompletenessLevel]
,[FollowSkips]
,[CalcCompleteness]
,[DefaultScript]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ScriptID
,@SurveyID
,@ScriptTypeID
,@Name
,@Description
,@CompletenessLevel
,@FollowSkips
,@CalcCompleteness
,@DefaultScript
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ScriptID
,@SurveyID
,@ScriptTypeID
,@Name
,@Description
,@CompletenessLevel
,@FollowSkips
,@CalcCompleteness
,@DefaultScript

end
close read_main
deallocate read_main

  print ''Scripts_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Scripts_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from Scripts_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Scripts_jn  a,
		Scripts_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[ScriptID]= b.[ScriptID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from Scripts a
where not exists (
select ''x''
from goliath.qms.dbo.Scripts b
where 
     a.[ScriptID]= b.[ScriptID]
)





print '' step 2: update ''

	update f 
	set 
   f.[SurveyID]= a.[SurveyID]
,  f.[ScriptTypeID]= a.[ScriptTypeID]
,  f.[Name]= a.[Name]
,  f.[Description]= a.[Description]
,  f.[CompletenessLevel]= a.[CompletenessLevel]
,  f.[FollowSkips]= a.[FollowSkips]
,  f.[CalcCompleteness]= a.[CalcCompleteness]
,  f.[DefaultScript]= a.[DefaultScript]
 from Scripts f,goliath.qms.dbo.Scripts a
	where 
     a.[ScriptID]= f.[ScriptID]
and (
   a.[SurveyID] != f.[SurveyID]
or  a.[ScriptTypeID] != f.[ScriptTypeID]
or  a.[Name] != f.[Name]
or (a.[Description]  is null and f.[Description] is not null) or (a.[Description]  is not null and f.[Description] is null) or  (a.[Description] != f.[Description])
or  a.[CompletenessLevel] != f.[CompletenessLevel]
or  a.[FollowSkips] != f.[FollowSkips]
or (a.[CalcCompleteness]  is null and f.[CalcCompleteness] is not null) or (a.[CalcCompleteness]  is not null and f.[CalcCompleteness] is null) or  (a.[CalcCompleteness] != f.[CalcCompleteness])
or (a.[DefaultScript]  is null and f.[DefaultScript] is not null) or (a.[DefaultScript]  is not null and f.[DefaultScript] is null) or  (a.[DefaultScript] != f.[DefaultScript])
)
	
	
	

print '' Step 3: insert''
insert into Scripts(
 [ScriptID]
,[SurveyID]
,[ScriptTypeID]
,[Name]
,[Description]
,[CompletenessLevel]
,[FollowSkips]
,[CalcCompleteness]
,[DefaultScript]
)
select 
 a.[ScriptID]
,a.[SurveyID]
,a.[ScriptTypeID]
,a.[Name]
,a.[Description]
,a.[CompletenessLevel]
,a.[FollowSkips]
,a.[CalcCompleteness]
,a.[DefaultScript]
 from goliath.qms.dbo.Scripts a
where not exists (select ''x''
from  Scripts b
 where 
     a.[ScriptID]= b.[ScriptID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Scripts a
where not exists (
select ''x''
from goliath.qms.dbo.Scripts b
where 
     a.[ScriptID]= b.[ScriptID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Scripts f,goliath.qms.dbo.Scripts a
	where 
     a.[ScriptID]= f.[ScriptID]
and (
   a.[SurveyID] != f.[SurveyID]
or  a.[ScriptTypeID] != f.[ScriptTypeID]
or  a.[Name] != f.[Name]
or (a.[Description]  is null and f.[Description] is not null) or (a.[Description]  is not null and f.[Description] is null) or  (a.[Description] != f.[Description])
or  a.[CompletenessLevel] != f.[CompletenessLevel]
or  a.[FollowSkips] != f.[FollowSkips]
or (a.[CalcCompleteness]  is null and f.[CalcCompleteness] is not null) or (a.[CalcCompleteness]  is not null and f.[CalcCompleteness] is null) or  (a.[CalcCompleteness] != f.[CalcCompleteness])
or (a.[DefaultScript]  is null and f.[DefaultScript] is not null) or (a.[DefaultScript]  is not null and f.[DefaultScript] is null) or  (a.[DefaultScript] != f.[DefaultScript])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Scripts a
where not exists (select ''x''
from  Scripts b
 where 
     a.[ScriptID]= b.[ScriptID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Scripts_jn a
where not exists (
select ''x''
from goliath.qms.dbo.Scripts_jn b
where 
     a.[ScriptID]= b.[ScriptID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Scripts_jn f,goliath.qms.dbo.Scripts_jn a
	where 
     a.[ScriptID]= f.[ScriptID]
and a.jn_datetime = f.jn_datetime and (
   a.[SurveyID] != f.[SurveyID]
or  a.[ScriptTypeID] != f.[ScriptTypeID]
or  a.[Name] != f.[Name]
or (a.[Description]  is null and f.[Description] is not null) or (a.[Description]  is not null and f.[Description] is null) or  (a.[Description] != f.[Description])
or  a.[CompletenessLevel] != f.[CompletenessLevel]
or  a.[FollowSkips] != f.[FollowSkips]
or (a.[CalcCompleteness]  is null and f.[CalcCompleteness] is not null) or (a.[CalcCompleteness]  is not null and f.[CalcCompleteness] is null) or  (a.[CalcCompleteness] != f.[CalcCompleteness])
or (a.[DefaultScript]  is null and f.[DefaultScript] is not null) or (a.[DefaultScript]  is not null and f.[DefaultScript] is null) or  (a.[DefaultScript] != f.[DefaultScript])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Scripts_jn a
where not exists (select ''x''
from  Scripts_jn b
 where 
     a.[ScriptID]= b.[ScriptID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Scripts done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
