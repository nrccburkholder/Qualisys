/****** Object:  StoredProcedure [dbo].[Respondents_pn]    Script Date: 08/10/2006 10:24:22 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Respondents_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[Respondents_pn]
GO
/****** Object:  StoredProcedure [dbo].[Respondents_pn]    Script Date: 08/10/2006 10:24:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Respondents_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure Respondents_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       Respondents
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           Respondents''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @RespondentID int
declare @SurveyInstanceID int
declare @FirstName varchar(100)
declare @MiddleInitial varchar(10)
declare @LastName varchar(100)
declare @Address1 varchar(250)
declare @Address2 varchar(250)
declare @City varchar(100)
declare @State char(2)
declare @PostalCode varchar(50)
declare @TelephoneDay varchar(50)
declare @TelephoneEvening varchar(50)
declare @Email varchar(50)
declare @DOB datetime
declare @Gender char(1)
declare @ClientRespondentID varchar(50)
declare @SSN varchar(50)
declare @BatchID int
declare @MailingSeedFlag tinyint
declare @CallsMade int
declare @Final int
declare @NextContact datetime
declare @PostalCodeExt varchar(10)
declare @RespondentKey varchar(100)

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
		  from Respondents_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.Respondents_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [RespondentID]
,[SurveyInstanceID]
,[FirstName]
,[MiddleInitial]
,[LastName]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[TelephoneDay]
,[TelephoneEvening]
,[Email]
,[DOB]
,[Gender]
,[ClientRespondentID]
,[SSN]
,[BatchID]
,[MailingSeedFlag]
,[CallsMade]
,[Final]
,[NextContact]
,[PostalCodeExt]
,[RespondentKey]
from goliath.qms.dbo.Respondents_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @RespondentID
,@SurveyInstanceID
,@FirstName
,@MiddleInitial
,@LastName
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@TelephoneDay
,@TelephoneEvening
,@Email
,@DOB
,@Gender
,@ClientRespondentID
,@SSN
,@BatchID
,@MailingSeedFlag
,@CallsMade
,@Final
,@NextContact
,@PostalCodeExt
,@RespondentKey
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''Respondents_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing Respondents_jn */
		delete 
		from Respondents_jn
		where 
[RespondentID] = @RespondentID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from Respondents_jn b
			where 
     a.[RespondentID]= b.[RespondentID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from Respondents_jn a
where
a.[RespondentID] = @RespondentID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from Respondents_jn 
where 
[RespondentID] = @RespondentID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from Respondents
		where 
[RespondentID] = @RespondentID
end
else
begin
	
			update Respondents
			set 
   [SurveyInstanceID]= @SurveyInstanceID
,  [FirstName]= @FirstName
,  [MiddleInitial]= @MiddleInitial
,  [LastName]= @LastName
,  [Address1]= @Address1
,  [Address2]= @Address2
,  [City]= @City
,  [State]= @State
,  [PostalCode]= @PostalCode
,  [TelephoneDay]= @TelephoneDay
,  [TelephoneEvening]= @TelephoneEvening
,  [Email]= @Email
,  [DOB]= @DOB
,  [Gender]= @Gender
,  [ClientRespondentID]= @ClientRespondentID
,  [SSN]= @SSN
,  [BatchID]= @BatchID
,  [MailingSeedFlag]= @MailingSeedFlag
,  [CallsMade]= @CallsMade
,  [Final]= @Final
,  [NextContact]= @NextContact
,  [PostalCodeExt]= @PostalCodeExt
,  [RespondentKey]= @RespondentKey
		where 
[RespondentID] = @RespondentID

		
		
		
		

		
		insert into Respondents (
 [RespondentID]
,[SurveyInstanceID]
,[FirstName]
,[MiddleInitial]
,[LastName]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[TelephoneDay]
,[TelephoneEvening]
,[Email]
,[DOB]
,[Gender]
,[ClientRespondentID]
,[SSN]
,[BatchID]
,[MailingSeedFlag]
,[CallsMade]
,[Final]
,[NextContact]
,[PostalCodeExt]
,[RespondentKey]
)
		select 
 @RespondentID
,@SurveyInstanceID
,@FirstName
,@MiddleInitial
,@LastName
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@TelephoneDay
,@TelephoneEvening
,@Email
,@DOB
,@Gender
,@ClientRespondentID
,@SSN
,@BatchID
,@MailingSeedFlag
,@CallsMade
,@Final
,@NextContact
,@PostalCodeExt
,@RespondentKey
where not exists (Select ''x'' from Respondents where 
[RespondentID] = @RespondentID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into Respondents_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [RespondentID]
,[SurveyInstanceID]
,[FirstName]
,[MiddleInitial]
,[LastName]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[TelephoneDay]
,[TelephoneEvening]
,[Email]
,[DOB]
,[Gender]
,[ClientRespondentID]
,[SSN]
,[BatchID]
,[MailingSeedFlag]
,[CallsMade]
,[Final]
,[NextContact]
,[PostalCodeExt]
,[RespondentKey]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @RespondentID
,@SurveyInstanceID
,@FirstName
,@MiddleInitial
,@LastName
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@TelephoneDay
,@TelephoneEvening
,@Email
,@DOB
,@Gender
,@ClientRespondentID
,@SSN
,@BatchID
,@MailingSeedFlag
,@CallsMade
,@Final
,@NextContact
,@PostalCodeExt
,@RespondentKey
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @RespondentID
,@SurveyInstanceID
,@FirstName
,@MiddleInitial
,@LastName
,@Address1
,@Address2
,@City
,@State
,@PostalCode
,@TelephoneDay
,@TelephoneEvening
,@Email
,@DOB
,@Gender
,@ClientRespondentID
,@SSN
,@BatchID
,@MailingSeedFlag
,@CallsMade
,@Final
,@NextContact
,@PostalCodeExt
,@RespondentKey

end
close read_main
deallocate read_main

  print ''Respondents_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.Respondents_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from Respondents_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.Respondents_jn  a,
		Respondents_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[RespondentID]= b.[RespondentID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from Respondents a
where not exists (
select ''x''
from goliath.qms.dbo.Respondents b
where 
     a.[RespondentID]= b.[RespondentID]
)





print '' step 2: update ''

	update f 
	set 
   f.[SurveyInstanceID]= a.[SurveyInstanceID]
,  f.[FirstName]= a.[FirstName]
,  f.[MiddleInitial]= a.[MiddleInitial]
,  f.[LastName]= a.[LastName]
,  f.[Address1]= a.[Address1]
,  f.[Address2]= a.[Address2]
,  f.[City]= a.[City]
,  f.[State]= a.[State]
,  f.[PostalCode]= a.[PostalCode]
,  f.[TelephoneDay]= a.[TelephoneDay]
,  f.[TelephoneEvening]= a.[TelephoneEvening]
,  f.[Email]= a.[Email]
,  f.[DOB]= a.[DOB]
,  f.[Gender]= a.[Gender]
,  f.[ClientRespondentID]= a.[ClientRespondentID]
,  f.[SSN]= a.[SSN]
,  f.[BatchID]= a.[BatchID]
,  f.[MailingSeedFlag]= a.[MailingSeedFlag]
,  f.[CallsMade]= a.[CallsMade]
,  f.[Final]= a.[Final]
,  f.[NextContact]= a.[NextContact]
,  f.[PostalCodeExt]= a.[PostalCodeExt]
,  f.[RespondentKey]= a.[RespondentKey]
 from Respondents f,goliath.qms.dbo.Respondents a
	where 
     a.[RespondentID]= f.[RespondentID]
and (
   a.[SurveyInstanceID] != f.[SurveyInstanceID]
or (a.[FirstName]  is null and f.[FirstName] is not null) or (a.[FirstName]  is not null and f.[FirstName] is null) or  (a.[FirstName] != f.[FirstName])
or (a.[MiddleInitial]  is null and f.[MiddleInitial] is not null) or (a.[MiddleInitial]  is not null and f.[MiddleInitial] is null) or  (a.[MiddleInitial] != f.[MiddleInitial])
or  a.[LastName] != f.[LastName]
or (a.[Address1]  is null and f.[Address1] is not null) or (a.[Address1]  is not null and f.[Address1] is null) or  (a.[Address1] != f.[Address1])
or (a.[Address2]  is null and f.[Address2] is not null) or (a.[Address2]  is not null and f.[Address2] is null) or  (a.[Address2] != f.[Address2])
or (a.[City]  is null and f.[City] is not null) or (a.[City]  is not null and f.[City] is null) or  (a.[City] != f.[City])
or (a.[State]  is null and f.[State] is not null) or (a.[State]  is not null and f.[State] is null) or  (a.[State] != f.[State])
or (a.[PostalCode]  is null and f.[PostalCode] is not null) or (a.[PostalCode]  is not null and f.[PostalCode] is null) or  (a.[PostalCode] != f.[PostalCode])
or (a.[TelephoneDay]  is null and f.[TelephoneDay] is not null) or (a.[TelephoneDay]  is not null and f.[TelephoneDay] is null) or  (a.[TelephoneDay] != f.[TelephoneDay])
or (a.[TelephoneEvening]  is null and f.[TelephoneEvening] is not null) or (a.[TelephoneEvening]  is not null and f.[TelephoneEvening] is null) or  (a.[TelephoneEvening] != f.[TelephoneEvening])
or (a.[Email]  is null and f.[Email] is not null) or (a.[Email]  is not null and f.[Email] is null) or  (a.[Email] != f.[Email])
or (a.[DOB]  is null and f.[DOB] is not null) or (a.[DOB]  is not null and f.[DOB] is null) or  (a.[DOB] != f.[DOB])
or (a.[Gender]  is null and f.[Gender] is not null) or (a.[Gender]  is not null and f.[Gender] is null) or  (a.[Gender] != f.[Gender])
or (a.[ClientRespondentID]  is null and f.[ClientRespondentID] is not null) or (a.[ClientRespondentID]  is not null and f.[ClientRespondentID] is null) or  (a.[ClientRespondentID] != f.[ClientRespondentID])
or (a.[SSN]  is null and f.[SSN] is not null) or (a.[SSN]  is not null and f.[SSN] is null) or  (a.[SSN] != f.[SSN])
or (a.[BatchID]  is null and f.[BatchID] is not null) or (a.[BatchID]  is not null and f.[BatchID] is null) or  (a.[BatchID] != f.[BatchID])
or (a.[MailingSeedFlag]  is null and f.[MailingSeedFlag] is not null) or (a.[MailingSeedFlag]  is not null and f.[MailingSeedFlag] is null) or  (a.[MailingSeedFlag] != f.[MailingSeedFlag])
or  a.[CallsMade] != f.[CallsMade]
or  a.[Final] != f.[Final]
or (a.[NextContact]  is null and f.[NextContact] is not null) or (a.[NextContact]  is not null and f.[NextContact] is null) or  (a.[NextContact] != f.[NextContact])
or (a.[PostalCodeExt]  is null and f.[PostalCodeExt] is not null) or (a.[PostalCodeExt]  is not null and f.[PostalCodeExt] is null) or  (a.[PostalCodeExt] != f.[PostalCodeExt])
or (a.[RespondentKey]  is null and f.[RespondentKey] is not null) or (a.[RespondentKey]  is not null and f.[RespondentKey] is null) or  (a.[RespondentKey] != f.[RespondentKey])
)
	
	
	

print '' Step 3: insert''
insert into Respondents(
 [RespondentID]
,[SurveyInstanceID]
,[FirstName]
,[MiddleInitial]
,[LastName]
,[Address1]
,[Address2]
,[City]
,[State]
,[PostalCode]
,[TelephoneDay]
,[TelephoneEvening]
,[Email]
,[DOB]
,[Gender]
,[ClientRespondentID]
,[SSN]
,[BatchID]
,[MailingSeedFlag]
,[CallsMade]
,[Final]
,[NextContact]
,[PostalCodeExt]
,[RespondentKey]
)
select 
 a.[RespondentID]
,a.[SurveyInstanceID]
,a.[FirstName]
,a.[MiddleInitial]
,a.[LastName]
,a.[Address1]
,a.[Address2]
,a.[City]
,a.[State]
,a.[PostalCode]
,a.[TelephoneDay]
,a.[TelephoneEvening]
,a.[Email]
,a.[DOB]
,a.[Gender]
,a.[ClientRespondentID]
,a.[SSN]
,a.[BatchID]
,a.[MailingSeedFlag]
,a.[CallsMade]
,a.[Final]
,a.[NextContact]
,a.[PostalCodeExt]
,a.[RespondentKey]
 from goliath.qms.dbo.Respondents a
where not exists (select ''x''
from  Respondents b
 where 
     a.[RespondentID]= b.[RespondentID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Respondents a
where not exists (
select ''x''
from goliath.qms.dbo.Respondents b
where 
     a.[RespondentID]= b.[RespondentID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Respondents f,goliath.qms.dbo.Respondents a
	where 
     a.[RespondentID]= f.[RespondentID]
and (
   a.[SurveyInstanceID] != f.[SurveyInstanceID]
or (a.[FirstName]  is null and f.[FirstName] is not null) or (a.[FirstName]  is not null and f.[FirstName] is null) or  (a.[FirstName] != f.[FirstName])
or (a.[MiddleInitial]  is null and f.[MiddleInitial] is not null) or (a.[MiddleInitial]  is not null and f.[MiddleInitial] is null) or  (a.[MiddleInitial] != f.[MiddleInitial])
or  a.[LastName] != f.[LastName]
or (a.[Address1]  is null and f.[Address1] is not null) or (a.[Address1]  is not null and f.[Address1] is null) or  (a.[Address1] != f.[Address1])
or (a.[Address2]  is null and f.[Address2] is not null) or (a.[Address2]  is not null and f.[Address2] is null) or  (a.[Address2] != f.[Address2])
or (a.[City]  is null and f.[City] is not null) or (a.[City]  is not null and f.[City] is null) or  (a.[City] != f.[City])
or (a.[State]  is null and f.[State] is not null) or (a.[State]  is not null and f.[State] is null) or  (a.[State] != f.[State])
or (a.[PostalCode]  is null and f.[PostalCode] is not null) or (a.[PostalCode]  is not null and f.[PostalCode] is null) or  (a.[PostalCode] != f.[PostalCode])
or (a.[TelephoneDay]  is null and f.[TelephoneDay] is not null) or (a.[TelephoneDay]  is not null and f.[TelephoneDay] is null) or  (a.[TelephoneDay] != f.[TelephoneDay])
or (a.[TelephoneEvening]  is null and f.[TelephoneEvening] is not null) or (a.[TelephoneEvening]  is not null and f.[TelephoneEvening] is null) or  (a.[TelephoneEvening] != f.[TelephoneEvening])
or (a.[Email]  is null and f.[Email] is not null) or (a.[Email]  is not null and f.[Email] is null) or  (a.[Email] != f.[Email])
or (a.[DOB]  is null and f.[DOB] is not null) or (a.[DOB]  is not null and f.[DOB] is null) or  (a.[DOB] != f.[DOB])
or (a.[Gender]  is null and f.[Gender] is not null) or (a.[Gender]  is not null and f.[Gender] is null) or  (a.[Gender] != f.[Gender])
or (a.[ClientRespondentID]  is null and f.[ClientRespondentID] is not null) or (a.[ClientRespondentID]  is not null and f.[ClientRespondentID] is null) or  (a.[ClientRespondentID] != f.[ClientRespondentID])
or (a.[SSN]  is null and f.[SSN] is not null) or (a.[SSN]  is not null and f.[SSN] is null) or  (a.[SSN] != f.[SSN])
or (a.[BatchID]  is null and f.[BatchID] is not null) or (a.[BatchID]  is not null and f.[BatchID] is null) or  (a.[BatchID] != f.[BatchID])
or (a.[MailingSeedFlag]  is null and f.[MailingSeedFlag] is not null) or (a.[MailingSeedFlag]  is not null and f.[MailingSeedFlag] is null) or  (a.[MailingSeedFlag] != f.[MailingSeedFlag])
or  a.[CallsMade] != f.[CallsMade]
or  a.[Final] != f.[Final]
or (a.[NextContact]  is null and f.[NextContact] is not null) or (a.[NextContact]  is not null and f.[NextContact] is null) or  (a.[NextContact] != f.[NextContact])
or (a.[PostalCodeExt]  is null and f.[PostalCodeExt] is not null) or (a.[PostalCodeExt]  is not null and f.[PostalCodeExt] is null) or  (a.[PostalCodeExt] != f.[PostalCodeExt])
or (a.[RespondentKey]  is null and f.[RespondentKey] is not null) or (a.[RespondentKey]  is not null and f.[RespondentKey] is null) or  (a.[RespondentKey] != f.[RespondentKey])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Respondents a
where not exists (select ''x''
from  Respondents b
 where 
     a.[RespondentID]= b.[RespondentID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from Respondents_jn a
where not exists (
select ''x''
from goliath.qms.dbo.Respondents_jn b
where 
     a.[RespondentID]= b.[RespondentID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from Respondents_jn f,goliath.qms.dbo.Respondents_jn a
	where 
     a.[RespondentID]= f.[RespondentID]
and a.jn_datetime = f.jn_datetime and (
   a.[SurveyInstanceID] != f.[SurveyInstanceID]
or (a.[FirstName]  is null and f.[FirstName] is not null) or (a.[FirstName]  is not null and f.[FirstName] is null) or  (a.[FirstName] != f.[FirstName])
or (a.[MiddleInitial]  is null and f.[MiddleInitial] is not null) or (a.[MiddleInitial]  is not null and f.[MiddleInitial] is null) or  (a.[MiddleInitial] != f.[MiddleInitial])
or  a.[LastName] != f.[LastName]
or (a.[Address1]  is null and f.[Address1] is not null) or (a.[Address1]  is not null and f.[Address1] is null) or  (a.[Address1] != f.[Address1])
or (a.[Address2]  is null and f.[Address2] is not null) or (a.[Address2]  is not null and f.[Address2] is null) or  (a.[Address2] != f.[Address2])
or (a.[City]  is null and f.[City] is not null) or (a.[City]  is not null and f.[City] is null) or  (a.[City] != f.[City])
or (a.[State]  is null and f.[State] is not null) or (a.[State]  is not null and f.[State] is null) or  (a.[State] != f.[State])
or (a.[PostalCode]  is null and f.[PostalCode] is not null) or (a.[PostalCode]  is not null and f.[PostalCode] is null) or  (a.[PostalCode] != f.[PostalCode])
or (a.[TelephoneDay]  is null and f.[TelephoneDay] is not null) or (a.[TelephoneDay]  is not null and f.[TelephoneDay] is null) or  (a.[TelephoneDay] != f.[TelephoneDay])
or (a.[TelephoneEvening]  is null and f.[TelephoneEvening] is not null) or (a.[TelephoneEvening]  is not null and f.[TelephoneEvening] is null) or  (a.[TelephoneEvening] != f.[TelephoneEvening])
or (a.[Email]  is null and f.[Email] is not null) or (a.[Email]  is not null and f.[Email] is null) or  (a.[Email] != f.[Email])
or (a.[DOB]  is null and f.[DOB] is not null) or (a.[DOB]  is not null and f.[DOB] is null) or  (a.[DOB] != f.[DOB])
or (a.[Gender]  is null and f.[Gender] is not null) or (a.[Gender]  is not null and f.[Gender] is null) or  (a.[Gender] != f.[Gender])
or (a.[ClientRespondentID]  is null and f.[ClientRespondentID] is not null) or (a.[ClientRespondentID]  is not null and f.[ClientRespondentID] is null) or  (a.[ClientRespondentID] != f.[ClientRespondentID])
or (a.[SSN]  is null and f.[SSN] is not null) or (a.[SSN]  is not null and f.[SSN] is null) or  (a.[SSN] != f.[SSN])
or (a.[BatchID]  is null and f.[BatchID] is not null) or (a.[BatchID]  is not null and f.[BatchID] is null) or  (a.[BatchID] != f.[BatchID])
or (a.[MailingSeedFlag]  is null and f.[MailingSeedFlag] is not null) or (a.[MailingSeedFlag]  is not null and f.[MailingSeedFlag] is null) or  (a.[MailingSeedFlag] != f.[MailingSeedFlag])
or  a.[CallsMade] != f.[CallsMade]
or  a.[Final] != f.[Final]
or (a.[NextContact]  is null and f.[NextContact] is not null) or (a.[NextContact]  is not null and f.[NextContact] is null) or  (a.[NextContact] != f.[NextContact])
or (a.[PostalCodeExt]  is null and f.[PostalCodeExt] is not null) or (a.[PostalCodeExt]  is not null and f.[PostalCodeExt] is null) or  (a.[PostalCodeExt] != f.[PostalCodeExt])
or (a.[RespondentKey]  is null and f.[RespondentKey] is not null) or (a.[RespondentKey]  is not null and f.[RespondentKey] is null) or  (a.[RespondentKey] != f.[RespondentKey])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.Respondents_jn a
where not exists (select ''x''
from  Respondents_jn b
 where 
     a.[RespondentID]= b.[RespondentID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           Respondents done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
