/****** Object:  StoredProcedure [dbo].[Clients_pn]    Script Date: 08/08/2006 15:57:49 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Clients_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Clients_pn]
GO
/****** Object:  StoredProcedure [dbo].[Clients_pn]    Script Date: 08/08/2006 15:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Clients_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Clients_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Clients
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Clients''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @ClientID int
declare @Name varchar(100)
declare @Address1 varchar(250)
declare @Address2 varchar(250)
declare @City varchar(100)
declare @State varchar(100)
declare @PostalCode varchar(50)
declare @Telephone varchar(50)
declare @Fax varchar(50)
declare @Active tinyint

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
		  from Clients_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Clients_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ClientID]
,[Name]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[Telephone]
,[Fax]
,[Active]
from goliath.qms.dbo.Clients_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ClientID
,@Name
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@Telephone
,@Fax
,@Active
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Clients_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Clients_jn */
		delete 
		from Clients_jn
		where 
[ClientID] = @ClientID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from Clients_jn b
			where 
     a.[ClientID]= b.[ClientID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from Clients_jn a
where
a.[ClientID] = @ClientID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from Clients_jn 
where 
[ClientID] = @ClientID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from Clients
		where 
[ClientID] = @ClientID
end
else
begin
	
			update Clients
			set 
   [Name]= @Name
,  [Address1]= @Address1
,  [Address2]= @Address2
,  [City]= @City
,  [State]= @State
,  [PostalCode]= @PostalCode
,  [Telephone]= @Telephone
,  [Fax]= @Fax
,  [Active]= @Active
		where 
[ClientID] = @ClientID

		
		
		
		

		
		insert into Clients (
 [ClientID]
,[Name]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[Telephone]
,[Fax]
,[Active]
)
		select 
 @ClientID
,@Name
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@Telephone
,@Fax
,@Active
where not exists (Select ''x'' from Clients where 
[ClientID] = @ClientID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into Clients_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [ClientID]
,[Name]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[Telephone]
,[Fax]
,[Active]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ClientID
,@Name
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@Telephone
,@Fax
,@Active
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @ClientID
,@Name
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@Telephone
,@Fax
,@Active

end
close read_main
deallocate read_main

  print ''Clients_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Clients_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from Clients_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Clients_jn  a,
		Clients_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[ClientID]= b.[ClientID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from Clients a
where not exists (
select ''x''
from goliath.qms.dbo.Clients b
where 
     a.[ClientID]= b.[ClientID]
)





print '' step 2: update ''

	update f 
	set 
   f.[Name]= a.[Name]
,  f.[Address1]= a.[Address1]
,  f.[Address2]= a.[Address2]
,  f.[City]= a.[City]
,  f.[State]= a.[State]
,  f.[PostalCode]= a.[PostalCode]
,  f.[Telephone]= a.[Telephone]
,  f.[Fax]= a.[Fax]
,  f.[Active]= a.[Active]
 from Clients f,goliath.qms.dbo.Clients a
	where 
     a.[ClientID]= f.[ClientID]
and (
   a.[Name] != f.[Name]
or (a.[Address1]  is null and f.[Address1] is not null) or (a.[Address1]  is not null and f.[Address1] is null) or  (a.[Address1] != f.[Address1])
or (a.[Address2]  is null and f.[Address2] is not null) or (a.[Address2]  is not null and f.[Address2] is null) or  (a.[Address2] != f.[Address2])
or (a.[City]  is null and f.[City] is not null) or (a.[City]  is not null and f.[City] is null) or  (a.[City] != f.[City])
or (a.[State]  is null and f.[State] is not null) or (a.[State]  is not null and f.[State] is null) or  (a.[State] != f.[State])
or (a.[PostalCode]  is null and f.[PostalCode] is not null) or (a.[PostalCode]  is not null and f.[PostalCode] is null) or  (a.[PostalCode] != f.[PostalCode])
or (a.[Telephone]  is null and f.[Telephone] is not null) or (a.[Telephone]  is not null and f.[Telephone] is null) or  (a.[Telephone] != f.[Telephone])
or (a.[Fax]  is null and f.[Fax] is not null) or (a.[Fax]  is not null and f.[Fax] is null) or  (a.[Fax] != f.[Fax])
or  a.[Active] != f.[Active]
)
	
	
	

print '' Step 3: insert''
insert into Clients(
 [ClientID]
,[Name]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[Telephone]
,[Fax]
,[Active]
)
select 
 a.[ClientID]
,a.[Name]
,a.[Address1]
,a.[Address2]
,a.[City]
,a.[State]
,a.[PostalCode]
,a.[Telephone]
,a.[Fax]
,a.[Active]
 from goliath.qms.dbo.Clients a
where not exists (select ''x''
from  Clients b
 where 
     a.[ClientID]= b.[ClientID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Clients a
where not exists (
select ''x''
from goliath.qms.dbo.Clients b
where 
     a.[ClientID]= b.[ClientID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Clients f,goliath.qms.dbo.Clients a
	where 
     a.[ClientID]= f.[ClientID]
and (
   a.[Name] != f.[Name]
or (a.[Address1]  is null and f.[Address1] is not null) or (a.[Address1]  is not null and f.[Address1] is null) or  (a.[Address1] != f.[Address1])
or (a.[Address2]  is null and f.[Address2] is not null) or (a.[Address2]  is not null and f.[Address2] is null) or  (a.[Address2] != f.[Address2])
or (a.[City]  is null and f.[City] is not null) or (a.[City]  is not null and f.[City] is null) or  (a.[City] != f.[City])
or (a.[State]  is null and f.[State] is not null) or (a.[State]  is not null and f.[State] is null) or  (a.[State] != f.[State])
or (a.[PostalCode]  is null and f.[PostalCode] is not null) or (a.[PostalCode]  is not null and f.[PostalCode] is null) or  (a.[PostalCode] != f.[PostalCode])
or (a.[Telephone]  is null and f.[Telephone] is not null) or (a.[Telephone]  is not null and f.[Telephone] is null) or  (a.[Telephone] != f.[Telephone])
or (a.[Fax]  is null and f.[Fax] is not null) or (a.[Fax]  is not null and f.[Fax] is null) or  (a.[Fax] != f.[Fax])
or  a.[Active] != f.[Active]
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Clients a
where not exists (select ''x''
from  Clients b
 where 
     a.[ClientID]= b.[ClientID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Clients_jn a
where not exists (
select ''x''
from goliath.qms.dbo.Clients_jn b
where 
     a.[ClientID]= b.[ClientID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Clients_jn f,goliath.qms.dbo.Clients_jn a
	where 
     a.[ClientID]= f.[ClientID]
and a.jn_datetime = f.jn_datetime and (
   a.[Name] != f.[Name]
or (a.[Address1]  is null and f.[Address1] is not null) or (a.[Address1]  is not null and f.[Address1] is null) or  (a.[Address1] != f.[Address1])
or (a.[Address2]  is null and f.[Address2] is not null) or (a.[Address2]  is not null and f.[Address2] is null) or  (a.[Address2] != f.[Address2])
or (a.[City]  is null and f.[City] is not null) or (a.[City]  is not null and f.[City] is null) or  (a.[City] != f.[City])
or (a.[State]  is null and f.[State] is not null) or (a.[State]  is not null and f.[State] is null) or  (a.[State] != f.[State])
or (a.[PostalCode]  is null and f.[PostalCode] is not null) or (a.[PostalCode]  is not null and f.[PostalCode] is null) or  (a.[PostalCode] != f.[PostalCode])
or (a.[Telephone]  is null and f.[Telephone] is not null) or (a.[Telephone]  is not null and f.[Telephone] is null) or  (a.[Telephone] != f.[Telephone])
or (a.[Fax]  is null and f.[Fax] is not null) or (a.[Fax]  is not null and f.[Fax] is null) or  (a.[Fax] != f.[Fax])
or  a.[Active] != f.[Active]
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Clients_jn a
where not exists (select ''x''
from  Clients_jn b
 where 
     a.[ClientID]= b.[ClientID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Clients done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
