/****** Object:  StoredProcedure [dbo].[SurveyInstances_pn]    Script Date: 08/10/2006 09:32:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SurveyInstances_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SurveyInstances_pn]
GO
/****** Object:  StoredProcedure [dbo].[SurveyInstances_pn]    Script Date: 08/10/2006 09:32:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[SurveyInstances_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure SurveyInstances_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       SurveyInstances
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           SurveyInstances''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @SurveyInstanceID int
declare @SurveyID int
declare @ClientID int
declare @ProtocolID int
declare @Name varchar(100)
declare @InstanceDate datetime
declare @StartDate datetime
declare @Active tinyint
declare @GroupByHousehold tinyint
declare @SurveyInstanceKey varchar(100)
declare @SurveyInstanceCategoryID int
declare @QuarterEnding datetime

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
		  from SurveyInstances_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.SurveyInstances_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [SurveyInstanceID]
,[SurveyID]
,[ClientID]
,[ProtocolID]
,[Name]
,[InstanceDate]
,[StartDate]
,[Active]
,[GroupByHousehold]
,[SurveyInstanceKey]
,[SurveyInstanceCategoryID]
,[QuarterEnding]
from goliath.qms.dbo.SurveyInstances_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @SurveyInstanceID
,@SurveyID
,@ClientID
,@ProtocolID
,@Name
,@InstanceDate
,@StartDate
,@Active
,@GroupByHousehold
,@SurveyInstanceKey
,@SurveyInstanceCategoryID
,@QuarterEnding
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''SurveyInstances_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing SurveyInstances_jn */
		delete 
		from SurveyInstances_jn
		where 
[SurveyInstanceID] = @SurveyInstanceID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from SurveyInstances_jn b
			where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from SurveyInstances_jn a
where
a.[SurveyInstanceID] = @SurveyInstanceID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from SurveyInstances_jn 
where 
[SurveyInstanceID] = @SurveyInstanceID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from SurveyInstances
		where 
[SurveyInstanceID] = @SurveyInstanceID
end
else
begin
	
			update SurveyInstances
			set 
   [SurveyID]= @SurveyID
,  [ClientID]= @ClientID
,  [ProtocolID]= @ProtocolID
,  [Name]= @Name
,  [InstanceDate]= @InstanceDate
,  [StartDate]= @StartDate
,  [Active]= @Active
,  [GroupByHousehold]= @GroupByHousehold
,  [SurveyInstanceKey]= @SurveyInstanceKey
,  [SurveyInstanceCategoryID]= @SurveyInstanceCategoryID
,  [QuarterEnding]= @QuarterEnding
		where 
[SurveyInstanceID] = @SurveyInstanceID

		
		
		
		

		
		insert into SurveyInstances (
 [SurveyInstanceID]
,[SurveyID]
,[ClientID]
,[ProtocolID]
,[Name]
,[InstanceDate]
,[StartDate]
,[Active]
,[GroupByHousehold]
,[SurveyInstanceKey]
,[SurveyInstanceCategoryID]
,[QuarterEnding]
)
		select 
 @SurveyInstanceID
,@SurveyID
,@ClientID
,@ProtocolID
,@Name
,@InstanceDate
,@StartDate
,@Active
,@GroupByHousehold
,@SurveyInstanceKey
,@SurveyInstanceCategoryID
,@QuarterEnding
where not exists (Select ''x'' from SurveyInstances where 
[SurveyInstanceID] = @SurveyInstanceID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into SurveyInstances_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [SurveyInstanceID]
,[SurveyID]
,[ClientID]
,[ProtocolID]
,[Name]
,[InstanceDate]
,[StartDate]
,[Active]
,[GroupByHousehold]
,[SurveyInstanceKey]
,[SurveyInstanceCategoryID]
,[QuarterEnding]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @SurveyInstanceID
,@SurveyID
,@ClientID
,@ProtocolID
,@Name
,@InstanceDate
,@StartDate
,@Active
,@GroupByHousehold
,@SurveyInstanceKey
,@SurveyInstanceCategoryID
,@QuarterEnding
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @SurveyInstanceID
,@SurveyID
,@ClientID
,@ProtocolID
,@Name
,@InstanceDate
,@StartDate
,@Active
,@GroupByHousehold
,@SurveyInstanceKey
,@SurveyInstanceCategoryID
,@QuarterEnding

end
close read_main
deallocate read_main

  print ''SurveyInstances_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.SurveyInstances_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from SurveyInstances_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.SurveyInstances_jn  a,
		SurveyInstances_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from SurveyInstances a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstances b
where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
)





print '' step 2: update ''

	update f 
	set 
   f.[SurveyID]= a.[SurveyID]
,  f.[ClientID]= a.[ClientID]
,  f.[ProtocolID]= a.[ProtocolID]
,  f.[Name]= a.[Name]
,  f.[InstanceDate]= a.[InstanceDate]
,  f.[StartDate]= a.[StartDate]
,  f.[Active]= a.[Active]
,  f.[GroupByHousehold]= a.[GroupByHousehold]
,  f.[SurveyInstanceKey]= a.[SurveyInstanceKey]
,  f.[SurveyInstanceCategoryID]= a.[SurveyInstanceCategoryID]
,  f.[QuarterEnding]= a.[QuarterEnding]
 from SurveyInstances f,goliath.qms.dbo.SurveyInstances a
	where 
     a.[SurveyInstanceID]= f.[SurveyInstanceID]
and (
   a.[SurveyID] != f.[SurveyID]
or  a.[ClientID] != f.[ClientID]
or  a.[ProtocolID] != f.[ProtocolID]
or  a.[Name] != f.[Name]
or (a.[InstanceDate]  is null and f.[InstanceDate] is not null) or (a.[InstanceDate]  is not null and f.[InstanceDate] is null) or  (a.[InstanceDate] != f.[InstanceDate])
or (a.[StartDate]  is null and f.[StartDate] is not null) or (a.[StartDate]  is not null and f.[StartDate] is null) or  (a.[StartDate] != f.[StartDate])
or  a.[Active] != f.[Active]
or  a.[GroupByHousehold] != f.[GroupByHousehold]
or (a.[SurveyInstanceKey]  is null and f.[SurveyInstanceKey] is not null) or (a.[SurveyInstanceKey]  is not null and f.[SurveyInstanceKey] is null) or  (a.[SurveyInstanceKey] != f.[SurveyInstanceKey])
or (a.[SurveyInstanceCategoryID]  is null and f.[SurveyInstanceCategoryID] is not null) or (a.[SurveyInstanceCategoryID]  is not null and f.[SurveyInstanceCategoryID] is null) or  (a.[SurveyInstanceCategoryID] != f.[SurveyInstanceCategoryID])
or (a.[QuarterEnding]  is null and f.[QuarterEnding] is not null) or (a.[QuarterEnding]  is not null and f.[QuarterEnding] is null) or  (a.[QuarterEnding] != f.[QuarterEnding])
)
	
	
	

print '' Step 3: insert''
insert into SurveyInstances(
 [SurveyInstanceID]
,[SurveyID]
,[ClientID]
,[ProtocolID]
,[Name]
,[InstanceDate]
,[StartDate]
,[Active]
,[GroupByHousehold]
,[SurveyInstanceKey]
,[SurveyInstanceCategoryID]
,[QuarterEnding]
)
select 
 a.[SurveyInstanceID]
,a.[SurveyID]
,a.[ClientID]
,a.[ProtocolID]
,a.[Name]
,a.[InstanceDate]
,a.[StartDate]
,a.[Active]
,a.[GroupByHousehold]
,a.[SurveyInstanceKey]
,a.[SurveyInstanceCategoryID]
,a.[QuarterEnding]
 from goliath.qms.dbo.SurveyInstances a
where not exists (select ''x''
from  SurveyInstances b
 where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from SurveyInstances a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstances b
where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from SurveyInstances f,goliath.qms.dbo.SurveyInstances a
	where 
     a.[SurveyInstanceID]= f.[SurveyInstanceID]
and (
   a.[SurveyID] != f.[SurveyID]
or  a.[ClientID] != f.[ClientID]
or  a.[ProtocolID] != f.[ProtocolID]
or  a.[Name] != f.[Name]
or (a.[InstanceDate]  is null and f.[InstanceDate] is not null) or (a.[InstanceDate]  is not null and f.[InstanceDate] is null) or  (a.[InstanceDate] != f.[InstanceDate])
or (a.[StartDate]  is null and f.[StartDate] is not null) or (a.[StartDate]  is not null and f.[StartDate] is null) or  (a.[StartDate] != f.[StartDate])
or  a.[Active] != f.[Active]
or  a.[GroupByHousehold] != f.[GroupByHousehold]
or (a.[SurveyInstanceKey]  is null and f.[SurveyInstanceKey] is not null) or (a.[SurveyInstanceKey]  is not null and f.[SurveyInstanceKey] is null) or  (a.[SurveyInstanceKey] != f.[SurveyInstanceKey])
or (a.[SurveyInstanceCategoryID]  is null and f.[SurveyInstanceCategoryID] is not null) or (a.[SurveyInstanceCategoryID]  is not null and f.[SurveyInstanceCategoryID] is null) or  (a.[SurveyInstanceCategoryID] != f.[SurveyInstanceCategoryID])
or (a.[QuarterEnding]  is null and f.[QuarterEnding] is not null) or (a.[QuarterEnding]  is not null and f.[QuarterEnding] is null) or  (a.[QuarterEnding] != f.[QuarterEnding])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.SurveyInstances a
where not exists (select ''x''
from  SurveyInstances b
 where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from SurveyInstances_jn a
where not exists (
select ''x''
from goliath.qms.dbo.SurveyInstances_jn b
where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from SurveyInstances_jn f,goliath.qms.dbo.SurveyInstances_jn a
	where 
     a.[SurveyInstanceID]= f.[SurveyInstanceID]
and a.jn_datetime = f.jn_datetime and (
   a.[SurveyID] != f.[SurveyID]
or  a.[ClientID] != f.[ClientID]
or  a.[ProtocolID] != f.[ProtocolID]
or  a.[Name] != f.[Name]
or (a.[InstanceDate]  is null and f.[InstanceDate] is not null) or (a.[InstanceDate]  is not null and f.[InstanceDate] is null) or  (a.[InstanceDate] != f.[InstanceDate])
or (a.[StartDate]  is null and f.[StartDate] is not null) or (a.[StartDate]  is not null and f.[StartDate] is null) or  (a.[StartDate] != f.[StartDate])
or  a.[Active] != f.[Active]
or  a.[GroupByHousehold] != f.[GroupByHousehold]
or (a.[SurveyInstanceKey]  is null and f.[SurveyInstanceKey] is not null) or (a.[SurveyInstanceKey]  is not null and f.[SurveyInstanceKey] is null) or  (a.[SurveyInstanceKey] != f.[SurveyInstanceKey])
or (a.[SurveyInstanceCategoryID]  is null and f.[SurveyInstanceCategoryID] is not null) or (a.[SurveyInstanceCategoryID]  is not null and f.[SurveyInstanceCategoryID] is null) or  (a.[SurveyInstanceCategoryID] != f.[SurveyInstanceCategoryID])
or (a.[QuarterEnding]  is null and f.[QuarterEnding] is not null) or (a.[QuarterEnding]  is not null and f.[QuarterEnding] is null) or  (a.[QuarterEnding] != f.[QuarterEnding])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.SurveyInstances_jn a
where not exists (select ''x''
from  SurveyInstances_jn b
 where 
     a.[SurveyInstanceID]= b.[SurveyInstanceID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           SurveyInstances done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
