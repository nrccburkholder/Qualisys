/****** Object:  StoredProcedure [dbo].[FileDefs_pn]    Script Date: 08/09/2006 15:15:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FileDefs_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[FileDefs_pn]
GO
/****** Object:  StoredProcedure [dbo].[FileDefs_pn]    Script Date: 08/09/2006 15:15:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[FileDefs_pn]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure FileDefs_pn(@mode int) /*
Mode for journalled table setups:
 0 - full, 1 - incremental , 2 - delete from old system, 
3 - force direct copy , 4 - verify, 5 - verify journal



Basically,  we do type 0 when we are doing a fresh flush,  or we are moving the data
and basically,  we do 1 when we are flushing.  We can do a mode 3 if the base tables are out of whack
and we want to fix it regardless of the journal records.

4 will show all differences between the production tables,  and 5 will show the difference between the journalled tables.


Table:       FileDefs
Source:      goliath.qms.dbo
Destination: 
 */
as
begin

set nocount off
print ''vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv''
print ''           FileDefs''


declare @jn_operation varchar(1)
declare @jn_user varchar(100)
declare @jn_datetime datetime
declare @jn_endtime datetime 
declare @jn_notes varchar(240)
declare @jn_appln varchar(30)
declare @jn_session smallint
declare @FileDefID int
declare @FileDefName varchar(200)
declare @FileDefDescription varchar(200)
declare @ClientID int
declare @SurveyID int
declare @FileDefTypeID int
declare @FileTypeID int
declare @FileDefDelimiter char(1)

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
		  from FileDefs_jn
		  if @jn_mindate > dateadd(hour,-1,getdate())
			begin
			set @jn_mindate = dateadd(hour,-1,getdate())
			end
	  end
		else
		  begin
		  select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		  from goliath.qms.dbo.FileDefs_jn
		  end
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
	
declare read_main cursor for
select jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [FileDefID]
,[FileDefName]
,[FileDefDescription]
,[ClientID]
,[SurveyID]
,[FileDefTypeID]
,[FileTypeID]
,[FileDefDelimiter]
from goliath.qms.dbo.FileDefs_jl where jn_datetime >= @jn_mindate
open read_main
set @jn_loop_count=0

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @FileDefID
,@FileDefName
,@FileDefDescription
,@ClientID
,@SurveyID
,@FileDefTypeID
,@FileTypeID
,@FileDefDelimiter
while @@fetch_status=0
  begin

if (@jn_loop_count % 100) = 0
  begin
  print ''FileDefs_jn '' + convert(varchar(10),@jn_loop_count) + '' '' 
    + convert(varchar(100),@jn_datetime)
  end
set @jn_loop_count = @jn_loop_count + 1

	
		/* replace existing FileDefs_jn */
		delete 
		from FileDefs_jn
		where 
[FileDefID] = @FileDefID
           and jn_datetime = @jn_datetime
	
	

		/* now update the prior end date */
		update a
		set jn_endtime= (select min(jn_datetime)
           		from (select jn_datetime from FileDefs_jn b
			where 
     a.[FileDefID]= b.[FileDefID]
 and a.jn_datetime <= b.jn_datetime 
union all select @jn_datetime where @jn_datetime >= a.jn_datetime) c )
from FileDefs_jn a
where
a.[FileDefID] = @FileDefID
/*and a.jn_endtime> @jn_datetime*/ 
		

		
	
	
	
	
	
	

/* now see if this journal record is the latest and greatest.
*/

select  @jn_endtime = min(@jn_datetime) from FileDefs_jn 
where 
[FileDefID] = @FileDefID
 and jn_datetime > @jn_datetime
if @jn_endtime is null
begin
set @jn_endtime = CAST(''2500-12-27 12:00:00.000''
  AS datetime)


	if @jn_operation = ''D''
	begin
		delete from FileDefs
		where 
[FileDefID] = @FileDefID
end
else
begin
	
			update FileDefs
			set 
   [FileDefName]= @FileDefName
,  [FileDefDescription]= @FileDefDescription
,  [ClientID]= @ClientID
,  [SurveyID]= @SurveyID
,  [FileDefTypeID]= @FileDefTypeID
,  [FileTypeID]= @FileTypeID
,  [FileDefDelimiter]= @FileDefDelimiter
		where 
[FileDefID] = @FileDefID

		
		
		
		

		
		insert into FileDefs (
 [FileDefID]
,[FileDefName]
,[FileDefDescription]
,[ClientID]
,[SurveyID]
,[FileDefTypeID]
,[FileTypeID]
,[FileDefDelimiter]
)
		select 
 @FileDefID
,@FileDefName
,@FileDefDescription
,@ClientID
,@SurveyID
,@FileDefTypeID
,@FileTypeID
,@FileDefDelimiter
where not exists (Select ''x'' from FileDefs where 
[FileDefID] = @FileDefID
)



end


end /* if we are the most recent record,  and therefore have to update the base tables */
	
	insert into FileDefs_jn(jn_operation,jn_user,jn_datetime,jn_endtime,jn_notes,jn_appln,jn_session,
 [FileDefID]
,[FileDefName]
,[FileDefDescription]
,[ClientID]
,[SurveyID]
,[FileDefTypeID]
,[FileTypeID]
,[FileDefDelimiter]
)
values (
@jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @FileDefID
,@FileDefName
,@FileDefDescription
,@ClientID
,@SurveyID
,@FileDefTypeID
,@FileTypeID
,@FileDefDelimiter
)

fetch read_main into @jn_operation,@jn_user,@jn_datetime,@jn_endtime,@jn_notes,@jn_appln,@jn_session,
 @FileDefID
,@FileDefName
,@FileDefDescription
,@ClientID
,@SurveyID
,@FileDefTypeID
,@FileTypeID
,@FileDefDelimiter

end
close read_main
deallocate read_main

  print ''FileDefs_jn DONE with '' + convert(varchar(10),@jn_loop_count) + '' last date  '' 
    + convert(varchar(100),@jn_datetime)
		
		end
	else if (@mode = 2)
		begin
	
	
	

		select @jn_mindate = isnull(min(jn_datetime),''10-jun-2500'')
		from goliath.qms.dbo.FileDefs_jn
		
		select @jn_maxdate = isnull(max(jn_datetime),''10-jun-1970'')
		from FileDefs_jn
		
		
		print ''mindate is '' + convert(varchar(20),@jn_mindate)
		print ''maxdate is '' + convert(varchar(20),@jn_maxdate)
		
		print ''deleting from production''
		/* If the row is in both tables,  we can delete it */
		delete a
		from goliath.qms.dbo.FileDefs_jn  a,
		FileDefs_jn  b
		where a.jn_datetime >= @jn_mindate
		and a.jn_datetime < @jn_maxdate
		and b.jn_datetime >= @jn_mindate
		and b.jn_datetime < @jn_maxdate
		and a.jn_datetime = b.jn_datetime
	        and 
     a.[FileDefID]= b.[FileDefID]
end
else if (@mode = 3)
begin
print ''doing a sync of the base tables and ignoring the journalls:''

print ''Step 1: sync deletes''



delete a
from FileDefs a
where not exists (
select ''x''
from goliath.qms.dbo.FileDefs b
where 
     a.[FileDefID]= b.[FileDefID]
)





print '' step 2: update ''

	update f 
	set 
   f.[FileDefName]= a.[FileDefName]
,  f.[FileDefDescription]= a.[FileDefDescription]
,  f.[ClientID]= a.[ClientID]
,  f.[SurveyID]= a.[SurveyID]
,  f.[FileDefTypeID]= a.[FileDefTypeID]
,  f.[FileTypeID]= a.[FileTypeID]
,  f.[FileDefDelimiter]= a.[FileDefDelimiter]
 from FileDefs f,goliath.qms.dbo.FileDefs a
	where 
     a.[FileDefID]= f.[FileDefID]
and (
   a.[FileDefName] != f.[FileDefName]
or  a.[FileDefDescription] != f.[FileDefDescription]
or (a.[ClientID]  is null and f.[ClientID] is not null) or (a.[ClientID]  is not null and f.[ClientID] is null) or  (a.[ClientID] != f.[ClientID])
or (a.[SurveyID]  is null and f.[SurveyID] is not null) or (a.[SurveyID]  is not null and f.[SurveyID] is null) or  (a.[SurveyID] != f.[SurveyID])
or  a.[FileDefTypeID] != f.[FileDefTypeID]
or  a.[FileTypeID] != f.[FileTypeID]
or (a.[FileDefDelimiter]  is null and f.[FileDefDelimiter] is not null) or (a.[FileDefDelimiter]  is not null and f.[FileDefDelimiter] is null) or  (a.[FileDefDelimiter] != f.[FileDefDelimiter])
)
	
	
	

print '' Step 3: insert''
insert into FileDefs(
 [FileDefID]
,[FileDefName]
,[FileDefDescription]
,[ClientID]
,[SurveyID]
,[FileDefTypeID]
,[FileTypeID]
,[FileDefDelimiter]
)
select 
 a.[FileDefID]
,a.[FileDefName]
,a.[FileDefDescription]
,a.[ClientID]
,a.[SurveyID]
,a.[FileDefTypeID]
,a.[FileTypeID]
,a.[FileDefDelimiter]
 from goliath.qms.dbo.FileDefs a
where not exists (select ''x''
from  FileDefs b
 where 
     a.[FileDefID]= b.[FileDefID]

)
end
else if (@mode = 4)
begin
print ''doing a verify of the base tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from FileDefs a
where not exists (
select ''x''
from goliath.qms.dbo.FileDefs b
where 
     a.[FileDefID]= b.[FileDefID]
)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from FileDefs f,goliath.qms.dbo.FileDefs a
	where 
     a.[FileDefID]= f.[FileDefID]
and (
   a.[FileDefName] != f.[FileDefName]
or  a.[FileDefDescription] != f.[FileDefDescription]
or (a.[ClientID]  is null and f.[ClientID] is not null) or (a.[ClientID]  is not null and f.[ClientID] is null) or  (a.[ClientID] != f.[ClientID])
or (a.[SurveyID]  is null and f.[SurveyID] is not null) or (a.[SurveyID]  is not null and f.[SurveyID] is null) or  (a.[SurveyID] != f.[SurveyID])
or  a.[FileDefTypeID] != f.[FileDefTypeID]
or  a.[FileTypeID] != f.[FileTypeID]
or (a.[FileDefDelimiter]  is null and f.[FileDefDelimiter] is not null) or (a.[FileDefDelimiter]  is not null and f.[FileDefDelimiter] is null) or  (a.[FileDefDelimiter] != f.[FileDefDelimiter])
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.FileDefs a
where not exists (select ''x''
from  FileDefs b
 where 
     a.[FileDefID]= b.[FileDefID]
)
end
else if (@mode = 5)
begin
print ''doing a verify of the journal tables:''

print ''Step 1: sync deletes''



select ''D'' actiontotake,a.*
from FileDefs_jn a
where not exists (
select ''x''
from goliath.qms.dbo.FileDefs_jn b
where 
     a.[FileDefID]= b.[FileDefID]
and a.jn_datetime = b.jn_datetime)





print '' step 2: update ''

	select ''U'' actiontotake,f.*,a.*
 from FileDefs_jn f,goliath.qms.dbo.FileDefs_jn a
	where 
     a.[FileDefID]= f.[FileDefID]
and a.jn_datetime = f.jn_datetime and (
   a.[FileDefName] != f.[FileDefName]
or  a.[FileDefDescription] != f.[FileDefDescription]
or (a.[ClientID]  is null and f.[ClientID] is not null) or (a.[ClientID]  is not null and f.[ClientID] is null) or  (a.[ClientID] != f.[ClientID])
or (a.[SurveyID]  is null and f.[SurveyID] is not null) or (a.[SurveyID]  is not null and f.[SurveyID] is null) or  (a.[SurveyID] != f.[SurveyID])
or  a.[FileDefTypeID] != f.[FileDefTypeID]
or  a.[FileTypeID] != f.[FileTypeID]
or (a.[FileDefDelimiter]  is null and f.[FileDefDelimiter] is not null) or (a.[FileDefDelimiter]  is not null and f.[FileDefDelimiter] is null) or  (a.[FileDefDelimiter] != f.[FileDefDelimiter])
 and
 f.jn_datetime != a.jn_datetime
)
	
	
	

print '' Step 3: insert''
select ''I'' actiontotake,*
 from goliath.qms.dbo.FileDefs_jn a
where not exists (select ''x''
from  FileDefs_jn b
 where 
     a.[FileDefID]= b.[FileDefID]
 and a.jn_datetime = b.jn_datetime)
end
else 
begin
print '' Bogus mode!!!''
end

print ''           FileDefs done''
print ''^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




''

end


' 
END
GO
