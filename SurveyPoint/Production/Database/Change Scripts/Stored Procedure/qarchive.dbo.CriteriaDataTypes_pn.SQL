/****** Object:  StoredProcedure [dbo].[CriteriaDataTypes_pn]    Script Date: 08/09/2006 13:37:07 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CriteriaDataTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[CriteriaDataTypes_pn]
GO
/****** Object:  StoredProcedure [dbo].[CriteriaDataTypes_pn]    Script Date: 08/09/2006 13:37:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CriteriaDataTypes_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure CriteriaDataTypes_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       CriteriaDataTypes
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           CriteriaDataTypes''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @CriteriaDataTypeID smallint
declare @CriteriaDataType varchar(100)

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
		  from CriteriaDataTypes_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.CriteriaDataTypes_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [CriteriaDataTypeID]
,[CriteriaDataType]
from goliath.qms.dbo.CriteriaDataTypes_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @CriteriaDataTypeID
,@CriteriaDataType
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''CriteriaDataTypes_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing CriteriaDataTypes_jn */
		delete 
		from CriteriaDataTypes_jn
		where 
[CriteriaDataTypeID] = @CriteriaDataTypeID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from CriteriaDataTypes_jn b
			where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from CriteriaDataTypes_jn a
where
a.[CriteriaDataTypeID] = @CriteriaDataTypeID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from CriteriaDataTypes_jn 
where 
[CriteriaDataTypeID] = @CriteriaDataTypeID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from CriteriaDataTypes
		where 
[CriteriaDataTypeID] = @CriteriaDataTypeID
end
else
begin
	
			update CriteriaDataTypes
			set 
   [CriteriaDataType]= @CriteriaDataType
		where 
[CriteriaDataTypeID] = @CriteriaDataTypeID

		
		
		
		

		
		insert into CriteriaDataTypes (
 [CriteriaDataTypeID]
,[CriteriaDataType]
)
		select 
 @CriteriaDataTypeID
,@CriteriaDataType
where not exists (Select ''x'' from CriteriaDataTypes where 
[CriteriaDataTypeID] = @CriteriaDataTypeID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into CriteriaDataTypes_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [CriteriaDataTypeID]
,[CriteriaDataType]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @CriteriaDataTypeID
,@CriteriaDataType
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @CriteriaDataTypeID
,@CriteriaDataType

end
close read_main
deallocate read_main

  print ''CriteriaDataTypes_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.CriteriaDataTypes_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from CriteriaDataTypes_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.CriteriaDataTypes_jn  a,
		CriteriaDataTypes_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from CriteriaDataTypes a
where not exists (
select ''x''
from goliath.qms.dbo.CriteriaDataTypes b
where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
)





print '' step 2: update ''

	update f 
	set 
   f.[CriteriaDataType]= a.[CriteriaDataType]
 from CriteriaDataTypes f,goliath.qms.dbo.CriteriaDataTypes a
	where 
     a.[CriteriaDataTypeID]= f.[CriteriaDataTypeID]
and (
   a.[CriteriaDataType] != f.[CriteriaDataType]
)
	
	
	

print '' Step 3: insert''
insert into CriteriaDataTypes(
 [CriteriaDataTypeID]
,[CriteriaDataType]
)
select 
 a.[CriteriaDataTypeID]
,a.[CriteriaDataType]
 from goliath.qms.dbo.CriteriaDataTypes a
where not exists (select ''x''
from  CriteriaDataTypes b
 where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from CriteriaDataTypes a
where not exists (
select ''x''
from goliath.qms.dbo.CriteriaDataTypes b
where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from CriteriaDataTypes f,goliath.qms.dbo.CriteriaDataTypes a
	where 
     a.[CriteriaDataTypeID]= f.[CriteriaDataTypeID]
and (
   a.[CriteriaDataType] != f.[CriteriaDataType]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.CriteriaDataTypes a
where not exists (select ''x''
from  CriteriaDataTypes b
 where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from CriteriaDataTypes_jn a
where not exists (
select ''x''
from goliath.qms.dbo.CriteriaDataTypes_jn b
where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from CriteriaDataTypes_jn f,goliath.qms.dbo.CriteriaDataTypes_jn a
	where 
     a.[CriteriaDataTypeID]= f.[CriteriaDataTypeID]
and a.jn_datetime = f.jn_datetime and (
   a.[CriteriaDataType] != f.[CriteriaDataType]
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.CriteriaDataTypes_jn a
where not exists (select ''x''
from  CriteriaDataTypes_jn b
 where 
     a.[CriteriaDataTypeID]= b.[CriteriaDataTypeID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           CriteriaDataTypes done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
