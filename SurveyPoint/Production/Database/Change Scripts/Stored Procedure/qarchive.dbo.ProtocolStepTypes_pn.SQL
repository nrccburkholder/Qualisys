/****** Object:  StoredProcedure [dbo].[ProtocolStepTypes_pn]    Script Date: 08/10/2006 16:41:18 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProtocolStepTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[ProtocolStepTypes_pn]
GO
/****** Object:  StoredProcedure [dbo].[ProtocolStepTypes_pn]    Script Date: 08/10/2006 16:41:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ProtocolStepTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure ProtocolStepTypes_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       ProtocolStepTypes
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           ProtocolStepTypes''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @ProtocolStepTypeID int
declare @Name varchar(100)
declare @URL varchar(1000)

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
		  from ProtocolStepTypes_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.ProtocolStepTypes_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ProtocolStepTypeID]
,[Name]
,[URL]
from goliath.qms.dbo.ProtocolStepTypes_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ProtocolStepTypeID
,@Name
,@URL
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''ProtocolStepTypes_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing ProtocolStepTypes_jn */
		delete 
		from ProtocolStepTypes_jn
		where 
[ProtocolStepTypeID] = @ProtocolStepTypeID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from ProtocolStepTypes_jn b
			where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from ProtocolStepTypes_jn a
where
a.[ProtocolStepTypeID] = @ProtocolStepTypeID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from ProtocolStepTypes_jn 
where 
[ProtocolStepTypeID] = @ProtocolStepTypeID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from ProtocolStepTypes
		where 
[ProtocolStepTypeID] = @ProtocolStepTypeID
end
else
begin
	
			update ProtocolStepTypes
			set 
   [Name]= @Name
,  [URL]= @URL
		where 
[ProtocolStepTypeID] = @ProtocolStepTypeID

		
		
		
		

		
		insert into ProtocolStepTypes (
 [ProtocolStepTypeID]
,[Name]
,[URL]
)
		select 
 @ProtocolStepTypeID
,@Name
,@URL
where not exists (Select ''x'' from ProtocolStepTypes where 
[ProtocolStepTypeID] = @ProtocolStepTypeID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into ProtocolStepTypes_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ProtocolStepTypeID]
,[Name]
,[URL]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ProtocolStepTypeID
,@Name
,@URL
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ProtocolStepTypeID
,@Name
,@URL

end
close read_main
deallocate read_main

  print ''ProtocolStepTypes_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.ProtocolStepTypes_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from ProtocolStepTypes_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.ProtocolStepTypes_jn  a,
		ProtocolStepTypes_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from ProtocolStepTypes a
where not exists (
select ''x''
from goliath.qms.dbo.ProtocolStepTypes b
where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
)





print '' step 2: update ''

	update f 
	set 
   f.[Name]= a.[Name]
,  f.[URL]= a.[URL]
 from ProtocolStepTypes f,goliath.qms.dbo.ProtocolStepTypes a
	where 
     a.[ProtocolStepTypeID]= f.[ProtocolStepTypeID]
and (
   a.[Name] != f.[Name]
or (a.[URL]  is null and f.[URL] is not null) or (a.[URL]  is not null and f.[URL] is null) or  (a.[URL] != f.[URL])
)
	
	
	

print '' Step 3: insert''
insert into ProtocolStepTypes(
 [ProtocolStepTypeID]
,[Name]
,[URL]
)
select 
 a.[ProtocolStepTypeID]
,a.[Name]
,a.[URL]
 from goliath.qms.dbo.ProtocolStepTypes a
where not exists (select ''x''
from  ProtocolStepTypes b
 where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from ProtocolStepTypes a
where not exists (
select ''x''
from goliath.qms.dbo.ProtocolStepTypes b
where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from ProtocolStepTypes f,goliath.qms.dbo.ProtocolStepTypes a
	where 
     a.[ProtocolStepTypeID]= f.[ProtocolStepTypeID]
and (
   a.[Name] != f.[Name]
or (a.[URL]  is null and f.[URL] is not null) or (a.[URL]  is not null and f.[URL] is null) or  (a.[URL] != f.[URL])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.ProtocolStepTypes a
where not exists (select ''x''
from  ProtocolStepTypes b
 where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from ProtocolStepTypes_jn a
where not exists (
select ''x''
from goliath.qms.dbo.ProtocolStepTypes_jn b
where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from ProtocolStepTypes_jn f,goliath.qms.dbo.ProtocolStepTypes_jn a
	where 
     a.[ProtocolStepTypeID]= f.[ProtocolStepTypeID]
and a.jn_datetime = f.jn_datetime and (
   a.[Name] != f.[Name]
or (a.[URL]  is null and f.[URL] is not null) or (a.[URL]  is not null and f.[URL] is null) or  (a.[URL] != f.[URL])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.ProtocolStepTypes_jn a
where not exists (select ''x''
from  ProtocolStepTypes_jn b
 where 
     a.[ProtocolStepTypeID]= b.[ProtocolStepTypeID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           ProtocolStepTypes done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
