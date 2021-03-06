/****** Object:  StoredProcedure [dbo].[FileDefFilters_pn]    Script Date: 08/09/2006 15:11:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FileDefFilters_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FileDefFilters_pn]
GO
/****** Object:  StoredProcedure [dbo].[FileDefFilters_pn]    Script Date: 08/09/2006 15:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FileDefFilters_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure FileDefFilters_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       FileDefFilters
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           FileDefFilters''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @FileDefFilterID int
declare @FilterName varchar(50)
declare @FilterWhere varchar(1000)
declare @ParamName0 varchar(50)
declare @ParamName1 varchar(50)
declare @ParamName2 varchar(50)
declare @DisplayOrder int

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
		  from FileDefFilters_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.FileDefFilters_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [FileDefFilterID]
,[FilterName]
,[FilterWhere]
,[ParamName0]
,[ParamName1]
,[ParamName2]
,[DisplayOrder]
from goliath.qms.dbo.FileDefFilters_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @FileDefFilterID
,@FilterName
,@FilterWhere
,@ParamName0
,@ParamName1
,@ParamName2
,@DisplayOrder
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''FileDefFilters_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing FileDefFilters_jn */
		delete 
		from FileDefFilters_jn
		where 
[FileDefFilterID] = @FileDefFilterID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from FileDefFilters_jn b
			where 
     a.[FileDefFilterID]= b.[FileDefFilterID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from FileDefFilters_jn a
where
a.[FileDefFilterID] = @FileDefFilterID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from FileDefFilters_jn 
where 
[FileDefFilterID] = @FileDefFilterID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from FileDefFilters
		where 
[FileDefFilterID] = @FileDefFilterID
end
else
begin
	
			update FileDefFilters
			set 
   [FilterName]= @FilterName
,  [FilterWhere]= @FilterWhere
,  [ParamName0]= @ParamName0
,  [ParamName1]= @ParamName1
,  [ParamName2]= @ParamName2
,  [DisplayOrder]= @DisplayOrder
		where 
[FileDefFilterID] = @FileDefFilterID

		
		
		
		

		
		insert into FileDefFilters (
 [FileDefFilterID]
,[FilterName]
,[FilterWhere]
,[ParamName0]
,[ParamName1]
,[ParamName2]
,[DisplayOrder]
)
		select 
 @FileDefFilterID
,@FilterName
,@FilterWhere
,@ParamName0
,@ParamName1
,@ParamName2
,@DisplayOrder
where not exists (Select ''x'' from FileDefFilters where 
[FileDefFilterID] = @FileDefFilterID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into FileDefFilters_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [FileDefFilterID]
,[FilterName]
,[FilterWhere]
,[ParamName0]
,[ParamName1]
,[ParamName2]
,[DisplayOrder]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @FileDefFilterID
,@FilterName
,@FilterWhere
,@ParamName0
,@ParamName1
,@ParamName2
,@DisplayOrder
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @FileDefFilterID
,@FilterName
,@FilterWhere
,@ParamName0
,@ParamName1
,@ParamName2
,@DisplayOrder

end
close read_main
deallocate read_main

  print ''FileDefFilters_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.FileDefFilters_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from FileDefFilters_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.FileDefFilters_jn  a,
		FileDefFilters_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[FileDefFilterID]= b.[FileDefFilterID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from FileDefFilters a
where not exists (
select ''x''
from goliath.qms.dbo.FileDefFilters b
where 
     a.[FileDefFilterID]= b.[FileDefFilterID]
)





print '' step 2: update ''

	update f 
	set 
   f.[FilterName]= a.[FilterName]
,  f.[FilterWhere]= a.[FilterWhere]
,  f.[ParamName0]= a.[ParamName0]
,  f.[ParamName1]= a.[ParamName1]
,  f.[ParamName2]= a.[ParamName2]
,  f.[DisplayOrder]= a.[DisplayOrder]
 from FileDefFilters f,goliath.qms.dbo.FileDefFilters a
	where 
     a.[FileDefFilterID]= f.[FileDefFilterID]
and (
   a.[FilterName] != f.[FilterName]
or  a.[FilterWhere] != f.[FilterWhere]
or (a.[ParamName0]  is null and f.[ParamName0] is not null) or (a.[ParamName0]  is not null and f.[ParamName0] is null) or  (a.[ParamName0] != f.[ParamName0])
or (a.[ParamName1]  is null and f.[ParamName1] is not null) or (a.[ParamName1]  is not null and f.[ParamName1] is null) or  (a.[ParamName1] != f.[ParamName1])
or (a.[ParamName2]  is null and f.[ParamName2] is not null) or (a.[ParamName2]  is not null and f.[ParamName2] is null) or  (a.[ParamName2] != f.[ParamName2])
or  a.[DisplayOrder] != f.[DisplayOrder]
)
	
	
	

print '' Step 3: insert''
insert into FileDefFilters(
 [FileDefFilterID]
,[FilterName]
,[FilterWhere]
,[ParamName0]
,[ParamName1]
,[ParamName2]
,[DisplayOrder]
)
select 
 a.[FileDefFilterID]
,a.[FilterName]
,a.[FilterWhere]
,a.[ParamName0]
,a.[ParamName1]
,a.[ParamName2]
,a.[DisplayOrder]
 from goliath.qms.dbo.FileDefFilters a
where not exists (select ''x''
from  FileDefFilters b
 where 
     a.[FileDefFilterID]= b.[FileDefFilterID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from FileDefFilters a
where not exists (
select ''x''
from goliath.qms.dbo.FileDefFilters b
where 
     a.[FileDefFilterID]= b.[FileDefFilterID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from FileDefFilters f,goliath.qms.dbo.FileDefFilters a
	where 
     a.[FileDefFilterID]= f.[FileDefFilterID]
and (
   a.[FilterName] != f.[FilterName]
or  a.[FilterWhere] != f.[FilterWhere]
or (a.[ParamName0]  is null and f.[ParamName0] is not null) or (a.[ParamName0]  is not null and f.[ParamName0] is null) or  (a.[ParamName0] != f.[ParamName0])
or (a.[ParamName1]  is null and f.[ParamName1] is not null) or (a.[ParamName1]  is not null and f.[ParamName1] is null) or  (a.[ParamName1] != f.[ParamName1])
or (a.[ParamName2]  is null and f.[ParamName2] is not null) or (a.[ParamName2]  is not null and f.[ParamName2] is null) or  (a.[ParamName2] != f.[ParamName2])
or  a.[DisplayOrder] != f.[DisplayOrder]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.FileDefFilters a
where not exists (select ''x''
from  FileDefFilters b
 where 
     a.[FileDefFilterID]= b.[FileDefFilterID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from FileDefFilters_jn a
where not exists (
select ''x''
from goliath.qms.dbo.FileDefFilters_jn b
where 
     a.[FileDefFilterID]= b.[FileDefFilterID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from FileDefFilters_jn f,goliath.qms.dbo.FileDefFilters_jn a
	where 
     a.[FileDefFilterID]= f.[FileDefFilterID]
and a.jn_datetime = f.jn_datetime and (
   a.[FilterName] != f.[FilterName]
or  a.[FilterWhere] != f.[FilterWhere]
or (a.[ParamName0]  is null and f.[ParamName0] is not null) or (a.[ParamName0]  is not null and f.[ParamName0] is null) or  (a.[ParamName0] != f.[ParamName0])
or (a.[ParamName1]  is null and f.[ParamName1] is not null) or (a.[ParamName1]  is not null and f.[ParamName1] is null) or  (a.[ParamName1] != f.[ParamName1])
or (a.[ParamName2]  is null and f.[ParamName2] is not null) or (a.[ParamName2]  is not null and f.[ParamName2] is null) or  (a.[ParamName2] != f.[ParamName2])
or  a.[DisplayOrder] != f.[DisplayOrder]
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.FileDefFilters_jn a
where not exists (select ''x''
from  FileDefFilters_jn b
 where 
     a.[FileDefFilterID]= b.[FileDefFilterID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           FileDefFilters done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
