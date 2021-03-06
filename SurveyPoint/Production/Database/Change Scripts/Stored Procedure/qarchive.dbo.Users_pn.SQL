/****** Object:  StoredProcedure [dbo].[Users_pn]    Script Date: 08/09/2006 08:52:38 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Users_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Users_pn]
GO
/****** Object:  StoredProcedure [dbo].[Users_pn]    Script Date: 08/09/2006 08:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Users_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Users_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Users
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Users''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @UserID int
declare @Username varchar(50)
declare @FirstName varchar(100)
declare @LastName varchar(100)
declare @Password varchar(100)
declare @Email varchar(100)
declare @GroupID int
declare @Active tinyint
declare @VerificationRate int
declare @KeyMonitorRate int

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
		  from Users_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Users_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [UserID]
,[Username]
,[FirstName]
,[LastName]
,[Password]
,[Email]
,[GroupID]
,[Active]
,[VerificationRate]
,[KeyMonitorRate]
from goliath.qms.dbo.Users_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @UserID
,@Username
,@FirstName
,@LastName
,@Password
,@Email
,@GroupID
,@Active
,@VerificationRate
,@KeyMonitorRate
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Users_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Users_jn */
		delete 
		from Users_jn
		where 
[UserID] = @UserID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from Users_jn b
			where 
     a.[UserID]= b.[UserID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from Users_jn a
where
a.[UserID] = @UserID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from Users_jn 
where 
[UserID] = @UserID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from Users
		where 
[UserID] = @UserID
end
else
begin
	
			update Users
			set 
   [Username]= @Username
,  [FirstName]= @FirstName
,  [LastName]= @LastName
,  [Password]= @Password
,  [Email]= @Email
,  [GroupID]= @GroupID
,  [Active]= @Active
,  [VerificationRate]= @VerificationRate
,  [KeyMonitorRate]= @KeyMonitorRate
		where 
[UserID] = @UserID

		
		
		
		

		
		insert into Users (
 [UserID]
,[Username]
,[FirstName]
,[LastName]
,[Password]
,[Email]
,[GroupID]
,[Active]
,[VerificationRate]
,[KeyMonitorRate]
)
		select 
 @UserID
,@Username
,@FirstName
,@LastName
,@Password
,@Email
,@GroupID
,@Active
,@VerificationRate
,@KeyMonitorRate
where not exists (Select ''x'' from Users where 
[UserID] = @UserID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into Users_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [UserID]
,[Username]
,[FirstName]
,[LastName]
,[Password]
,[Email]
,[GroupID]
,[Active]
,[VerificationRate]
,[KeyMonitorRate]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @UserID
,@Username
,@FirstName
,@LastName
,@Password
,@Email
,@GroupID
,@Active
,@VerificationRate
,@KeyMonitorRate
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @UserID
,@Username
,@FirstName
,@LastName
,@Password
,@Email
,@GroupID
,@Active
,@VerificationRate
,@KeyMonitorRate

end
close read_main
deallocate read_main

  print ''Users_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Users_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from Users_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Users_jn  a,
		Users_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[UserID]= b.[UserID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from Users a
where not exists (
select ''x''
from goliath.qms.dbo.Users b
where 
     a.[UserID]= b.[UserID]
)





print '' step 2: update ''

	update f 
	set 
   f.[Username]= a.[Username]
,  f.[FirstName]= a.[FirstName]
,  f.[LastName]= a.[LastName]
,  f.[Password]= a.[Password]
,  f.[Email]= a.[Email]
,  f.[GroupID]= a.[GroupID]
,  f.[Active]= a.[Active]
,  f.[VerificationRate]= a.[VerificationRate]
,  f.[KeyMonitorRate]= a.[KeyMonitorRate]
 from Users f,goliath.qms.dbo.Users a
	where 
     a.[UserID]= f.[UserID]
and (
   a.[Username] != f.[Username]
or (a.[FirstName]  is null and f.[FirstName] is not null) or (a.[FirstName]  is not null and f.[FirstName] is null) or  (a.[FirstName] != f.[FirstName])
or (a.[LastName]  is null and f.[LastName] is not null) or (a.[LastName]  is not null and f.[LastName] is null) or  (a.[LastName] != f.[LastName])
or  a.[Password] != f.[Password]
or (a.[Email]  is null and f.[Email] is not null) or (a.[Email]  is not null and f.[Email] is null) or  (a.[Email] != f.[Email])
or  a.[GroupID] != f.[GroupID]
or  a.[Active] != f.[Active]
or (a.[VerificationRate]  is null and f.[VerificationRate] is not null) or (a.[VerificationRate]  is not null and f.[VerificationRate] is null) or  (a.[VerificationRate] != f.[VerificationRate])
or (a.[KeyMonitorRate]  is null and f.[KeyMonitorRate] is not null) or (a.[KeyMonitorRate]  is not null and f.[KeyMonitorRate] is null) or  (a.[KeyMonitorRate] != f.[KeyMonitorRate])
)
	
	
	

print '' Step 3: insert''
insert into Users(
 [UserID]
,[Username]
,[FirstName]
,[LastName]
,[Password]
,[Email]
,[GroupID]
,[Active]
,[VerificationRate]
,[KeyMonitorRate]
)
select 
 a.[UserID]
,a.[Username]
,a.[FirstName]
,a.[LastName]
,a.[Password]
,a.[Email]
,a.[GroupID]
,a.[Active]
,a.[VerificationRate]
,a.[KeyMonitorRate]
 from goliath.qms.dbo.Users a
where not exists (select ''x''
from  Users b
 where 
     a.[UserID]= b.[UserID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Users a
where not exists (
select ''x''
from goliath.qms.dbo.Users b
where 
     a.[UserID]= b.[UserID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Users f,goliath.qms.dbo.Users a
	where 
     a.[UserID]= f.[UserID]
and (
   a.[Username] != f.[Username]
or (a.[FirstName]  is null and f.[FirstName] is not null) or (a.[FirstName]  is not null and f.[FirstName] is null) or  (a.[FirstName] != f.[FirstName])
or (a.[LastName]  is null and f.[LastName] is not null) or (a.[LastName]  is not null and f.[LastName] is null) or  (a.[LastName] != f.[LastName])
or  a.[Password] != f.[Password]
or (a.[Email]  is null and f.[Email] is not null) or (a.[Email]  is not null and f.[Email] is null) or  (a.[Email] != f.[Email])
or  a.[GroupID] != f.[GroupID]
or  a.[Active] != f.[Active]
or (a.[VerificationRate]  is null and f.[VerificationRate] is not null) or (a.[VerificationRate]  is not null and f.[VerificationRate] is null) or  (a.[VerificationRate] != f.[VerificationRate])
or (a.[KeyMonitorRate]  is null and f.[KeyMonitorRate] is not null) or (a.[KeyMonitorRate]  is not null and f.[KeyMonitorRate] is null) or  (a.[KeyMonitorRate] != f.[KeyMonitorRate])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Users a
where not exists (select ''x''
from  Users b
 where 
     a.[UserID]= b.[UserID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Users_jn a
where not exists (
select ''x''
from goliath.qms.dbo.Users_jn b
where 
     a.[UserID]= b.[UserID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Users_jn f,goliath.qms.dbo.Users_jn a
	where 
     a.[UserID]= f.[UserID]
and a.jn_datetime = f.jn_datetime and (
   a.[Username] != f.[Username]
or (a.[FirstName]  is null and f.[FirstName] is not null) or (a.[FirstName]  is not null and f.[FirstName] is null) or  (a.[FirstName] != f.[FirstName])
or (a.[LastName]  is null and f.[LastName] is not null) or (a.[LastName]  is not null and f.[LastName] is null) or  (a.[LastName] != f.[LastName])
or  a.[Password] != f.[Password]
or (a.[Email]  is null and f.[Email] is not null) or (a.[Email]  is not null and f.[Email] is null) or  (a.[Email] != f.[Email])
or  a.[GroupID] != f.[GroupID]
or  a.[Active] != f.[Active]
or (a.[VerificationRate]  is null and f.[VerificationRate] is not null) or (a.[VerificationRate]  is not null and f.[VerificationRate] is null) or  (a.[VerificationRate] != f.[VerificationRate])
or (a.[KeyMonitorRate]  is null and f.[KeyMonitorRate] is not null) or (a.[KeyMonitorRate]  is not null and f.[KeyMonitorRate] is null) or  (a.[KeyMonitorRate] != f.[KeyMonitorRate])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Users_jn a
where not exists (select ''x''
from  Users_jn b
 where 
     a.[UserID]= b.[UserID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Users done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
