/****** Object:  StoredProcedure [dbo].[ScriptScreenCategories_pn]    Script Date: 08/10/2006 10:22:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ScriptScreenCategories_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ScriptScreenCategories_pn]
GO
/****** Object:  StoredProcedure [dbo].[ScriptScreenCategories_pn]    Script Date: 08/10/2006 10:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ScriptScreenCategories_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure ScriptScreenCategories_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       ScriptScreenCategories
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           ScriptScreenCategories''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @ScriptScreenCategoryID int
declare @ScriptScreenID int
declare @AnswerCategoryID int
declare @JumpToScriptScreenID int
declare @Text varchar(1000)

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
		  from ScriptScreenCategories_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.ScriptScreenCategories_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ScriptScreenCategoryID]
,[ScriptScreenID]
,[AnswerCategoryID]
,[JumpToScriptScreenID]
,[Text]
from goliath.qms.dbo.ScriptScreenCategories_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ScriptScreenCategoryID
,@ScriptScreenID
,@AnswerCategoryID
,@JumpToScriptScreenID
,@Text
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''ScriptScreenCategories_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing ScriptScreenCategories_jn */
		delete 
		from ScriptScreenCategories_jn
		where 
[ScriptScreenCategoryID] = @ScriptScreenCategoryID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from ScriptScreenCategories_jn b
			where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from ScriptScreenCategories_jn a
where
a.[ScriptScreenCategoryID] = @ScriptScreenCategoryID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from ScriptScreenCategories_jn 
where 
[ScriptScreenCategoryID] = @ScriptScreenCategoryID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from ScriptScreenCategories
		where 
[ScriptScreenCategoryID] = @ScriptScreenCategoryID
end
else
begin
	
			update ScriptScreenCategories
			set 
   [ScriptScreenID]= @ScriptScreenID
,  [AnswerCategoryID]= @AnswerCategoryID
,  [JumpToScriptScreenID]= @JumpToScriptScreenID
,  [Text]= @Text
		where 
[ScriptScreenCategoryID] = @ScriptScreenCategoryID

		
		
		
		

		
		insert into ScriptScreenCategories (
 [ScriptScreenCategoryID]
,[ScriptScreenID]
,[AnswerCategoryID]
,[JumpToScriptScreenID]
,[Text]
)
		select 
 @ScriptScreenCategoryID
,@ScriptScreenID
,@AnswerCategoryID
,@JumpToScriptScreenID
,@Text
where not exists (Select ''x'' from ScriptScreenCategories where 
[ScriptScreenCategoryID] = @ScriptScreenCategoryID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into ScriptScreenCategories_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ScriptScreenCategoryID]
,[ScriptScreenID]
,[AnswerCategoryID]
,[JumpToScriptScreenID]
,[Text]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ScriptScreenCategoryID
,@ScriptScreenID
,@AnswerCategoryID
,@JumpToScriptScreenID
,@Text
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ScriptScreenCategoryID
,@ScriptScreenID
,@AnswerCategoryID
,@JumpToScriptScreenID
,@Text

end
close read_main
deallocate read_main

  print ''ScriptScreenCategories_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.ScriptScreenCategories_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from ScriptScreenCategories_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.ScriptScreenCategories_jn  a,
		ScriptScreenCategories_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from ScriptScreenCategories a
where not exists (
select ''x''
from goliath.qms.dbo.ScriptScreenCategories b
where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
)





print '' step 2: update ''

	update f 
	set 
   f.[ScriptScreenID]= a.[ScriptScreenID]
,  f.[AnswerCategoryID]= a.[AnswerCategoryID]
,  f.[JumpToScriptScreenID]= a.[JumpToScriptScreenID]
,  f.[Text]= a.[Text]
 from ScriptScreenCategories f,goliath.qms.dbo.ScriptScreenCategories a
	where 
     a.[ScriptScreenCategoryID]= f.[ScriptScreenCategoryID]
and (
   a.[ScriptScreenID] != f.[ScriptScreenID]
or  a.[AnswerCategoryID] != f.[AnswerCategoryID]
or (a.[JumpToScriptScreenID]  is null and f.[JumpToScriptScreenID] is not null) or (a.[JumpToScriptScreenID]  is not null and f.[JumpToScriptScreenID] is null) or  (a.[JumpToScriptScreenID] != f.[JumpToScriptScreenID])
or (a.[Text]  is null and f.[Text] is not null) or (a.[Text]  is not null and f.[Text] is null) or  (a.[Text] != f.[Text])
)
	
	
	

print '' Step 3: insert''
insert into ScriptScreenCategories(
 [ScriptScreenCategoryID]
,[ScriptScreenID]
,[AnswerCategoryID]
,[JumpToScriptScreenID]
,[Text]
)
select 
 a.[ScriptScreenCategoryID]
,a.[ScriptScreenID]
,a.[AnswerCategoryID]
,a.[JumpToScriptScreenID]
,a.[Text]
 from goliath.qms.dbo.ScriptScreenCategories a
where not exists (select ''x''
from  ScriptScreenCategories b
 where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from ScriptScreenCategories a
where not exists (
select ''x''
from goliath.qms.dbo.ScriptScreenCategories b
where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from ScriptScreenCategories f,goliath.qms.dbo.ScriptScreenCategories a
	where 
     a.[ScriptScreenCategoryID]= f.[ScriptScreenCategoryID]
and (
   a.[ScriptScreenID] != f.[ScriptScreenID]
or  a.[AnswerCategoryID] != f.[AnswerCategoryID]
or (a.[JumpToScriptScreenID]  is null and f.[JumpToScriptScreenID] is not null) or (a.[JumpToScriptScreenID]  is not null and f.[JumpToScriptScreenID] is null) or  (a.[JumpToScriptScreenID] != f.[JumpToScriptScreenID])
or (a.[Text]  is null and f.[Text] is not null) or (a.[Text]  is not null and f.[Text] is null) or  (a.[Text] != f.[Text])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.ScriptScreenCategories a
where not exists (select ''x''
from  ScriptScreenCategories b
 where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from ScriptScreenCategories_jn a
where not exists (
select ''x''
from goliath.qms.dbo.ScriptScreenCategories_jn b
where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from ScriptScreenCategories_jn f,goliath.qms.dbo.ScriptScreenCategories_jn a
	where 
     a.[ScriptScreenCategoryID]= f.[ScriptScreenCategoryID]
and a.jn_datetime = f.jn_datetime and (
   a.[ScriptScreenID] != f.[ScriptScreenID]
or  a.[AnswerCategoryID] != f.[AnswerCategoryID]
or (a.[JumpToScriptScreenID]  is null and f.[JumpToScriptScreenID] is not null) or (a.[JumpToScriptScreenID]  is not null and f.[JumpToScriptScreenID] is null) or  (a.[JumpToScriptScreenID] != f.[JumpToScriptScreenID])
or (a.[Text]  is null and f.[Text] is not null) or (a.[Text]  is not null and f.[Text] is null) or  (a.[Text] != f.[Text])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.ScriptScreenCategories_jn a
where not exists (select ''x''
from  ScriptScreenCategories_jn b
 where 
     a.[ScriptScreenCategoryID]= b.[ScriptScreenCategoryID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           ScriptScreenCategories done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
